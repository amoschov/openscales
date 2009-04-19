package org.openscales.core
{
	import com.gskinner.motion.GTweeny;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.IControl;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.handler.IHandler;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.popup.Popup;
	import org.openscales.proj.IProjection;
	import org.openscales.proj.projections.EPSG4326;
	
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
		public var DEFAULT_PROJECTION:IProjection = new EPSG4326();
		public var DEFAULT_UNITS:String = "degrees";
		
		/**
		 * Proxy (usually a PHP, Python, or Java script) used to request remote servers like 
		 * WFS servers in order to allow crossdomain requests. Remote servers can be used without 
		 * proxy script by using crossdomain.xml file like http://openscales.org/crossdomain.xml
		 */		
		public static var proxy:String = "";

		/**
		 * Enable tween effects. 
		 */
		public static var tween:Boolean = true;
						
		/**
		 * The currently selected base layer.
		 * A BaseLayer is a special kind of Layer, it determines min/max zoom level,
		 * projection, etc.
		 */		
		private var _baseLayer:Layer = null;
		
		/**
		 * Layer container where layers are added. It is used for panning, scaling layers. 
		 */
		private var _layerContainer:Sprite = null;
		
		/**
		 * Layer controls
		 */
		private var _controls:Array = null;
		
		/**
		 * Layer handlers
		 */
		private var _handlers:Array = null;
		
		/**
		 * Default tile size. 
		 */
		private var _tileSize:Size = null;
		
		/**
		 * Map size. 
		 */
		private var _size:Size = null;
		
		/**
		 * Map center coordinates.
		 */
		private var _center:LonLat = null;
		
		/**
		 * Current map zoom level. 
		 */
		private var _zoom:Number = 0;
		
		/**
		 * The maximum extent for the map. Defaults to the whole world in decimal degrees 
     	 * (-180, -90, 180, 90). Specify a different extent in the map options if you are
     	 * not using a geographic projection and displaying the whole world. 
		 */		
		private var _maxExtent:Bounds = null;
		
		/**
		 * Default max is 360 deg / 256 px, which corresponds to zoom level 0 on gmaps.
		 * Specify a different value in the map options if you are not using 
		 * a geographic projection and displaying the whole world. 
		 */		
		private var _maxResolution:Number;
		
		/**
		 * Minimum resolution. 
		 */		
		private var _minResolution:Number;
		
		/**
		 * Number of zoom levels for the map. Defaults to 16.  Set a different value in 
		 * the map options if needed. 
		 */
		private var _numZoomLevels:int;
		
		/**
		 * A list of map resolutions (map units per pixel) in descending order. If this 
		 * is not set in the layer constructor, it will be set based on other resolution
		 * related properties (maxExtent, maxResolution, maxScale, etc.). 
		 */
		private var _resolutions:Array;
		
		/**
		 * Set in the map options to override the default projection.
		 * Also set maxExtent, maxResolution, and units if appropriate.
		 * Default is "EPSG:4326". 
		 */		
		private var _projection:IProjection;
		
		/**
		 * The map units.  Defaults to 'degrees'.  Possible values are
         *  'degrees' (or 'dd'), 'm', 'ft', 'km', 'mi', 'inches'
      	 */		
		private var _units:String;
		
		private var _layerContainerOrigin:LonLat = null;
		
		/**
		 * Map constructor
		 *  
		 * @param width the map width
		 * @param height the map height
		 * @param options use to easily specify optional properties
		 */
		public function Map(width:Number=600, height:Number=400, options:Object = null):void {
			
			super();
			
			Util.extend(this, options);	
			
			this._controls = new Array();
			this._handlers = new Array();
									
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
		 * Removes a layer from the map by removing its visual element , then removing 
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
	                    this.setBaseLayer(iLayer);
	                    break;
	                }
	            }
	        }
	        
	        this.dispatchEvent(new LayerEvent(LayerEvent.LAYER_REMOVED, layer));	
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
			this._controls.push(control);
        	control.map = this;
        	control.draw();
        	if(attach)
        		this.addChild( control as Sprite );
		}
		
		/**
		 * Add and activate a new handler to the map.
		 *  
		 * @param handler the handler to add.
		 */		
		public function addHandler(handler:IHandler):void {
			this._handlers.push(handler);
        	handler.map = this;
        	handler.active = true;
		}
				
		public function setBaseLayer(newBaseLayer:Layer, noEvent:Boolean = false):void {
			var oldExtent:Bounds = null;
			if (this.baseLayer != null) {
				oldExtent = this.baseLayer.extent;
			}
			
			if (newBaseLayer != this.baseLayer) {
				
				if (Util.indexOf(this.layers, newBaseLayer) != -1) {
										
					this._baseLayer = newBaseLayer;
					this.baseLayer.visible = true;
					
					var center:LonLat = this.center;
					if (center != null) {
						if (oldExtent == null) {
							this.setCenter(center, this.zoom, false, true);
						} else {
							this.setCenter(oldExtent.centerLonLat, 
                                       this.getZoomForExtent(oldExtent),
                                       false, true);
						}
					}
					
					if (!noEvent) {
						this.dispatchEvent(new LayerEvent(LayerEvent.BASE_LAYER_CHANGED, newBaseLayer));
					}
					
				}
			}
		}
		
		/** 
	    * @param {OpenLayers.Popup} popup
	    * @param {Boolean} exclusive If true, closes all other popups first
	    **/
	    public function addPopup(popup:Popup, exclusive:Boolean = true):void {
	        popup.map = this;	                
	        popup.draw();
	        this._layerContainer.addChild(popup);
	    }

	    public function removePopup(popup:Popup):void {
	        this._layerContainer.removeChild(popup);
	        popup.map = null;
	    }
		
		public function updateSize():void { 
				
				this.graphics.clear();
				this.graphics.beginFill(0xFFFFFF);
				this.graphics.drawRect(0,0,this.size.w,this.size.h);
				this.graphics.endFill();
				this.scrollRect = new Rectangle(0,0,this.size.w,this.size.h);
				
				this.dispatchEvent(new MapEvent(MapEvent.RESIZE, this));
					            	
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
		
		public function pan(dx:int, dy:int, tween:Boolean=false):void {
			var centerPx:Pixel = this.getViewPortPxFromLonLat(this.center);
	
	        // adjust
	        var newCenterPx:Pixel = centerPx.add(dx, dy);
	        
	        // only call setCenter if there has been a change
	        if (!newCenterPx.equals(centerPx)) {
	            var newCenterLonLat:LonLat = this.getLonLatFromViewPortPx(newCenterPx);
	            this.setCenter(newCenterLonLat, NaN, false, false, tween);
	        }
		}
		
		public function setCenter(lonlat:LonLat, zoom:Number = NaN, dragging:Boolean = false, forceZoomChange:Boolean = false, dragTween:Boolean = false):void {
			if (!this.center && !this.isValidLonLat(lonlat)) {
	            lonlat = this.maxExtent.centerLonLat;
	        }
	        
	        var zoomChanged:Boolean = forceZoomChange || (
	                            (this.isValidZoomLevel(zoom)) && 
	                            (zoom != this.zoom) );
	
	        var centerChanged:Boolean = (this.isValidLonLat(lonlat)) && 
	                            (!lonlat.equals(this.center));
			

	        if (zoomChanged || centerChanged || !dragging) {
	
	            if (!dragging) { 
	            	this.dispatchEvent(new MapEvent(MapEvent.MOVE_START, this)); 
	       
	            }
	
	            if (centerChanged) {
	                if ((!zoomChanged) && (this.center)) { 
	                    this.centerLayerContainer(lonlat, dragTween);
	                }
	                this.center = lonlat.clone();
	                
	            }

	            if ((zoomChanged) || (this._layerContainerOrigin == null)) {
	                this._layerContainerOrigin = this.center.clone();
	                this._layerContainer.x = 0;
	                this._layerContainer.y = 0;
	            }
	
	            if (zoomChanged) {
	                this._zoom = zoom;
	            } 
	            
	            var bounds:Bounds = this.extent;
  	
	            this.baseLayer.moveTo(bounds, zoomChanged, dragging);
	            for (var i:int = 0; i < this.layers.length; i++) {
	                var layer:Layer = this.layers[i];
	                if (!layer.isBaseLayer) {
	                    
	                    var moveLayer:Boolean;
	                    var inRange:Boolean = layer.calculateInRange();
	                    if (layer.inRange != inRange) {
	                        layer.inRange = inRange;
	                        moveLayer = true;
	                        this.dispatchEvent(new LayerEvent(LayerEvent.LAYER_CHANGED, layer));
	                    } else {
	                        moveLayer = (layer.visible && layer.inRange);
	                    }
	
	                    if (moveLayer) {
	                        layer.moveTo(bounds, zoomChanged, dragging);
	                    }
	                }                
	            }
	            
	            this.dispatchEvent(new MapEvent(MapEvent.MOVE, this));
	    
	            if (zoomChanged) { 
	            	this.dispatchEvent(new MapEvent(MapEvent.ZOOM_END, this)); 
	            }
	        }

	        if (!dragging) { 
	           	this.dispatchEvent(new MapEvent(MapEvent.MOVE_END, this)); 
	        }
		}
		
		public function centerLayerContainer(lonlat:LonLat, tween:Boolean = false):void {
			var originPx:Pixel = this.getViewPortPxFromLonLat(this._layerContainerOrigin);
	        var newPx:Pixel = this.getViewPortPxFromLonLat(lonlat);
	
	        if ((originPx != null) && (newPx != null)) {
	        	if(tween) {
		        	new GTweeny(this._layerContainer, 0.5, {x:(originPx.x - newPx.x)});
		        	new GTweeny(this._layerContainer, 0.5, {y:(originPx.y - newPx.y)});
	        	}
	        	else {
	        		this._layerContainer.x = (originPx.x - newPx.x);
	            	this._layerContainer.y  = (originPx.y - newPx.y); 
	        	}
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
			
		public function zoomIn():void{
			this.zoom = this.zoom + 1;
		}
		
		public function zoomOut():void {
			this.zoom = this.zoom - 1;
		}
		
		public function zoomToExtent(bounds:Bounds):void {
	        this.setCenter(bounds.centerLonLat, this.getZoomForExtent(bounds));
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
			if (this.isValidZoomLevel(newZoom)) {
	            this.setCenter(null, newZoom);
	        }
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
		
		override public function set width(value:Number):void {
			this._size.w = value;
			this.updateSize();
		}
		
		override public function set height(value:Number):void {
			this._size.h = value;
			this.updateSize();			
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
		
		public function set projection(value:IProjection):void {
			this._projection = value;
		}
		
		public function get projection():IProjection {
	        var projection:IProjection = _projection;
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
		
		 public function get layers():Array 
		 {
	    	var layerArray:Array = new Array();
	    	if(this.layerContainer == null)
	    	{
	    		return layerArray;
	    	}
	    	for(var i:int = 0;i<this.layerContainer.numChildren;i++)
	    	{
	    		if(this.layerContainer.getChildAt(i) is Layer)
	    		{
	    				layerArray.push(this.layerContainer.getChildAt(i)) 			
	    		}
	    	}
	    	return layerArray;
	    
	    }
	    
	    public static function loadURL(uri:String, params:Object, caller:Object, onComplete:Function = null):void {
			      
			var successorfailure:Function = onComplete;
			
			new Request(uri,
                     {   method: URLRequestMethod.GET, 
                         parameters: params,
                         onComplete: successorfailure
                      }, Map.proxy);
		}
		
	}
}