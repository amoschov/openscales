package org.openscales.core
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.event.Events;
	
	public class Map extends Sprite
	{
		
		public var TILE_WIDTH:Number = 256;
		public var TILE_HEIGHT:Number = 256;
		
		public var Z_INDEX_BASE:Object = {BaseLayer: 100, Overlay:325, Popup:750, Control: 1000};
		
		public var EVENT_TYPES:Array = [
        "addlayer", "removelayer", "changelayer", "movestart", "move", 
        "moveend", "zoomend", "popupopen", "popupclose",
        "addmarker", "removemarker", "clearmarkers", "mouseOver",
        "mouseOut", "mouseMove", "dragstart", "drag", "dragend",
        "changebaselayer", "changeannolayer"];
		
		public var id:String = null;
		
		public var events:Events = null;
		
		private var unloadDestroy:Function = null;
		
		//public var viewPort:Sprite = null;
		
		public var layerContainerOrigin:LonLat = null;
		
		public var popupContainer:Sprite = null;
		
		public var layerContainer:Sprite = null;
		
		/**
		 * Array of Layer classes
		 */
		public var layers:Array = null;
		
		public var controls:Array = null;
		
		public var popups:Array = null;
		
		public var baseLayer:Layer = null;
		
		private var _center:LonLat = null;
		
		private var _zoom:Number = 0;
		
		public var viewRequestID:int = 0;
		
		private var _tileSize:Size = null;
		
		public var projection:String = "EPSG:4326";
		
		public var units:String = "degrees";
		
		public var maxResolution:Object = 1.40625;
		
		public var minResolution:Object;
		
		public var maxScale:Number;
		
		public var minScale:Number;
		
		public var maxExtent:Bounds = null;
		
		public var minExtent:Bounds = null;
		
		public var numZoomLevels:Number = 16;
		
		public var fallThrough:Boolean = false;
		
		public var scales:Object = null;
		
		public var resolutions:Object = null;
		
		public var maxZoomLevel:Object = null;
		
		public var vectorLayer:Layer = null;
		
		public var featureSelection:Array = null;
		
		public var canPos:Pixel = null;
		
		private var _size:Size = null;
		
		public function Map(width:Number=600, height:Number=400, options:Object = null):void {
			
			super();
			
			this.setOptions(options);
			
			this.id = Util.createUniqueID("Map_");
						
			var topleft:Point = this.localToGlobal(new Point(0, 0));
			this.canPos = new Pixel(topleft.x, topleft.y);
			
			this.layers = new Array();
			this.size = new Size(width, height);
			
			this.layerContainer = new Sprite();
			
			this.layerContainer.graphics.beginFill(0xFFFFFF);
			this.layerContainer.graphics.drawRect(0,0,this.size.w,this.size.h);
			this.layerContainer.graphics.endFill();
			
			this.layerContainer.width = this.size.w;
			this.layerContainer.height = this.size.h;
			this.addChild(this.layerContainer);
			
	
			
			this.popupContainer = new Sprite();
			this.popupContainer.width = this.size.w;
			this.popupContainer.height = this.size.h;
			
			this.popupContainer.graphics.beginFill(0xFFFFFF);
			this.popupContainer.graphics.drawRect(0,0,this.size.w,this.size.h);
			this.popupContainer.graphics.endFill();
			
			this.popupContainer.visible = false;
			this.addChild(this.popupContainer);
			
			this.events = new Events(this, this, this.EVENT_TYPES, this.fallThrough);
	        
	 
	        // update the map size and location before the map moves
	        //this.events.register("movestart", this, this.updateSize);
	        //this.canvas.addEventListener("resize", this.updateSize);

			this.layers = new Array();
			this.controls = new Array();
			this.popups = new Array();
			
		}
		
		private function destroy():Boolean {
	        if (this.unloadDestroy == null) {
	            return false;
	        }
	        
	       // new OpenScalesEvent().stopObserving(this.can.parentApplication, 'unload', this.unloadDestroy);
	        this.unloadDestroy = null;
	
	        if (this.layers != null) {
	            for (var i:int = this.layers.length - 1; i>=0; i--) {
	                //pass 'false' to destroy so that map wont try to set a new 
	                // baselayer after each baselayer is removed
	                this.layers[i].destroy(false);
	            } 
	            this.layers = null;
	        }
	        if (this.controls != null) {
	            for (var j:int = this.controls.length - 1; j>=0; j--) {
	                this.controls[j].destroy();
	            } 
	            this.controls = null;
	        }
	        /* if (this.viewPort) {
	            this.removeChild(this.viewPort);
	        }
	        this.viewPort = null; */
	
	        this.events.destroy();
	        this.events = null;
	        return true;
		}
		
		public function setOptions(options:Object):void {
			this.tileSize = new Size(this.TILE_WIDTH, this.TILE_HEIGHT);
			
			//this.maxExtent = new Bounds(-77.90,40.77,-77.81,40.83);
			this.maxExtent = new Bounds(-180,-90,180,90);
			
			Util.extend(this, options);		
		}
		
		public function getLayer(id:String):Layer {
			var foundLayer:Layer = null;
			for (var i:int = 0; i < this.layers.length; i++) {
				var layer:Layer = this.layers[i];
				if (layer.id == id) {
					foundLayer = layer;
				}
			}
			return foundLayer;
		}
		
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
		
		public function setLayerZindex(layer:Layer, zIdx:int):void {
			layer.zindex = this.Z_INDEX_BASE[layer.isBaseLayer ? 'BaseLayer' : 'Overlay'] + zIdx * 5;
		}
		
		public function addLayer(layer:Layer):Boolean {
			for(var i:int=0; i < this.layers.length; i++) {
	            if (this.layers[i] == layer) {
	                return false;
	            }
	        }

	        if (layer.zindex < 0) {
	        	this.setLayerZindex(layer, this.layers.length);
	        }
	        
	        if (layer.isFixed) {
	            this.addChild(layer);
	        } else {
	         	this.layerContainer.addChild(layer);
	        }
	        
	        this.layers.push(layer);
	        layer.setMap(this);
	        
	        if (layer.isBaseLayer) {
				if (this.baseLayer == null) {
					this.setBaseLayer(layer);
				} else {
					layer.setVisibility(false);
				}
	        } else {
	        	layer.redraw();
	        }
	        
	        this.events.triggerEvent("addlayer");
	        
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
				this.layerContainer.removeChild(layer);
			}
			layer.map = null;
			Util.removeItem(this.layers, layer);
			
	        if (setNewBaseLayer && (this.baseLayer == layer)) {
            	this.baseLayer = null;
	            for(var i:int=0; i < this.layers.length; i++) {
	                var iLayer:Layer = this.layers[i];
	                if (iLayer.isBaseLayer) {
	                    this.setBaseLayer(iLayer);
	                    break;
	                }
	            }
	        }
	        this.events.triggerEvent("removelayer");	
		}
		
		public function getNumLayers():Number {
			return this.layers.length;
		}
		
		public function getLayerIndex(layer:Layer):int {
			return Util.indexOf(this.layers, layer);
		}
		
		public function setLayerIndex(layer:Layer, idx:int):void {
	        var base:int = this.getLayerIndex(layer);
	        if (idx < 0) 
	            idx = 0;
	        else if (idx > this.layers.length)
	            idx = this.layers.length;
	        if (base != idx) {
	            this.layers.splice(base, 1);
	            this.layers.splice(idx, 0, layer);
	            for (var i:int = 0; i < this.layers.length; i++)
	                this.setLayerZIndex(this.layers[i], i);
	            this.events.triggerEvent("changelayer");
	        }
		}
		
		public function addControl(control:Control):void {
			this.controls.push(control);
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
				oldExtent = this.baseLayer.getExtent();
			}
			
			if (newBaseLayer != this.baseLayer) {
				
				if (Util.indexOf(this.layers, newBaseLayer) != -1) {
					
					if (this.baseLayer != null) {
						this.baseLayer.setVisibility(false, noEvent);
					}
					
					this.baseLayer = newBaseLayer;
					
					this.viewRequestID++;
					this.baseLayer.visibility = true;
					
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
						this.events.triggerEvent("changebaselayer");
					}
					
				}
			}
		}
		
		/** 
	    * @param {OpenLayers.Popup} popup
	    * @param {Boolean} exclusive If true, closes all other popups first
	    **/
	    public function addPopup(popup:PopupOL, exclusive:Boolean = true):void {
	
	        if (exclusive) {
	            //remove all other popups from screen
	            for(var i:int=0; i < this.popups.length; i++) {
	                this.removePopup(this.popups[i]);
	            }
	        }
	
	        popup.map = this;
	        this.popups.push(popup);
	        popup.draw();
	        if (popup) {
	            this.popupContainer.addChildAt(popup, this.popups.length);
	        }
	    }

	    public function removePopup(popup:PopupOL):void {
	        Util.removeItem(this.popups, popup);
	        if (popup) {
	            try { this.popupContainer.removeChild(popup); }
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
					            	
	            for(var i:int=0; i < this.layers.length; i++) {
	                this.layers[i].onMapResize();                
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
	            resolution = this.getResolution();
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
	
	            if (!dragging) { this.events.triggerEvent("movestart"); }
	
	            if (centerChanged) {
	                if ((!zoomChanged) && (this.center)) { 
	                    this.centerLayerContainer(lonlat);
	                }
	                this.center = lonlat.clone();
	            }

	            if ((zoomChanged) || (this.layerContainerOrigin == null)) {
	                this.layerContainerOrigin = this.center.clone();
	                this.layerContainer.x = 0;
	                this.layerContainer.y = 0;
	            }
	
	            if (zoomChanged) {
	                this.zoom = zoom;

	                this.viewRequestID++;
	            } 
	            
	            var bounds:Bounds = this.getExtent();
  	
	            this.baseLayer.moveTo(bounds, zoomChanged, dragging);
	            for (var i:int = 0; i < this.layers.length; i++) {
	                var layer:Layer = this.layers[i];
	                if (!layer.isBaseLayer) {
	                    
	                    var moveLayer:Boolean;
	                    var inRange:Boolean = layer.calculateInRange();
	                    if (layer.inRange != inRange) {
	                        layer.inRange = inRange;
	                        moveLayer = true;
	                        this.events.triggerEvent("changelayer");
	                    } else {
	                        moveLayer = (layer.visibility && layer.inRange);
	                    }
	
	                    if (moveLayer) {
	                        layer.moveTo(bounds, zoomChanged, dragging);
	                    }
	                }                
	            }
	            
	            if (zoomChanged) {
	                for (var j:int = 0; j < this.popups.length; j++) {
	                    this.popups[i].updatePosition();
	                }
	            }
	            
	            this.events.triggerEvent("move");
	    
	            if (zoomChanged) { this.events.triggerEvent("zoomend"); }
	        }

	        if (!dragging) { this.events.triggerEvent("moveend"); }
		}
		
		public function centerLayerContainer(lonlat:LonLat):void {
			var originPx:Pixel = this.getViewPortPxFromLonLat(this.layerContainerOrigin);
	        var newPx:Pixel = this.getViewPortPxFromLonLat(lonlat);
	
	        if ((originPx != null) && (newPx != null)) {
	            this.layerContainer.x = (originPx.x - newPx.x);
	            this.layerContainer.y  = (originPx.y - newPx.y);
	        }
		}
		
		public function isValidZoomLevel(zoomLevel:Number):Boolean {
			var isValid:Boolean = ( (!isNaN(zoomLevel)) &&
	            (zoomLevel >= 0) && 
	            (zoomLevel < this.getNumZoomLevels()) );
		    return isValid;
		}
		
		public function isValidLonLat(lonlat:LonLat):Boolean {
	        var valid:Boolean = false;
	        if (lonlat != null) {
	            var maxExtent:Bounds = this.getMaxExtent();
	            valid = maxExtent.containsLonLat(lonlat);        
	        }
	        return valid;
		}
		
		public function getProjection():String {
	        var projection:String = null;
	        if (this.baseLayer != null) {
	            projection = this.baseLayer.projection;
	        }
	        return projection;
		}
		
		public function getMaxResolution():String {
	        var maxResolution:String = null;
	        if (this.baseLayer != null) {
	            maxResolution = this.baseLayer.maxResolution.toString();
	        }
	        return maxResolution;
		}
		
		public function getMaxExtent():Bounds {
	        var maxExtentH:Bounds = null;
	        if (this.baseLayer != null) {
	            maxExtentH = this.baseLayer.maxExtent;
	        }        
	        return maxExtentH;	
		}
		
		public function getNumZoomLevels():int {	
	        var numZoomLevels:int = undefined;
	        if (this.baseLayer != null) {
	            numZoomLevels = this.baseLayer.numZoomLevels;
	        }
	        return numZoomLevels;
		}
		
		public function getExtent():Bounds {
	        var extent:Bounds = null;
	        if (this.baseLayer != null) {
	            extent = this.baseLayer.getExtent();
	        }
	        return extent;
		}
		
		public function getResolution():Number {
	        var resolution:Number = undefined;
	        if (this.baseLayer != null) {
	            resolution = this.baseLayer.getResolution();
	        }
	        return resolution;
		}
		
		public function getScale():Number {
			var scale:Number = undefined;
	        if (this.baseLayer != null) {
	            var res:Number = this.getResolution();
	            var units:String = this.baseLayer.units;
	            scale = Util.getScaleFromResolution(res, units);
	        }
	        return scale;
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
			this.zoomToExtent(this.getMaxExtent());
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
	            var dX:int = int(this.layerContainer.x);
	            var dY:int = int(this.layerContainer.y);
	            viewPortPx = layerPx.add(dX, dY);            
	        }
	        return viewPortPx;
		}
		
		public function getLayerPxFromViewPortPx(viewPortPx:Pixel):Pixel {
			var layerPx:Pixel = null;
	        if (viewPortPx != null) {
	            var dX:int = -int(this.layerContainer.x);
	            var dY:int = -int(this.layerContainer.y);
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
	}
}