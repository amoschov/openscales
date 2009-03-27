package org.openscales.core
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.Control;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.popup.Popup;
	
	/**
	 * Class: OpenLayers.Map
	 * Instances of OpenLayers.Map are interactive maps embedded in a web page.
	 * Create a new map with the Map constructor.
	 * 
	 * On their own maps do not provide much functionality.  To extend a map
	 * it's necessary to add controls (Control) and 
	 * layers (Layer) to the map. 
	 */
	public class Map extends Sprite
	{
		
		public var DEFAULT_TILE_WIDTH:Number = 256;
		public var DEFAULT_TILE_HEIGHT:Number = 256;
		public var DEFAULT_NUM_ZOOM_LEVELS:Number = 16;
		public var DEFAULT_MAX_RESOLUTION:Number = 1.40625;
		public var DEFAULT_PROJECTION:String = "EPSG:4326";
		public var DEFAULT_UNITS:String = "degrees";
			
		
		public var Z_INDEX_BASE:Object = {BaseLayer: 100, Overlay:325, Popup:750, Control: 1000};
						
		private var _featureSelection:Array = null;
		private var _layerContainerOrigin:LonLat = null;
		private var _vectorLayer:Layer = null;
		private var _popupContainer:Sprite = null;
		private var _layerContainer:Sprite = null;
		private var _layers:Array = null;
		private var _baseLayer:Layer = null;
		private var _controls:Array = null;
		private var _popups:Array = null;
		private var _size:Size = null;
		private var _tileSize:Size = null;
		private var _center:LonLat = null;
		private var _zoom:Number = 0;
		private var _maxExtent:Bounds = null;
		private var _maxResolution:Number;
		private var _minResolution:Number;
		private var _numZoomLevels:int;
		private var _scales:Array;
		private var _resolutions:Array;
		private var _projection:String;
		private var _units:String;
		private var _maxScale:Number;
		private var _minScale:Number;
		
		public function Map(width:Number=600, height:Number=400, options:Object = null):void {
			
			super();
			
			Util.extend(this, options);	
			
			this._layers = new Array();
			this._controls = new Array();
			this._popups = new Array();
									
			this.size = new Size(width, height);
			this.tileSize = new Size(this.DEFAULT_TILE_WIDTH, this.DEFAULT_TILE_HEIGHT);
			this.maxExtent = new Bounds(-180,-90,180,90);
			this.maxResolution =  this.DEFAULT_MAX_RESOLUTION;
			this.projection = this.DEFAULT_PROJECTION;
			this.numZoomLevels = this.DEFAULT_NUM_ZOOM_LEVELS;
			this.units = this.DEFAULT_UNITS;
			
			this._layerContainer = new Sprite();
			
			this._layerContainer.graphics.beginFill(0xFFFFFF,0);
			this._layerContainer.graphics.drawRect(0,0,this.size.w,this.size.h);
			this._layerContainer.graphics.endFill();
			
			this._layerContainer.width = this.size.w;
			this._layerContainer.height = this.size.h;
			this.addChild(this._layerContainer);
			
			this._popupContainer = new Sprite();
			
			this._popupContainer.graphics.beginFill(0xFFFFFF,0);
			this._popupContainer.graphics.drawRect(0,0,this.size.w,this.size.h);
			this._popupContainer.graphics.endFill();
			
			this._popupContainer.visible = false;
			this.addChild(this._popupContainer);
			
		}
		
		private function destroy():Boolean {	
	        if (this._layers != null) {
	            for (var i:int = this._layers.length - 1; i>=0; i--) {
	                //pass 'false' to destroy so that map wont try to set a new 
	                // baselayer after each baselayer is removed
	                this._layers[i].destroy(false);
	            } 
	            this._layers = null;
	        }
	        if (this._controls != null) {
	            for (var j:int = this._controls.length - 1; j>=0; j--) {
	                this._controls[j].destroy();
	            } 
	            this._controls = null;
	        }
	
	        return true;
		}
		
		public function getLayerByName(name:String):Layer {
			var foundLayer:Layer = null;
			for (var i:int = 0; i < this._layers.length; i++) {
				var layer:Layer = this._layers[i];
				if (layer.name == name) {
					foundLayer = layer;
				}
			}
			return foundLayer;
		}
		
		public function setLayerZindex(layer:Layer, zIdx:int):void {
			layer.zindex = this.Z_INDEX_BASE[layer.isBaseLayer ? 'BaseLayer' : 'Overlay'] + zIdx * 5;
		}
		
		public function addLayer(layer:Layer):Boolean {
			for(var i:int=0; i < this._layers.length; i++) {
	            if (this._layers[i] == layer) {
	                return false;
	            }
	        }

	        if (layer.zindex < 0) {
	        	this.setLayerZindex(layer, this._layers.length);
	        }
	        
	        if (layer.isFixed) {
	            this.addChild(layer);
	        } else {
	         	this._layerContainer.addChild(layer);
	        }
	        
	        this._layers.push(layer);
	        layer.map = this;
	        
	        if (layer.isBaseLayer) {
				if (this.baseLayer == null) {
					this.setBaseLayer(layer);
				} else {
					layer.visible = false;
				}
	        } else {
	        	layer.redraw();
	        }
	        
	        //this.events.triggerEvent("addlayer");
	        this.dispatchEvent(new MapEvent(MapEvent.LAYER_ADDED));
	        
	        return true;        
		}
		
		public function addLayers(layers:Array):void {
	        for (var i:int = 0; i <  layers.length; i++) {
	            this.addLayer(layers[i]);
	        }
		}
		
		public function removeLayer(layer:Layer, setNewBaseLayer:Boolean = true):void {
			if (layer.isFixed) {
				this.removeChild(layer);
			} else {
				this._layerContainer.removeChild(layer);
			}
			layer.map = null;
			Util.removeItem(this._layers, layer);
			
	        if (setNewBaseLayer && (this.baseLayer == layer)) {
            	this._baseLayer = null;
	            for(var i:int=0; i < this._layers.length; i++) {
	                var iLayer:Layer = this._layers[i];
	                if (iLayer.isBaseLayer) {
	                    this.setBaseLayer(iLayer);
	                    break;
	                }
	            }
	        }
	        
	        //this.events.triggerEvent("removelayer");
	        this.dispatchEvent(new MapEvent(MapEvent.LAYER_REMOVED));	
		}
		
		public function get numLayers():Number {
			return this._layers.length;
		}
		
		public function getLayerIndex(layer:Layer):int {
			return Util.indexOf(this._layers, layer);
		}
		
		public function setLayerIndex(layer:Layer, idx:int):void {
	        var base:int = this.getLayerIndex(layer);
	        if (idx < 0) 
	            idx = 0;
	        else if (idx > this._layers.length)
	            idx = this._layers.length;
	        if (base != idx) {
	            this._layers.splice(base, 1);
	            this._layers.splice(idx, 0, layer);
	            for (var i:int = 0; i < this._layers.length; i++)
	                this.setLayerZIndex(this._layers[i], i);
	            //this.events.triggerEvent("changelayer");
	            this.dispatchEvent(new MapEvent(MapEvent.LAYER_CHANGED));
	        }
		}
		
		public function addControl(control:Control):void {
			this._controls.push(control);
        	control.setMap(this);
        	control.draw();
        	this.addChild( control );
		}
		
		public function setLayerZIndex(layer:Layer, zIdx:int):void {
	        layer.zindex = this.Z_INDEX_BASE[layer.isBaseLayer ? 'BaseLayer' : 'Overlay'] + zIdx * 5;
  		}
  		
		public function raiseLayer(layer:Layer, delta:int):void {
			var idx:int = this.getLayerIndex(layer) + delta;
			this.setLayerIndex(layer, idx);
		}
		
		public function setBaseLayer(newBaseLayer:Layer, noEvent:Boolean = false):void {
			var oldExtent:Bounds = null;
			if (this.baseLayer != null) {
				oldExtent = this.baseLayer.extent;
			}
			
			if (newBaseLayer != this.baseLayer) {
				
				if (Util.indexOf(this._layers, newBaseLayer) != -1) {
										
					this._baseLayer = newBaseLayer;
					this.baseLayer.visible = true;
					
					var center:LonLat = this.center;
					if (center != null) {
						if (oldExtent == null) {
							this.setCenter(center, this.zoom, false, true);
						} else {
							this.setCenter(oldExtent.getCenterLonLat(), 
                                       this.getZoomForExtent(oldExtent),
                                       false, true);
						}
					}
					
					if (!noEvent) {
						
						//this.events.triggerEvent("changebaselayer");
						this.dispatchEvent(new MapEvent(MapEvent.BASE_LAYER_CHANGED));
					}
					
				}
			}
		}
		
		/** 
	    * @param {OpenLayers.Popup} popup
	    * @param {Boolean} exclusive If true, closes all other popups first
	    **/
	    public function addPopup(popup:Popup, exclusive:Boolean = true):void {
	
	        if (exclusive) {
	            //remove all other popups from screen
	            for(var i:int=0; i < this._popups.length; i++) {
	                this.removePopup(this._popups[i]);
	            }
	        }
	
	        popup.map = this;
	        this._popups.push(popup);
	        popup.draw();
	        if (popup) {
	            this._popupContainer.addChildAt(popup, this._popups.length);
	        }
	    }

	    public function removePopup(popup:Popup):void {
	        Util.removeItem(this._popups, popup);
	        if (popup) {
	            try { this._popupContainer.removeChild(popup); }
	            catch (e:Error) { } 
	        }
	        popup.map = null;
	    }
		
		public function updateSize():void { 

				this.scrollRect = new Rectangle(0,0,this.size.w,this.size.h);
				
				this.graphics.clear();
				this.graphics.beginFill(0xFFFFFF);
				this.graphics.drawRect(0,0,this.size.w,this.size.h);
				this.graphics.endFill();
					            	
	            for(var i:int=0; i < this._layers.length; i++) {
	                this._layers[i].onMapResize();                
	            }
	
	            if (this.baseLayer != null) {
	                var center:Pixel = new Pixel(this.size.w /2, this.size.h / 2);
	                var centerLL:LonLat = this.getLonLatFromViewPortPx(center);
	                var zoom:int = this.zoom;
	                this.zoom = undefined;
	                this.setCenter(this.center, zoom);
	            }
		}
		
		public function calculateBounds(center:LonLat = null, resolution:Number = -1):Bounds {
			var extent:Bounds = null;
        
	        if (center == null) {
	            center = this.center;
	        }                
	        if (resolution == -1) {
	            resolution = this.resolution;
	        }
	    
	        if ((center != null) && (resolution != -1)) {
	
	            var w_deg:Number = this.size.w * resolution;
	            var h_deg:Number = this.size.h * resolution;
	        
	            extent = new Bounds(center.lon - w_deg / 2,
	                                           center.lat - h_deg / 2,
	                                           center.lon + w_deg / 2,
	                                           center.lat + h_deg / 2);  
	        }
	
	        return extent;
		}
		
		public function pan(dx:int, dy:int):void {
			var centerPx:Pixel = this.getViewPortPxFromLonLat(this.center);
	
	        // adjust
	        var newCenterPx:Pixel = centerPx.add(dx, dy);
	        
	        // only call setCenter if there has been a change
	        if (!newCenterPx.equals(centerPx)) {
	            var newCenterLonLat:LonLat = this.getLonLatFromViewPortPx(newCenterPx);
	            this.setCenter(newCenterLonLat);
	        }
		}
		
		public function setCenter(lonlat:LonLat, zoom:Number = NaN, dragging:Boolean = false, forceZoomChange:Boolean = false):void {
			if (!this.center && !this.isValidLonLat(lonlat)) {
	            lonlat = this.maxExtent.getCenterLonLat();
	        }
	        
	        var zoomChanged:Boolean = forceZoomChange || (
	                            (this.isValidZoomLevel(zoom)) && 
	                            (zoom != this.zoom) );
	
	        var centerChanged:Boolean = (this.isValidLonLat(lonlat)) && 
	                            (!lonlat.equals(this.center));
	

	        if (zoomChanged || centerChanged || !dragging) {
	
	            if (!dragging) { 
	            	//this.events.triggerEvent("movestart");
	            	this.dispatchEvent(new MapEvent(MapEvent.MOVE_START)); 
	            }
	
	            if (centerChanged) {
	                if ((!zoomChanged) && (this.center)) { 
	                    this.center_layerContainer(lonlat);
	                }
	                this.center = lonlat.clone();
	            }

	            if ((zoomChanged) || (this._layerContainerOrigin == null)) {
	                this._layerContainerOrigin = this.center.clone();
	                this._layerContainer.x = 0;
	                this._layerContainer.y = 0;
	            }
	
	            if (zoomChanged) {
	                this.zoom = zoom;
	            } 
	            
	            var bounds:Bounds = this.extent;
  	
	            this.baseLayer.moveTo(bounds, zoomChanged, dragging);
	            for (var i:int = 0; i < this._layers.length; i++) {
	                var layer:Layer = this._layers[i];
	                if (!layer.isBaseLayer) {
	                    
	                    var moveLayer:Boolean;
	                    var inRange:Boolean = layer.calculateInRange();
	                    if (layer.inRange != inRange) {
	                        layer.inRange = inRange;
	                        moveLayer = true;
	                        //this.events.triggerEvent("changelayer");
	                        this.dispatchEvent(new MapEvent(MapEvent.LAYER_CHANGED));
	                    } else {
	                        moveLayer = (layer.visible && layer.inRange);
	                    }
	
	                    if (moveLayer) {
	                        layer.moveTo(bounds, zoomChanged, dragging);
	                    }
	                }                
	            }
	            
	            if (zoomChanged) {
	                for (var j:int = 0; j < this._popups.length; j++) {
	                    this._popups[i].updatePosition();
	                }
	            }
	            
	            //this.events.triggerEvent("move");
	            this.dispatchEvent(new MapEvent(MapEvent.MOVE));
	    
	            if (zoomChanged) { 
	            	//this.events.triggerEvent("zoomend");
	            	this.dispatchEvent(new MapEvent(MapEvent.ZOOM_END)); 
	            }
	        }

	        if (!dragging) { 
	        	
	        	//this.events.triggerEvent("moveend");
	        	this.dispatchEvent(new MapEvent(MapEvent.MOVE_END)); 
	        }
		}
		
		public function center_layerContainer(lonlat:LonLat):void {
			var originPx:Pixel = this.getViewPortPxFromLonLat(this._layerContainerOrigin);
	        var newPx:Pixel = this.getViewPortPxFromLonLat(lonlat);
	
	        if ((originPx != null) && (newPx != null)) {
	            this._layerContainer.x = (originPx.x - newPx.x);
	            this._layerContainer.y  = (originPx.y - newPx.y);
	        }
		}
		
		public function isValidZoomLevel(zoomLevel:Number):Boolean {
			var isValid:Boolean = ( (!isNaN(zoomLevel)) &&
	            (zoomLevel >= 0) && 
	            (zoomLevel < this.numZoomLevels) );
		    return isValid;
		}
		
		public function isValidLonLat(lonlat:LonLat):Boolean {
	        var valid:Boolean = false;
	        if (lonlat != null) {
	            var maxExtent:Bounds = this.maxExtent;
	            valid = maxExtent.containsLonLat(lonlat);        
	        }
	        return valid;
		}
		
		public function getZoomForExtent(bounds:Bounds):Number {
			var zoom:int = -1;
	        if (this.baseLayer != null) {
	            zoom = this.baseLayer.getZoomForExtent(bounds);
	        }
	        return zoom;
		}
		
		public function getZoomForResolution(resolution:Number):Number {
			var zoom:int = -1;
	        if (this.baseLayer != null) {
	            zoom = this.baseLayer.getZoomForResolution(resolution);
	        }
	        return zoom;
		}
		
		public function zoomTo(zoom:int):void {
	        if (this.isValidZoomLevel(zoom)) {
	            this.setCenter(null, zoom);
	        }
		}
		
		public function zoomIn():void{
			this.zoomTo(this.zoom + 1);
		}
		
		public function zoomOut():void {
			this.zoomTo(this.zoom - 1);
		}
		
		public function zoomToExtent(bounds:Bounds):void {
	        this.setCenter(bounds.getCenterLonLat(), this.getZoomForExtent(bounds));
		}
		
		public function zoomToMaxExtent():void {
			this.zoomToExtent(this.maxExtent);
		}
		
		public function zoomToScale(scale:Number):void {
			var res:Number = new Util().getResolutionFromScale(scale, this.baseLayer.units);
	        var w_deg:Number = this.size.w * res;
	        var h_deg:Number = this.size.h * res;
	        var center:LonLat = this.center;
	
	        var extent:Bounds = new Bounds(center.lon - w_deg / 2,
	                                           center.lat - h_deg / 2,
	                                           center.lon + w_deg / 2,
	                                           center.lat + h_deg / 2);
	        this.zoomToExtent(extent);
		}
		
		public function getLonLatFromViewPortPx(viewPortPx:Pixel):LonLat {
	        var lonlat:LonLat = null; 
	        if (this.baseLayer != null) {
	            lonlat = this.baseLayer.getLonLatFromViewPortPx(viewPortPx);
	        }
	        return lonlat;
		}
		
		public function getViewPortPxFromLonLat(lonlat:LonLat):Pixel {
			var px:Pixel = null; 
	        if (this.baseLayer != null) {
	            px = this.baseLayer.getViewPortPxFromLonLat(lonlat);
	        }
	        return px;
		}
		
		public function getLonLatFromPixel(px:Pixel):LonLat {
			return this.getLonLatFromViewPortPx(px);
		}
		
		public function getPixelFromLonLat(lonlat:LonLat):Pixel {
			return this.getViewPortPxFromLonLat(lonlat);
		}
		
		public function getViewPortPxFromLayerPx(layerPx:Pixel):Pixel {
			var viewPortPx:Pixel = null;
	        if (layerPx != null) {
	            var dX:int = int(this._layerContainer.x);
	            var dY:int = int(this._layerContainer.y);
	            viewPortPx = layerPx.add(dX, dY);            
	        }
	        return viewPortPx;
		}

		public function getLayerPxFromViewPortPx(viewPortPx:Pixel):Pixel {
			var layerPx:Pixel = null;
	        if (viewPortPx != null) {
	            var dX:int = -int(this._layerContainer.x);
	            var dY:int = -int(this._layerContainer.y);
	            layerPx = viewPortPx.add(dX, dY);
	        }
	        return layerPx;
		}

		public function getLonLatFromLayerPx(px:Pixel):LonLat {
			px = this.getViewPortPxFromLayerPx(px);
	    	return this.getLonLatFromViewPortPx(px); 
		}
		
		public function getLayerPxFromLonLat(lonlat:LonLat):Pixel {
	    	var px:Pixel = this.getViewPortPxFromLonLat(lonlat);
	    	return this.getLayerPxFromViewPortPx(px);
		}

		// Getters & setters as3
		
		public function get center():LonLat
		{
			return _center;
		}
		public function set center(newCenter:LonLat):void
		{
			_center = newCenter;
		}
		
		public function get tileSize():Size
		{
			return _tileSize;
		}
		public function set tileSize(newTileSize:Size):void
		{
			_tileSize = newTileSize;
		}
		
		public function get zoom():Number
		{
			return _zoom;
		}
		public function set zoom(newZoom:Number):void
		{
			_zoom = newZoom;
		}
		
		public function get size():Size
		{
			var size:Size = null;
	        if (_size != null) {
	            size = _size.clone();
	        }
	        return size;
		}
		
		public function set size(newSize:Size):void
		{
			_size= newSize;
			
			this.updateSize();
		}
		
		public function get layers():Array {
	        return this._layers;
		}
		
		public function get controls():Array {
	        return this._controls;
		}
		
		public function get baseLayer():Layer {
	        return this._baseLayer;
		}
		
		public function get layerContainer():Sprite {
	        return this._layerContainer;
		}
		
		public function get vectorLayer():Layer {
	        return this._vectorLayer;
		}
		
		public function set featureSelection(value:Array):void
		{
			this._featureSelection= value;
		}
		
		public function get featureSelection():Array {
	        return this._featureSelection;
		}
						
		public function set units(value:String):void {
			this._units = value;
		}
		
		public function get units():String {
	        var units:String = _units;
	        if (this.baseLayer != null) {
	            units = this.baseLayer.units;
	        }
	        return units;
		}
		
		public function set projection(value:String):void {
			this._projection = value;
		}
		
		public function get projection():String {
	        var projection:String = _projection;
	        if (this.baseLayer != null) {
	            projection = this.baseLayer.projection;
	        }
	        return projection;
		}
		
		public function set minResolution(value:Number):void {
			this._minResolution = value;
		}
		
		public function get minResolution():Number {
	        var minResolution:Number = _minResolution;
	        if (this.baseLayer != null) {
	            minResolution = this.baseLayer.minResolution;
	        }
	        return minResolution;
		}
		
		public function set maxScale(value:Number):void {
			this._maxScale = value;
		}
		
		public function get maxScale():Number {
	        var maxScale:Number = _maxScale;
	        if (this.baseLayer != null) {
	            maxScale = this.baseLayer.maxScale;
	        }
	        return maxScale;
		}
		
		public function set minScale(value:Number):void {
			this._minScale = value;
		}
		
		public function get minScale():Number {
	        var minScale:Number = _minScale;
	        if (this.baseLayer != null) {
	            minScale = this.baseLayer.minScale;
	        }
	        return minScale;
		}
		
		
		public function set maxResolution(value:Number):void {
			this._maxResolution = value;
		}
		
		public function get maxResolution():Number {
	        var maxResolution:Number = _maxResolution;
	        if (this.baseLayer != null) {
	            maxResolution = this.baseLayer.maxResolution;
	        }
	        return maxResolution;
		}
		
		public function set resolutions(value:Array):void {
			this._resolutions = value;
		}
		
		public function get resolutions():Array {
	        var resolutions:Array = _resolutions;
	        if (this.baseLayer != null) {
	            resolutions = this.baseLayer.resolutions;
	        }
	        return resolutions;
		}		
		
		public function set scales(value:Array):void {
			this._scales = value;
		}
		
		public function get scales():Array {
	        var scales:Array = _scales;
	        if (this.baseLayer != null) {
	            scales = this.baseLayer.scales;
	        }
	        return scales;
		}		
		
		public function set maxExtent(value:Bounds):void {
			this._maxExtent = value;
		}
		
		public function get maxExtent():Bounds {
	        var maxExtent:Bounds = _maxExtent;
	        if (this.baseLayer != null) {
	            maxExtent = this.baseLayer.maxExtent;
	        }        
	        return maxExtent;	
		}
				
		public function set numZoomLevels(value:int):void {
			this._numZoomLevels = value;
		}
		
		public function get numZoomLevels():int {	
	        var numZoomLevels:int = _numZoomLevels;
	        if (this.baseLayer != null) {
	            numZoomLevels = this.baseLayer.numZoomLevels;
	        }
	        return numZoomLevels;
		}
		
		public function get extent():Bounds {
	        var extent:Bounds = null;
	        if (this.baseLayer != null) {
	            extent = this.baseLayer.extent;
	        }
	        return extent;
		}
		
		public function get resolution():Number {
	        var resolution:Number = undefined;
	        if (this.baseLayer != null) {
	            resolution = this.baseLayer.resolution;
	        }
	        return resolution;
		}
		
		public function get scale():Number {
			var scale:Number = undefined;
	        if (this.baseLayer != null) {
	            var res:Number = this.resolution;
	            var units:String = this.baseLayer.units;
	            scale = Util.getScaleFromResolution(res, units);
	        }
	        return scale;
		}
		
	}
}