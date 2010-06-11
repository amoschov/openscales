package org.openscales.fx
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import org.openscales.basetypes.Bounds;
	import org.openscales.basetypes.LonLat;
	import org.openscales.basetypes.Size;
	import org.openscales.component.control.Control;
	import org.openscales.component.control.TraceInfo;
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.control.IControl;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.security.ISecurity;
	import org.openscales.fx.configuration.FxConfiguration;
	import org.openscales.fx.control.FxControl;
	import org.openscales.fx.handler.FxHandler;
	import org.openscales.fx.layer.FxLayer;
	import org.openscales.fx.security.FxAbstractSecurity;
	import org.openscales.proj4as.ProjProjection;
	
	/**
	 * Flex wrapper in order to create OpenScales MXML based applications.
	 * 
	 * It is ready to use after it throw an Event.COMPLETE event.
	 */
	 [Event(name="openscalesmaploadstart", type="org.openscales.core.events.MapEvent")]
	 [Event(name="openscalesmaploadcomplete", type="org.openscales.core.events.MapEvent")]

	public class FxMap extends Container
	{
		private var _map:Map;
		private var _zoom:Number = NaN;
		private var _centerLonLat:LonLat = null;
		private var _creationHeight:Number = NaN;
		private var _creationWidth:Number = NaN;
		private var _proxy:String = "";
		private var _maxExtent:Bounds = null;
		
		/**
		 * FxMap constructor
		 */
		public function FxMap() {
			super();
			// Fix for issue 114: Error at startup when window is too small
			this.clipContent = false;
			// Useful for a Map only defined with width="100%" or "height="100%"
			this.minWidth = 100;
			this.minHeight = 100;
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}

		/**
		 * After CreationComplete, addChild is restricted to the insertion of a
		 * new FxLayer
		 */		
		override public function addChild(child:DisplayObject):DisplayObject {
			if (! this._map) {
				return super.addChild(child);
			}
			
			// Only layers lay be added
			if (! (child is FxLayer)) {
				Trace.warning("Invalid child to add : only FxLayer may be added to FxMap");
				return child;
			}
			// Add the layer/baselayer
			//super.addChild(child);
			addFxLayer(child as FxLayer);
			return child;
		}
		
		/**
		 * After CreationComplete, the insertion order is not managed and
		 * addChild is called
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			return (this._map) ? addChild(child) : super.addChildAt(child,index);
		}
		
		/**
		 * Add a layer to the map
		 */
		private function addFxLayer(l:FxLayer):void {
			// Add the layer to the map
			l.fxmap = this;
			l.configureLayer();
			this._map.addLayer(l.layer);
		}
		
		/**
		 * 
		 */
		private function onCreationComplete(event:Event):void {
			this._map = new Map(this.width, this.height);
			_map.addEventListener(MapEvent.LOAD_START, loadEventHandler);
			_map.addEventListener(MapEvent.LOAD_END, loadEventHandler);
			
			var i:int = 0;
			var child:DisplayObject = null;
			
			// Add traceInfo at the begining in order to trace loading logs
			for(i=0; i<this.rawChildren.numChildren; i++) {
				child = this.rawChildren.getChildAt(i);
				if (child is TraceInfo) {
					(child as TraceInfo).map = this._map;
					this.parent.addChild(child);
				}
			}
			// override configuration with a Flex aware configuration
			this._map.configuration = new FxConfiguration();
			
			this.rawChildren.addChild(this._map);
						
			if (this._proxy != "")
				this._map.proxy = this._proxy;
				
			// Some operations must be done at the begining, in order to not
			// depend on the declaration order
			if (this._maxExtent != null)
				this._map.maxExtent = this._maxExtent;
			else {
				var maxExtentDefined:Boolean = false;
				for(i=0; (!maxExtentDefined) && (i<this.rawChildren.numChildren); i++) {
					child = this.rawChildren.getChildAt(i);
					if (child is FxMaxExtent) {
						this._map.maxExtent = (child as FxMaxExtent).bounds;
						maxExtentDefined = true;
					}
				}
			}
			
			if (!isNaN(this._creationWidth) && !isNaN(this._creationHeight))
				this._map.size = new Size(this._creationWidth, this._creationHeight);
			
			// We use an interlediate Array in order to avoid adding new component it the loop
			// because it will modify numChildren
			var componentToAdd:Array = new Array();
			
			for(i=0; i<this.rawChildren.numChildren; i++) {
				child = this.rawChildren.getChildAt(i);
				if (child is FxLayer) {
					// Overlays must be added after all the baseLayers
					if ((child as FxLayer).layer.isBaseLayer) {
						this.addFxLayer(child as FxLayer);
					}
				} else if (child is FxControl) {
					this._map.addControl((child as FxControl).control);
				} else if (child is IControl) {
					this._map.addControl(child as IControl, false);
				// Add Control, wih exception of TraceInfo that has been added at the beginning
				} else if ((child is Control) && !(child is TraceInfo)){
					this.parent.addChild(child);
					// Tweak in order to compense the addChild that remove the child from this to addd it to the parent
					// Quote from DisplayerObectContainer asDoc : if you add a child object that already has a different display object container as a parent, the object is removed from the child list of the other display object container.
					i--;
				} else if (child is FxHandler) {
					(child as FxHandler).handler.map = this._map;
				} else if ((child is UIComponent) && !(child is Map) && !(child is FxMaxExtent) && !(child is FxExtent) && !(child is FxAbstractSecurity) ){
					this.parent.addChild(child);
					// Tweak in order to compense the addChild that remove the child from this to addd it to the parent
					// Quote from DisplayerObectContainer asDoc : if you add a child object that already has a different display object container as a parent, the object is removed from the child list of the other display object container.
					i--;
				}
			}
			
			// Some operations must be done at the end, in order to not depend
			// on the declaration order
			for(i=0; i<this.rawChildren.numChildren; i++) {
				child = this.rawChildren.getChildAt(i);
				if (child is FxLayer) {
					var l:FxLayer = child as FxLayer;
					
					// BaseLayers have been added at the begining
					if (! l.layer.isBaseLayer) {
						this.addFxLayer(child as FxLayer);
					}
				}
			}
			
			for(i=0; i<this.rawChildren.numChildren; i++) {
				child = this.rawChildren.getChildAt(i);
			
			 	if (child is FxAbstractSecurity){
					var fxSecurity:FxAbstractSecurity = (child as FxAbstractSecurity);
					fxSecurity.map = this._map;
					var security:ISecurity = fxSecurity.security;
					var layers:Array = fxSecurity.layers.split(",");
					var layer:Layer = null;
					 for each (var name:String in layers) {
						layer = map.getLayerByName(name);
						if(layer) {
							(child as FxAbstractSecurity).map = this._map;
							layer.security = security;
						}
					 }
				}
			}
						
			// Set both center and zoom to avoid invalid request set when we define both separately
			var mapCenter:LonLat = this._centerLonLat;
			if (mapCenter && this._map.baseLayer) {
				mapCenter.transform(new ProjProjection("EPSG:4326"), this._map.baseLayer.projection);
			}
			if (mapCenter || (! isNaN(this._zoom))) {
				this._map.setCenter(mapCenter, this._zoom);
			}
			
			var extentDefined:Boolean = false;
			for(i=0; (!extentDefined) && (i<this.rawChildren.numChildren); i++) {
				child = this.rawChildren.getChildAt(i);
				if (child is FxExtent) {
					this._map.zoomToExtent((child as FxExtent).bounds);
					extentDefined = true;
				}
			}
			
			this.addEventListener(ResizeEvent.RESIZE, this.onResize);
		}
		
		private function onResize(event:ResizeEvent):void {
			var o:DisplayObject = event.target as DisplayObject;
			this._map.size = new Size(o.width, o.height);
		}
		
		private function loadEventHandler(event:MapEvent):void
		{
			dispatchEvent(new MapEvent(event.type, event.map));
		}
		
		public function get map():Map {
			return this._map;
		}
		
		public function set zoom(value:Number):void {
			this._zoom = value;
		}
		
		/**
		 * Set the center of the map using its longitude and its latitude.
		 * 
		 * @param value a string of two coordinates separated by a coma, in
		 * WGS84 = EPSG:4326 only (not in the SRS of the base layer) !
		 */
		public function set centerLonLat(value:String):void {
			var strCenterLonLat:Array = value.split(",");
			if (strCenterLonLat.length != 2) {
				Trace.error("Map.centerLonLat: invalid number of components");
				return ;
			}
			_centerLonLat = new LonLat(Number(strCenterLonLat[0]), Number(strCenterLonLat[1]));
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			if (map != null)
				this._map.width = value;
			else
				this._creationWidth = value;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			if (map != null)
				this._map.height = value;
			else
				this._creationHeight = value;
		}
		
		public function set proxy(value:String):void {
			this._proxy = value;
		}
		
		public function set maxExtent(value:String):void {
			this._maxExtent = Bounds.getBoundsFromString(value);
		}
		
	}
}
