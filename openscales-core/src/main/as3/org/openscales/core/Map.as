package org.openscales.core
{
  import com.gskinner.motion.GTweeny;

  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Matrix;
  import flash.geom.Rectangle;

  import org.openscales.core.basetypes.Bounds;
  import org.openscales.core.basetypes.DraggableSprite;
  import org.openscales.core.basetypes.LonLat;
  import org.openscales.core.basetypes.Pixel;
  import org.openscales.core.basetypes.Size;
  import org.openscales.core.basetypes.Unit;
  import org.openscales.core.control.IControl;
  import org.openscales.core.events.LayerEvent;
  import org.openscales.core.events.MapEvent;
  import org.openscales.core.handler.IHandler;
  import org.openscales.core.layer.Layer;
  import org.openscales.core.popup.Popup;
  import org.openscales.proj4as.ProjProjection;

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

		public var DEFAULT_TILE_WIDTH:Number = 256;
		public var DEFAULT_TILE_HEIGHT:Number = 256;
		public var DEFAULT_NUM_ZOOM_LEVELS:Number = 20;
		public var DEFAULT_MAX_RESOLUTION:Number = 1.40625;
		public var DEFAULT_PROJECTION:ProjProjection = new ProjProjection("EPSG:4326");
		public var DEFAULT_UNITS:String = Unit.DEGREE;

		/**
		 * Enable tween effects.
		 */
		public static var tween:Boolean = true;

		/**
		 * The lonlat at which the later container was re-initialized (on-zoom)
		 */
		private var _layerContainerOrigin:LonLat = null;

		private var _baseLayer:Layer = null;
		private var _layerContainer:DraggableSprite = null;
		private var _controls:Array = null;
		private var _handlers:Array = null;
		private var _tileSize:Size = null;
		private var _size:Size = null;
		private var _center:LonLat = null;
		private var _zoom:Number = 0;
		private var _zooming:Boolean = false;
		private var _maxExtent:Bounds = null;
		private var _maxResolution:Number;
		private var _minResolution:Number;
		private var _numZoomLevels:int;
		private var _resolutions:Array;
		private var _projection:ProjProjection;
		private var _units:String;
		private var _proxy:String = null;
		private var _bitmapTransition:DraggableSprite;

		/**
		 * Map constructor
		 *
		 * @param width the map width
		 * @param height the map height
		 */
		public function Map(width:Number=600, height:Number=400) {

			super();

			this._controls = new Array();
			this._handlers = new Array();

			this.size = new Size(width, height);
			this.tileSize = new Size(this.DEFAULT_TILE_WIDTH, this.DEFAULT_TILE_HEIGHT);
			this.maxExtent = new Bounds(-180,-90,180,90);
			this.maxResolution =  this.DEFAULT_MAX_RESOLUTION;
			this.projection = this.DEFAULT_PROJECTION;
			this.numZoomLevels = this.DEFAULT_NUM_ZOOM_LEVELS;
			this.units = this.DEFAULT_UNITS;

			this._layerContainer = new DraggableSprite();

			this._layerContainer.graphics.beginFill(0xFFFFFF,0);
			this._layerContainer.graphics.drawRect(0,0,this.size.w,this.size.h);
			this._layerContainer.graphics.endFill();

			this._layerContainer.width = this.size.w;
			this._layerContainer.height = this.size.h;
			this.addChild(this._layerContainer);
			Trace.map = this;

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
		 * Allows user to specify one of the currently-loaded layers as the Map's
		 * new base layer.
		 *
		 * @param newBaseLayer the new base layer.
		 */
		public function set baseLayer(newBaseLayer:Layer):void {
			var oldExtent:Bounds = null;
			if (this.baseLayer != null) {
				oldExtent = this.baseLayer.extent;
			}
			
			if (this.bitmapTransition != null)
				this.bitmapTransition.alpha = 0;
				
			if (newBaseLayer != this.baseLayer) {

				if (Util.indexOf(this.layers, newBaseLayer) != -1) {
					
					// if we set a baselayer with a diferent projection, we change the map's projection datas
					if (this.projection.srsCode != newBaseLayer.projection.srsCode) {
						
						if (this.center != null)
							this.center.transform(this.projection, newBaseLayer.projection);
						
						if (this._layerContainerOrigin != null)
							this._layerContainerOrigin.transform(this.projection, newBaseLayer.projection);
							
						oldExtent = null;
						this.projection = newBaseLayer.projection;
						this.maxResolution = newBaseLayer.maxResolution;
						this.numZoomLevels = newBaseLayer.numZoomLevels;
						this.maxExtent = newBaseLayer.maxExtent;
						this.minResolution = newBaseLayer.minResolution;
						this.resolutions = null;
					}
					
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

					this.dispatchEvent(new LayerEvent(LayerEvent.BASE_LAYER_CHANGED, newBaseLayer));

				}
			}
		}

		/**
		 * The currently selected base layer.
		 * A BaseLayer is a special kind of Layer, it determines min/max zoom level,
		 * projection, etc.
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
	                    this.baseLayer = iLayer;
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
          popup.map = null;
          popup.destroy();
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
	                this.layers[i].onMapResize();
	            }

	            if (this.baseLayer != null) {
	                var center:Pixel = new Pixel(this.size.w /2, this.size.h / 2);
	                var centerLL:LonLat = this.getLonLatFromMapPx(center);
	                var zoom:int = this.zoom;
	                this.zoom = undefined;
	                this.setCenter(this.center, zoom);
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
			var centerPx:Pixel = this.getMapPxFromLonLat(this.center);

	        // adjust
	        var newCenterPx:Pixel = centerPx.add(dx, dy);

	        // only call setCenter if there has been a change
	        if (!newCenterPx.equals(centerPx)) {
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
		private function setCenter(lonlat:LonLat, zoom:Number = NaN, dragging:Boolean = false, forceZoomChange:Boolean = false, dragTween:Boolean = false):void {
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

		/**
		 * This function takes care to recenter the layerContainer and bitmapTransition.
		 *
		 * @param lonlat the new layer container center
		 * @param tween use tween effect is set to true
		 */
		private function centerLayerContainer(lonlat:LonLat, tween:Boolean = false):void
		{
			var originPx:Pixel = this.getMapPxFromLonLat(this._layerContainerOrigin);
	        var newPx:Pixel = this.getMapPxFromLonLat(lonlat);
	        
	        if (originPx == null || newPx == null) return;
	        
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
			var isValid:Boolean = ( (!isNaN(zoomLevel)) &&
	            (zoomLevel >= 0) &&
	            (zoomLevel < this.numZoomLevels) );
		    return isValid;
		}

		/**
		 *  Check if a coordinate is valid on this map.
		 *
		 * @param lonlat the coordinate to test
		 * @return Whether or not the lonlat passed in is non-null and within the maxExtent bounds
		 */
		private function isValidLonLat(lonlat:LonLat):Boolean {
	        var valid:Boolean = false;
	        if (lonlat != null) {
	            var maxExtent:Bounds = this.maxExtent;
	            valid = maxExtent.containsLonLat(lonlat);
	        }
	        return valid;
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


		//Replaced by zoom setter
		/**
		 * Zoom to the passed in scale, recenter.
		 *
		 * @param bounds
		 */
		/*public function zoomToScale(scale:Number):void {
			var res:Number = Unit.getResolutionFromScale(scale, this.baseLayer.units);
	        var w_deg:Number = this.size.w * res;
	        var h_deg:Number = this.size.h * res;
	        var center:LonLat = this.center;

	        var extent:Bounds = new Bounds(center.lon - w_deg / 2,
	                                           center.lat - h_deg / 2,
	                                           center.lon + w_deg / 2,
	                                           center.lat + h_deg / 2);
	        this.zoomToExtent(extent);
		}*/


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
		 * Default tile size.
		 */
		public function get tileSize():Size
		{
			return _tileSize;
		}
		public function set tileSize(newTileSize:Size):void
		{
			_tileSize = newTileSize;
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
				this.zoomTransition(newZoom);

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
				var resMult:Number = this.resolution / this.resolutions[newZoom];
				// We intsanciate a bitmapdata with map's size
				var bitmapData:BitmapData = new BitmapData(this.width,this.height);
				// We draw the old transition before drawing the better-fitting tiles on top and removing the old transition. 
				if(this.bitmapTransition != null) {
					bitmapData.draw(this.bitmapTransition, bitmapTransition.transform.matrix);
					this.removeChild(this.bitmapTransition);
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
		 * Map size.
		 */
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

		/**
		 * Layer controls
		 */
		public function get controls():Array {
	        return this._controls;
		}

		/**
		 * Layer handlers
		 */
		 public function get handlers():Array {
	        return this._handlers;
		}

		/**
		 * Layer container where layers are added. It is used for panning, scaling layers.
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

		public function set units(value:String):void {
			this._units = value;
		}

		/**
		 * The map units. Check possible values in the Unit class.
      	 */
		public function get units():String {
	        var units:String = _units;
	        if (this.baseLayer != null) {
	            units = this.baseLayer.units;
	        }
	        return units;
		}

		public function set projection(value:ProjProjection):void {
			this._projection = value;
		}

		/**
		 * Set in the map options to override the default projection.
		 * Also set maxExtent, maxResolution, and units if appropriate.
		 * Default is "EPSG:4326".
		 */
		public function get projection():ProjProjection {
	        /*var projection:ProjProjection = _projection;
	        if (this.baseLayer != null) {
	            projection = this.baseLayer.projection;
	        }*/
	        return _projection;
		}

		public function set minResolution(value:Number):void {
			this._minResolution = value;
		}

		/**
		 * Minimum resolution.
		 */
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

		/**
		 * Default max is 360 deg / 256 px, which corresponds to zoom level 0 on gmaps.
		 * Specify a different value in the map options if you are not using
		 * a geographic projection and displaying the whole world.
		 */
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

		/**
		 * A list of map resolutions (map units per pixel) in descending order. If this
		 * is not set in the layer constructor, it will be set based on other resolution
		 * related properties (maxExtent, maxResolution, maxScale, etc.).
		 */
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

		/**
		 * The maximum extent for the map. Defaults to the whole world in decimal degrees
     	 * (-180, -90, 180, 90). Specify a different extent in the map options if you are
     	 * not using a geographic projection and displaying the whole world.
		 */
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

		/**
		 * Number of zoom levels for the map. Defaults to 16.  Set a different value in
		 * the map options if needed.
		 */
		public function get numZoomLevels():int {
	        var numZoomLevels:int = _numZoomLevels;
	        if (this.baseLayer != null) {
	            numZoomLevels = this.baseLayer.numZoomLevels;
	        }
	        return numZoomLevels;
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
	            scale = Unit.getScaleFromResolution(res, units);
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
		
}

}