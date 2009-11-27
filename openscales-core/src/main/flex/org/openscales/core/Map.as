package org.openscales.core
{
	import com.gskinner.motion.GTweeny;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.DraggableSprite;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.basetypes.Unit;
	import org.openscales.core.configuration.Configuration;
	import org.openscales.core.configuration.IConfiguration;
	import org.openscales.core.control.IControl;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.handler.IHandler;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.popup.Popup;
	import org.openscales.core.security.ISecurity;

	/**
	 * Instances of Map are interactive maps that can be embedded in a web pages or in
	 * Flex or AIR applications.
	 *
	 * Create a new map with the Map constructor.
	 *
	 * To extend a map, it's necessary to add controls (Control), handlers (Handler) and
	 * layers (Layer) to the map.
	 *
	 * Map is a pure ActionScript class. Flex wrapper and components can be found in the
	 * openscales-fx module.
	 */
	public class Map extends Sprite
	{
		public var IMAGE_RELOAD_ATTEMPTS:Number = 0;

		/**
		 * The lonlat at which the layer container was re-initialized (on-zoom)
		 */
		private var _layerContainerOrigin:LonLat = null;

		private var _baseLayer:Layer = null;
		private var _layerContainer:DraggableSprite = null;
		private var _controls:Array = null;
		private var _handlers:Array = null;
		private var _size:Size = null;
		private var _zoom:Number = 0;
		private var _zooming:Boolean = false;
		private var _loading:Boolean;
		private var _center:LonLat = null;
		private var _maxExtent:Bounds = null;
		
		/**
		 * Enable tween effect when zooming
		 */
		private var _tweenZoomEnabled:Boolean = true;
		
		private var _proxy:String = null;
		private var _bitmapTransition:DraggableSprite;
		private var _configuration:IConfiguration;
		
		private var _securities:Array=new Array();
		/**
		 * Map constructor
		 *
		 * @param width the map's width in pixels
		 * @param height the map's height in pixels
		 */
		public function Map(width:Number=600, height:Number=400) {
			super();
			
			this._controls = new Array();
			this._handlers = new Array();
			this._securities=new Array();
			this.size = new Size(width, height);
			
			this._layerContainer = new DraggableSprite();
			// It is necessary to draw something before to define the size...
			this._layerContainer.graphics.beginFill(0xFFFFFF,0);
			this._layerContainer.graphics.drawRect(0,0,this.size.w,this.size.h);
			this._layerContainer.graphics.endFill();
			// ... and then the size may be defined.
			this._layerContainer.width = this.size.w;
			this._layerContainer.height = this.size.h;
			// The sprite is now fully defined.
			this.addChild(this._layerContainer);
			
			this.addEventListener(LayerEvent.LAYER_LOAD_START,layerLoadHandler);
			this.addEventListener(LayerEvent.LAYER_LOAD_END,layerLoadHandler);						
			
			Trace.map = this;
			
			this._configuration = new Configuration();
		}

		private function destroy():Boolean {
			if (this.layers != null) {
				for (var i:int = this.layers.length - 1; i>=0; i--) {
					this.layers[i].destroy(false);
				}
			}
			if (this._controls != null) {
				for (var j:int = this._controls.length - 1; j>=0; j--) {
					this._controls[j].destroy();
				}
				this._controls = null;
			}
			return true;
		}

		// Layer management

		/**
		 * Add a new layer to the map.
		 * A LayerEvent.LAYER_ADDED event is triggered.
		 *
		 * @param layer The layer to add.
		 * @return true if the layer have been added, false if it has not.
		 */
		public function addLayer(layer:Layer):Boolean {
			for(var i:int=0; i < this.layers.length; i++) {
				if (this.layers[i] == layer) {
					return false;
				}
			}

			this._layerContainer.addChild(layer);

			if(layer.proxy == null)
				layer.proxy = this.proxy;

			layer.map = this;

			if (layer.isBaseLayer) {
				if (this.baseLayer == null) {
					this.baseLayer = layer;
				} else {
					layer.visible = false;
					layer.zindex = 0; 
				}
			}
			//commit temporaly to correct the fact if you  add layer dynamicaly (wms/wmcs) , that not draw the layer
			if(layer.visible){
			  layer.redraw();	
			}
            
			this.dispatchEvent(new LayerEvent(LayerEvent.LAYER_ADDED, layer));

			return true;
		}

		/**
		 * Add a group of layers.
		 * @param layers to add.
		 */
		public function addLayers(layers:Array):void {
			for (var i:int = 0; i <  layers.length; i++) {
				this.addLayer(layers[i]);
			}
		}

		/**
		 * Allows user to specify one of the currently-loaded layers as the Map's
		 * new base layer.
		 *
		 * @param newBaseLayer the new base layer.
		 */
		public function set baseLayer(newBaseLayer:Layer):void {
			if (! newBaseLayer) {
				return;
			}
			
			var oldExtent:Bounds = (this.baseLayer) ? this.baseLayer.extent : null;
			
			if (this.bitmapTransition != null)
				this.bitmapTransition.alpha = 0;
			
			if (newBaseLayer != this.baseLayer) {
				if (Util.indexOf(this.layers, newBaseLayer) != -1) {
					// if we set a baselayer with a different projection, we
					// change the map's projected datas
					if (this.baseLayer) {
						if ((this.baseLayer.projection.srsCode != newBaseLayer.projection.srsCode)
							||(newBaseLayer.resolutions==null)) {
							// FixMe : why testing (newBaseLayer.resolutions==null) ?
							if (this.center != null)
								this.center.transform(this.baseLayer.projection, newBaseLayer.projection);
	
							if (this._layerContainerOrigin != null)
								this._layerContainerOrigin.transform(this.baseLayer.projection, newBaseLayer.projection);
							
							oldExtent = null;
	                        this.maxExtent = newBaseLayer.maxExtent;
						}
					}

					this._baseLayer = newBaseLayer;
					this._baseLayer.visible = true;

					var center:LonLat = this.center;
					if (center != null) {
						if (oldExtent == null) {
							this.setCenter(center, this.zoom, false, true);
						} else {
							this.setCenter(oldExtent.centerLonLat,
								this.getZoomForExtent(oldExtent),
								false, true);
						}
					} else {
						// The map must be fully defined as soon as its baseLayer is defined
						this.setCenter(this._baseLayer.maxExtent.centerLonLat,
							this.getZoomForExtent(this._baseLayer.maxExtent),
							false, true);
					}

					this.dispatchEvent(new LayerEvent(LayerEvent.BASE_LAYER_CHANGED, newBaseLayer));
				}
			}
		}

		/**
		 * The currently selected base layer.
		 * A BaseLayer is a special kind of Layer that determines the projection,
		 * min/max zoom level, etc...
		 */
		public function get baseLayer():Layer {
			return this._baseLayer;
		}

		/**
		 * Get a layer from its name.
		 * @param name the layer name to find.
		 * @return the found layer. Null if no layer have been found.
		 *
		 */
		public function getLayerByName(name:String):Layer {
			var foundLayer:Layer = null;
			for (var i:int = 0; i < this.layers.length; i++) {
				var layer:Layer = this.layers[i];
				if (layer.name == name) {
					foundLayer = layer;
				}
			}
			return foundLayer;
		}

		/**
		 * Removes a layer from the map by removing its visual element, then removing
		 * it from the map's internal list of layers, setting the layer's map property
		 * to null.
		 *
		 * A LayerEvent.LAYER_REMOVED event is triggered.
		 *
		 * @param layer the layer to remove.
		 * @param setNewBaseLayer if set to true, a new base layer will be set if the removed
		 * 	layer was a based layer
		 */
		public function removeLayer(layer:Layer, setNewBaseLayer:Boolean = true):void {
			this._layerContainer.removeChild(layer);
			layer.map = null;
			Util.removeItem(this.layers, layer);

			if (setNewBaseLayer && (this.baseLayer == layer)) {
				this._baseLayer = null;
				for(var i:int=0; i < this.layers.length; i++) {
					var iLayer:Layer = this.layers[i];
					if (iLayer.isBaseLayer) {
						this.baseLayer = iLayer;
						break;
					}
				}
			}

			this.dispatchEvent(new LayerEvent(LayerEvent.LAYER_REMOVED, layer));
		}

		public function removeAllLayers():void {
			for(var i:int=this.layers.length-1; i>=0; i--) {
				removeLayer(this.layers[i], false);
			}
		}
		
		/**
		 * Add a new control to the map.
		 *
		 * @param control the control to add.
		 * @param attach if true, the control will be added as child component of the map. This
		 *  parameter may be for example set to false when adding a Flex component displayed
		 *  outside the map.
		 */
		public function addControl(control:IControl, attach:Boolean=true):void {
			// Is the input control valid ?
			if (! control) {
				Trace.warning("Map.addControl: null control not added");
				return;
			}
			/*if (control.map != this) {
				Trace.error("Map.addControl: control not added because it is associated to an other map");
				return;
			}*/
			// Is the input control already rgistered ?
			// Or an other control of the same type ?
			var i:int;
			for (i=0; i<this.controls.length; i++) {
				if (control == this.controls[i]) {
					Trace.warning("Map.addControl: this control is already registered ("+getQualifiedClassName(control)+")");
					return;
				}
				if (getQualifiedClassName(control) == getQualifiedClassName(this.controls[i])) {
					Trace.warning("Map.addControl: an other control is already registered for "+getQualifiedClassName(control));
					return;
				}
			}
			// If the control is a new control, register it
			if (i == this.controls.length) {
				Trace.log("Map.addControl: add a new control "+getQualifiedClassName(control));
				this._controls.push(control);
				control.map = this;
				control.draw();
				if (attach) {
					this.addChild(control as Sprite);
				}
			}
		}
		
		/**
		 * Register a handler as one of the handlers of the map.
		 * The handler must have its map property setted to this before.
		 * The handler is not automatically activated. If needed, you have to do
		 * it by using the active setter of the handler.
		 * This function should only be called by the Handler.map setter !
		 *  
		 * @param handler the handler to add.
		 */
		public function addHandler(handler:IHandler):void {
			// Is the input handler valid ?
			if (! handler) {
				Trace.warning("Map.addHandler: null handler not added");
				return;
			}
			if (handler.map != this) {
				Trace.error("Map.addHandler: handler not added because it is associated to an other map");
				return;
			}
			// Is the input handler already rgistered ?
			// Or an other handler of the same type ?
			var i:int;
			for (i=0; i<this.handlers.length; i++) {
				if (handler == this.handlers[i]) {
					Trace.warning("Map.addHandler: this handler is already registered ("+getQualifiedClassName(handler)+")");
					return;
				}
				if (getQualifiedClassName(handler) == getQualifiedClassName(this.handlers[i])) {
					Trace.warning("Map.addHandler: an other handler is already registered for "+getQualifiedClassName(handler));
					return;
				}
			}
			// If the handler is a new handler, register it
			if (i == this.handlers.length) {
				Trace.log("Map.addHandler: add a new handler "+getQualifiedClassName(handler));
				this._handlers.push(handler);
				//handler.map = this; // this is done by the Handler.map setter
			}
		}
		
		/**
		 * Unregister a handler as one of the handlers of the map.
		 * The handler must have its map property setted null before or after.
		 * The handler is not automatically deactivated. You have to do it by
		 * using the active setter of the handler.
		 * This function should only be called by the Handler.map setter !
		 * 
		 * @param handler the handler to remove.
		 */
		public function removeHandler(handler:IHandler):void {
			var newHandlers:Array = new Array();
			for each (var mapHandler:IHandler in this.handlers) {
				if (mapHandler == handler) {
					handler.active = false;
					handler.map = null;
				} else {
					newHandlers.push(mapHandler);
				}
			}
			this._handlers = newHandlers;
		}

		/**
		 * @param {OpenLayers.Popup} popup
		 * @param {Boolean} exclusive If true, closes all other popups first
		 **/
		public function addPopup(popup:Popup, exclusive:Boolean = true):void {
			var i:Number;
			if(exclusive){
				var child:DisplayObject;
				for(i=this._layerContainer.numChildren-1;i>=0;i--){
					child = this._layerContainer.getChildAt(i);
					if(child is Popup){
						if(child != popup) {
							Trace.warning("Map.addPopup: popup already displayed so escape");
							return;
						}
						this.removePopup(child as Popup);
					}
				}
			}
			if (popup != null){
				popup.map = this;
				popup.draw();
				this._layerContainer.addChild(popup);
			}
		}

		public function removePopup(popup:Popup):void {
			this._layerContainer.removeChild(popup);
		}

		/**
		 * Update map content after a resize
		 */
		private function updateSize():void {
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0,0,this.size.w,this.size.h);
			this.graphics.endFill();
			this.scrollRect = new Rectangle(0,0,this.size.w,this.size.h);

			this.dispatchEvent(new MapEvent(MapEvent.RESIZE, this));

			for(var i:int=0; i < this.layers.length; i++) {
				if (this.layers[i].visible)	{
					this.layers[i].onMapResize();
				}
			}

			if (this.baseLayer != null) {
				this.setCenter(null,this.zoom,false,true,false,true);
			}
		}

		/**
		 * Allows user to pan by a value of screen pixels.
		 *
		 * @param dx horizontal pixel offset
		 * @param dy verticial pixel offset
		 * @param tween use tween effect
		 */
		public function pan(dx:int, dy:int, tween:Boolean=false):void {
			// Is there a real offset ?
			if ((dx==0) && (dy==0)) {
				return;
			}		
			if(this.center) {
				var newCenterPx:Pixel = this.getMapPxFromLonLat(this.center).add(dx, dy);
				var newCenterLonLat:LonLat = this.getLonLatFromMapPx(newCenterPx);
				this.setCenter(newCenterLonLat, NaN, false, false, tween);
			}
		}

		/**
		 * Set the map center (and optionally, the zoom level).
		 *
		 * This method shoud be refactored in order to make panning and zooming more independant.
		 *
		 * @param lonlat the new center location.
		 * @param zoom optional zoom level
		 * @param dragging Specifies whether or not to trigger movestart/end events
		 * @param forceZoomChange Specifies whether or not to trigger zoom change events (needed on baseLayer change)
		 * @param dragTween
		 *
		 */
		public function setCenter(lonlat:LonLat, zoom:Number = NaN, dragging:Boolean = false, forceZoomChange:Boolean = false, dragTween:Boolean = false, resizing:Boolean = false):void {
			var zoomChanged:Boolean = forceZoomChange || (this.isValidZoomLevel(zoom) && (zoom!=this._zoom));
						
			if (lonlat && !this.isValidLonLat(lonlat)) {
				Trace.log("Not a valid center, so do nothing");
				return;
			}
			
			// If the map is not initialized, the center of the extent is used
			// as the current center
			if (!this.center && !this.isValidLonLat(lonlat)) {
				lonlat = this.maxExtent.centerLonLat;
			}
			var validLonLat:Boolean = this.isValidLonLat(lonlat);
			var centerChanged:Boolean = validLonLat && (! lonlat.equals(this.center));
			
			if (zoomChanged || centerChanged || !dragging) {
				
				if (!dragging) {
					this.dispatchEvent(new MapEvent(MapEvent.MOVE_START, this));
				}
				
				if (centerChanged) {
					if ((!zoomChanged) && (this.center)) {
						this.centerLayerContainer(lonlat, dragTween);
					}
					this._center = lonlat.clone();
				}
				
				if ((zoomChanged) || (this._layerContainerOrigin == null)) {
					this._layerContainerOrigin = this.center.clone();
					this._layerContainer.x = 0;
					this._layerContainer.y = 0;
				}
				
				if (zoomChanged) {
					this._zoom = zoom;
				}
				
				if (zoomChanged) {
					this.dispatchEvent(new MapEvent(MapEvent.ZOOM_END, this));
				}
			}
			
			if (centerChanged && !dragging) {
				this.dispatchEvent(new MapEvent(MapEvent.MOVE_END, this));
			}
		}

		/**
		 * Reset the bitmap center depending on the current map center
		 * 
		 * @param tween use tween effect if set to true (default)
		 */
		public function resetCenterLayerContainer(tween:Boolean = true):void {
			this.centerLayerContainer(this.center, tween);
		}
		
		/**
		 * This function takes care to recenter the layerContainer and bitmapTransition.
		 *
		 * @param lonlat the new layer container center
		 * @param tween use tween effect if set to true
		 */
		private function centerLayerContainer(lonlat:LonLat, tween:Boolean = false):void {
			var originPx:Pixel = this.getMapPxFromLonLat(this._layerContainerOrigin);
			var newPx:Pixel = this.getMapPxFromLonLat(lonlat);

			if (originPx == null || newPx == null)
				return;

			// X and Y positions for the layer container and bitmap transition, respectively.
			var lx:Number = originPx.x - newPx.x;
			var ly:Number = originPx.y - newPx.y; 
			if (bitmapTransition != null) {
				var bx:Number = bitmapTransition.x + lx - _layerContainer.x;
				var by:Number = bitmapTransition.y + ly - _layerContainer.y;
			}

			if(tween) {
				new GTweeny(this._layerContainer, 0.5, {x: lx});
				new GTweeny(this._layerContainer, 0.5, {y: ly});    
				if(bitmapTransition != null) {
					new GTweeny(bitmapTransition, 0.5, {x: bx });
					new GTweeny(bitmapTransition, 0.5, {y: by });
				} 
			} else {
				this._layerContainer.x = lx;
				this._layerContainer.y = ly;    
				if(bitmapTransition != null) {
					bitmapTransition.x = bx;
					bitmapTransition.y = by;
				} 
			}
		}

		/**
		 * Check if a zoom level is valid on this map.
		 *
		 * @param zoomLevel the zoom level to test
		 * @return Whether or not the zoom level passed in is non-null and within the min/max
		 * range of zoom levels.
		 */
		private function isValidZoomLevel(zoomLevel:Number):Boolean {
			return (this.baseLayer && !isNaN(zoomLevel) && (zoomLevel >= this.baseLayer.minZoomLevel) && (zoomLevel <= this.baseLayer.maxZoomLevel));
		}

		/**
		 *  Check if a coordinate is valid on this map.
		 *
		 * @param lonlat the coordinate to test
		 * @return Whether or not the lonlat passed in is non-null and within the maxExtent bounds
		 */
		private function isValidLonLat(lonlat:LonLat):Boolean {
			return (lonlat!=null) && this.maxExtent.containsLonLat(lonlat);
		}

		/**
		 * Find the zoom level that most closely fits the specified bounds. Note that this may
		 * result in a zoom that does not exactly contain the entire extent.
		 *
		 * @param bounds the extent to use
		 * @return the matching zoom level
		 *
		 */
		private function getZoomForExtent(bounds:Bounds):Number {
			var zoom:int = -1;
			if (this.baseLayer != null) {
				zoom = this.baseLayer.getZoomForExtent(bounds);
			}
			return zoom;
		}

		/**
		 * A suitable zoom level for the specified bounds. If no baselayer is set, returns null.
		 *
		 * @param resolution the resolution to use
		 * @return the matching zoom level
		 *
		 */
		public function getZoomForResolution(resolution:Number):Number {
			var zoom:int = -1;
			if (this.baseLayer != null) {
				zoom = this.baseLayer.getZoomForResolution(resolution);
			}
			return zoom;
		}

		/**
		 * Zoom to the passed in bounds, recenter.
		 *
		 * @param bounds
		 */
		public function zoomToExtent(bounds:Bounds):void {
			this.setCenter(bounds.centerLonLat, this.getZoomForExtent(bounds));
		}

		/**
		 * Zoom to the full extent and recenter.
		 */
		public function zoomToMaxExtent():void {
			this.zoomToExtent(this.maxExtent);
		}


		/**
		 * Return a LonLat which is the passed-in view port Pixel, translated into lon/lat
		 *	by the current base layer
		 */
		public function getLonLatFromMapPx(px:Pixel):LonLat {
			var lonlat:LonLat = null;
			if (this.baseLayer != null) {
				lonlat = this.baseLayer.getLonLatFromMapPx(px);
			}
			return lonlat;
		}

		/**
		 * Return a Pixel which is the passed-in LonLat, translated into map
		 * pixels by the current base layer
		 */
		public function getMapPxFromLonLat(lonlat:LonLat):Pixel {
			var px:Pixel = null;
			if (this.baseLayer != null) {
				px = this.baseLayer.getMapPxFromLonLat(lonlat);
			}
			return px;
		}

		/**
		 * Return a map Pixel computed from a layer Pixel.
		 */
		public function getMapPxFromLayerPx(layerPx:Pixel):Pixel {
			var viewPortPx:Pixel = null;
			if (layerPx != null) {
				var dX:int = int(this._layerContainer.x);
				var dY:int = int(this._layerContainer.y);
				viewPortPx = layerPx.add(dX, dY);
			}
			return viewPortPx;
		}

		/**
		 * Return a layer Pixel computed from a map Pixel.
		 */
		public function getLayerPxFromMapPx(mapPx:Pixel):Pixel {
			var layerPx:Pixel = null;
			if (mapPx != null) {
				var dX:int = -int(this._layerContainer.x);
				var dY:int = -int(this._layerContainer.y);
				layerPx = mapPx.add(dX, dY);
			}
			return layerPx;
		}

		/**
		 * Return a LonLat computed from a layer Pixel.
		 */
		public function getLonLatFromLayerPx(px:Pixel):LonLat {
			px = this.getMapPxFromLayerPx(px);
			return this.getLonLatFromMapPx(px);
		}

		/**
		 * Return a layer Pixel computed from a LonLat.
		 */
		public function getLayerPxFromLonLat(lonlat:LonLat):Pixel {
			var px:Pixel = this.getMapPxFromLonLat(lonlat);
			return this.getLayerPxFromMapPx(px);
		}
		
		/**
		 * Remove a Security
		 * @param the security to remove
		 * @return  Boolean true or false depends on the success of removing
		 **/
		public function removeSecurity(security:ISecurity):Boolean {
			var securityLength:uint = this._securities.length;
			return (Util.removeItem(this._securities, security).length < securityLength);
		}
		/**
		 * find a security requester by its class name
		 * @return the security 
		 * */
		public function findSecurityByClass(securityClass:String):ISecurity{
			
			for(var i:int=0;i<this._securities.length;i++){
				if(securityClass==getQualifiedClassName(this._securities[i])){
					return this._securities[i] as ISecurity;
				}
			}
			return null;
		}
		
		
		/**
		 * To add a securities Array
		 * @param securities: The securities Array to add
		 * @return Boolean true or false depends on the adding or not
		 * */
		public function addSecurities(securities:Array):Boolean{
			
			if(securities==null) return false;
				for(var i:int=0;i<securities.length;i++){
					var security:ISecurity=securities[i] as ISecurity;
					//security is not null 
					if(security!=null)
					//The security 
					if(this.addSecurity(security)==false){
						return false;
						break;
					}
				}
			return true;
		}
		/**
		 * To add a security 
		 * @param security: The security to add
		 * @return Boolean true or false depends on the adding or not
		 * */
		public function addSecurity(security:ISecurity):Boolean{
			//if security is not null && there is not the same type of security 
			var addSecurity:Boolean=true;
			if(security==null) {addSecurity=false;return addSecurity}
			for(var i:int=0;i<this._securities.length;i++){
				if(getQualifiedClassName(security)==getQualifiedClassName(this._securities[i])){
					addSecurity=false;
					break;
				}
			}
			if(addSecurity) this._securities.push(security);
			return addSecurity;
		}
		// Getters & setters as3
		
		/**
		 * Map center coordinates.
		 */
		public function get center():LonLat
		{
			return _center;
		}
		public function set center(newCenter:LonLat):void
		{
			this.setCenter(newCenter);
		}

		/**
		 * Current map zoom level.
		 */
		public function get zoom():Number
		{
			return _zoom;
		}
		public function set zoom(newZoom:Number):void 
		{
			 if (this.isValidZoomLevel(newZoom)) {
			 	
			 	//Dispatch a MapEvent with the old and new zoom
				var mapEvent:MapEvent = new MapEvent(MapEvent.ZOOM_START,this);
				mapEvent.oldZoom = this.zoom;
				mapEvent.newZoom = newZoom;
				this.dispatchEvent(mapEvent);
			 	
				if (this.tweenZoomEnabled)
				{
					this.zoomTransition(newZoom);
				} else {
					setCenter(null, newZoom);
				}

			} 
		}

		/**
		 * Copy the layerContainer in a bitmap and display this (this function is use for zoom)
		 */
		private function zoomTransition(newZoom:Number = -1):void {
			if (!_zooming && newZoom >= 0) {
				
				// Disable more zooming until this zooming is complete 
				this._zooming = true;

				// We calculate de scale multiplicator according to the actual and new resolution
				var resMult:Number = this.resolution / this.baseLayer.resolutions[newZoom];
				// We intsanciate a bitmapdata with map's size
				var bitmapData:BitmapData = new BitmapData(this.width,this.height);
				// We draw the old transition before drawing the better-fitting tiles on top and removing the old transition. 
				if(this.bitmapTransition != null) {
					bitmapData.draw(this.bitmapTransition, bitmapTransition.transform.matrix);
					this.removeChild(this.bitmapTransition);
					var bmp:Bitmap = bitmapTransition.removeChildAt(0) as Bitmap;
					bmp.bitmapData.dispose();
					bmp.bitmapData = null;
					
				}

				// We draw the loaded tiles onto the background transition.
				try {
					// Can sometimes throw a security exception.
					bitmapData.draw(this.layerContainer, this.layerContainer.transform.matrix);
				} catch (e:Error) {
					Trace.error("Error zooming image: " + e);
				}

				// We create the background layer from the bitmap data
				this.bitmapTransition = new DraggableSprite();
				this.bitmapTransition.addChild(new Bitmap(bitmapData));		
				this.bitmapTransition.alpha=this._baseLayer.alpha;
				
				this.addChildAt(bitmapTransition, 0);				

				// We hide the layerContainer (to avoid zooming out issues)
				this.layerContainer.alpha = 0;

				//We calculate the bitmapTransition position
				var x:Number = this.bitmapTransition.x-((resMult-1)*this.bitmapTransition.width)/2;
				var y:Number = this.bitmapTransition.y-((resMult-1)*this.bitmapTransition.height)/2;

				//The tween effect to scale and re-position the bitmapTransition
				var tween:GTweeny = new GTweeny(this.bitmapTransition,0.3,
					{
						scaleX: resMult,
						scaleY: resMult,
						x: x,
						y: y
					});
				tween.addEventListener(Event.COMPLETE,clbZoomTween);
			}

			// The zoom tween callback method defined here to avoid a class attribute for newZoom
			function clbZoomTween(evt:Event):void {
				_zooming = false;
				setCenter(null, newZoom);
				layerContainer.alpha = 1;

			} 
		}

		/**	
		 * Event handler for LayerLoadComplete event. Check here if all layers have been loaded
		 * and if so, MapEvent.LOAD_COMPLETE can be dispatched
		 */
		private function layerLoadHandler(event:LayerEvent):void {
			switch(event.type) {
				case LayerEvent.LAYER_LOAD_START: {
					this.loading = true;
					break;
				}	
				case LayerEvent.LAYER_LOAD_END: {
					// check all layers 
					for (var i:Number = 0;i<this.layers.length;i++)	{
							var layer:Layer = this.layers[i];
							if (layer != null && !layer.loadComplete)
							  return;	
						}						
					// all layers are done loading.					
					this.loading = false;					
					break;
				}						
			}
		}
		
		/**
		 * Map size in pixels.
		 */
		public function get size():Size {
			return (_size) ? _size.clone() : null;
		}
		public function set size(value:Size):void {
			if (value) {
				_size = value;
				this.updateSize();
			} else {
				Trace.error("Map - size not changed since the value is not valid");
			}
		}

		/**
		 * Map width in pixels.
		 */
		override public function set width(value:Number):void {
			if (! isNaN(value)) {
				this._size.w = value;
				this.updateSize();
			} else {
				Trace.error("Map - width not changed since the value is not valid");
			}
		}

		/**
		 * Map height in pixels.
		 */
		override public function set height(value:Number):void {
			if (! isNaN(value)) {
				this._size.h = value;
				this.updateSize();
			} else {
				Trace.error("Map - height not changed since the value is not valid");
			}
		}

		/**
		 * Map controls
		 */
		public function get controls():Array {
			return this._controls;
		}

		/**
		 * Map handlers
		 */
		public function get handlers():Array {
			return this._handlers;
		}

		/**
		 * Map container where layers are added. It is used for panning and scaling layers.
		 */
		public function get layerContainer():DraggableSprite {
			return this._layerContainer;
		}

		public function get bitmapTransition():DraggableSprite {
			return this._bitmapTransition;
		}

		public function set bitmapTransition(value:DraggableSprite):void {
			this._bitmapTransition = value;
		}

		public function set maxExtent(value:Bounds):void {
			this._maxExtent = value;
		}

		/**
		 * The maximum extent for the map.
		 */
		public function get maxExtent():Bounds {
			// use map maxExtent
			var maxExtent:Bounds = this._maxExtent;
			
			// If baselayer is defined, override with baselayer maxExtent
			if (this.baseLayer) {
				maxExtent = this.baseLayer.maxExtent;
			}
			
			// If no maxExtent is defined, generate a worldwide maxExtent in the right projection
			if(maxExtent == null) {
				maxExtent = Layer.DEFAULT_MAXEXTENT;
				if (this.baseLayer && (this.baseLayer.projection.srsCode != Layer.DEFAULT_SRS_CODE)) {
					maxExtent.transform(Layer.DEFAULT_PROJECTION, this.baseLayer.projection)
				}
			}
			return maxExtent;
		}

		public function get extent():Bounds {
			var extent:Bounds = null;

			if ((this.center != null) && (this.resolution != -1)) {

				var w_deg:Number = this.size.w * this.resolution;
				var h_deg:Number = this.size.h * this.resolution;

				extent = new Bounds(this.center.lon - w_deg / 2,
					this.center.lat - h_deg / 2,
					this.center.lon + w_deg / 2,
					this.center.lat + h_deg / 2);
			} 

			return extent;
		}

		public function get resolution():Number {
			return (this.baseLayer) ? this.baseLayer.resolutions[this.zoom] : NaN;
		}

		public function get scale():Number {
			var scale:Number = NaN;
			if (this.baseLayer) {
				var units:String = this.baseLayer.projection.projParams.units;
				scale = Unit.getScaleFromResolution(this.resolution, units);
			}
			return scale;
		}
		
		public function get layers():Array {
			var layerArray:Array = new Array();
			if (this.layerContainer == null) {
				return layerArray;
			}
			for (var i:int=0; i<this.layerContainer.numChildren; i++) {
				if(this.layerContainer.getChildAt(i) is Layer) {
					layerArray.push(this.layerContainer.getChildAt(i));
				}
			}
			return layerArray;
		}
		
		public function get featureLayers():Array {
			var layerArray:Array = new Array();
			if (this.layerContainer == null) {
				return layerArray;
			}
			for (var i:int=0; i<this.layerContainer.numChildren; i++) {
				if (this.layerContainer.getChildAt(i) is FeatureLayer) {
					layerArray.push(this.layerContainer.getChildAt(i));
				}
			}
			return layerArray;
		}
	
		/**
		 * Proxy (usually a PHP, Python, or Java script) used to request remote servers like
		 * WFS servers in order to allow crossdomain requests. Remote servers can be used without
		 * proxy script by using crossdomain.xml file like http://openscales.org/crossdomain.xml
		 */
		public function get proxy():String {
			return this._proxy
		}

		public function set proxy(value:String):void {
			this._proxy = value;
		}

		public function set configuration(value:IConfiguration):void{
		 	_configuration = value;
		} 
		
		public function get configuration():IConfiguration{
		 	return _configuration;
		}
		
		public function set tweenZoomEnabled(value:Boolean):void{
		 	_tweenZoomEnabled = value;
		} 
		
		public function get tweenZoomEnabled():Boolean{
		 	return _tweenZoomEnabled;
		}
		
		/**
		 * Whether or not the map is loading data
		 */
		public function get loadComplete():Boolean {
			return !this._loading;
		}
		
		/**
		 * Used to set loading status of map
		 */
		protected function set loading(value:Boolean):void {
			if (value == true && this._loading == false) {
			this._loading = value;
			  dispatchEvent(new MapEvent(MapEvent.LOAD_START,this));
			}
						 
			if (value == false && this._loading == true) {
			  this._loading = value;
			  dispatchEvent(new MapEvent(MapEvent.LOAD_END,this));
			} 
		}
	}
}

