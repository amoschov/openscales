package org.openscales.fx {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.Container;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.IControl;
	import org.openscales.core.layer.Layer;
	import org.openscales.fx.control.FxControl;
	import org.openscales.fx.handler.FxHandler;
	import org.openscales.fx.layer.FxLayer;

	public class FxMap extends Container {
		
		private var _map:Map;
			
		private var _maxResolution:Number = NaN;
		
		private var _numZoomLevels:Number = NaN;
		
		private var _zoom:Number = NaN;
		
		private var _lon:Number = NaN;
		
		private var _lat:Number = NaN;
		
		private var _creationHeight:Number = NaN;
		
		private var _creationWidth:Number = NaN;
				
		public function FxMap() {
			super();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:Event):void {
			this.addEventListener(ResizeEvent.RESIZE, onResize);
		}
		
		private function onResize(event:ResizeEvent):void {
			var o:DisplayObject = event.target as DisplayObject;
			this.map.size = new Size(o.width, o.height);
		}
		
		override protected function createChildren():void
		{
			
			this._map = new Map();
			this.rawChildren.addChild(this._map);
			super.createChildren();
						
			if(!isNaN(this._maxResolution))
				this.map.maxResolution = this._maxResolution;
				
			if(!isNaN(this._numZoomLevels))
				this.map.numZoomLevels = this._numZoomLevels;
				
			// Some operations must be done at the beginning, in order to do
			// not depend on declaration order
			for(var i:int=0; i < this.rawChildren.numChildren ; i++) {
				var child:DisplayObject = this.rawChildren.getChildAt(i);
				if(child is FxMaxExtent) {
					this.map.maxExtent = (child as FxMaxExtent).bounds;
				}
			}
				
			for(i=0; i < this.rawChildren.numChildren ; i++) {
				child = this.rawChildren.getChildAt(i);
				if(child is FxLayer) {
					var layer:Layer = (child as FxLayer).getInstance();
					layer.name = (child as FxLayer).name;
					this.map.addLayer(layer);
				} else if(child is FxControl) {
					this.map.addControl((child as FxControl).control);
				} else if(child is IControl) {
					this.map.addControl(child as IControl, false);
				} else if(child is FxHandler) {
					this.map.addHandler((child as FxHandler).handler);
				}
				
			}
			
			if(!isNaN(this._lon) && !isNaN(this._lat))
				this.map.setCenter(new LonLat(this._lon, this._lat), _zoom);
				
			if(!isNaN(this._creationWidth) && !isNaN(this._creationHeight))
				this.map.size = new Size(this._creationWidth, this._creationHeight);
				
			if(!isNaN(this._zoom))
				this.map.zoom = this._zoom;
				
			// Some operations must be done at the end, in order to do
			// not depend on declaration order
			for(i=0; i < this.rawChildren.numChildren ; i++) {
				child = this.rawChildren.getChildAt(i);
				if(child is FxExtent) {
					// FIXME : it works in the MXML code but not here. Called to early ???					
					this.map.zoomToExtent((child as FxExtent).bounds);
				}
			}
			
		}
						
		public function get map():Map {
			return this._map;
		}
		
		public function set maxResolution(value:Number):void {
			this._maxResolution = value;
		}
		
		public function set numZoomLevels(value:Number):void {
			this._numZoomLevels = value;
		}
		
		public function set zoom(value:Number):void {
			this._zoom = value;
		}
		
		public function set lon(value:Number):void {
			this._lon = value;
		}
		
		public function set lat(value:Number):void {
			this._lat = value;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			if(map != null)
				this.map.width = value;
			else
				this._creationWidth = value;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			if(map != null)
				this.map.height = value;
			else
				this._creationHeight = value;
		
		}
			
	}
}