package org.openscales.core.layer
{
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.proj.IProjection;
	
	public class Layer extends Sprite
	{
			
		/**
		 * Whether or not the layer is a base layer. This should be set
		 * individually by all subclasses. Default is false
		 */
		private var _isBaseLayer:Boolean = false;
										
		/**
		 * Rhe current map resolution is within the layer's min/max range.
		 * This is set in <Map.setCenter> whenever the zoom changes.
		 */
		private var _inRange:Boolean = false;
		
		/**
		 * For layers with a gutter, the image offset represents displacement due 
		 * to the gutter
		 */
		private var _imageOffset:Pixel = null;
		
		 /**
 	     * Determines the width (in pixels) of the gutter around image
 	     *     tiles to ignore.  By setting this property to a non-zero value,
 	     *     images will be requested that are wider and taller than the tile
 	     *     size by a value of 2 x gutter.  This allows artifacts of rendering
 	     *     at tile edges to be ignored.  Set a gutter value that is equal to
 	     *     half the size of the widest symbol that needs to be displayed.
	     *     Defaults to zero.  Non-tiled layers always have zero gutter.
	     */
		private var _gutter:Number = 0;
		
		private var _projection:IProjection = null;
		
		private var _units:String = null;
				
		private var _resolutions:Array = null;
		
		private var _maxExtent:Bounds = null;
		
		private var _maxResolution:Number;
		
		private var _minResolution:Number;
		
		private var _numZoomLevels:int;
		
		private var _minZoomLevel:Number;		

		private var _displayOutsideMaxExtent:Boolean = false;		
		
		protected var _imageSize:Size = null;
		
		private var _buffer:Number;
		
		private var _map:Map = null;
		
		public function Layer(name:String, options:Object = null):void {
			
			Util.extend(this, options);
			
			this.name = name;
			this.doubleClickEnabled = true;
	
		}
		
		public function destroy(setNewBaseLayer:Boolean = true):void {
			if (this.map != null) {
				this.map.removeLayer(this, setNewBaseLayer);
			}
			this.map = null;
			
		}
		
		public function onMapResize():void {
			
		}
		
		public function redraw():Boolean {
			var redrawn:Boolean = false;
	        if (this.map) {
	
	            // min/max Range may have changed
	            this.inRange = this.calculateInRange();
	
	            // map's center might not yet be set
	            var extent:Bounds = this.extent;
	
	            if (extent && this.inRange && this.visible) {
	                this.moveTo(extent, true, false);
	                redrawn = true;
	            }
	        }
	        return redrawn;
		}
		
		public function set map(map:Map):void {
			if (this._map == null) {
        
	            this._map = map;

	            this.maxExtent = this.maxExtent || this.map.maxExtent;
	            this.projection = this.projection || this.map.projection;
	            this.units = this.units || this.map.units;
	            
	            this.initResolutions();
	            
	            if (!this.isBaseLayer) {
	                this.inRange = this.calculateInRange();
	                var show:Boolean = ((this.visible) && (this.inRange));
	                this.visible = (show ? true : false);
	            }

	        }
		}
		
		public function get map():Map {
			return this._map;
		}		
		
		public function initResolutions():void {
			
	        var props:Array = new Array(
	          'projection', 'units', 'resolutions',
	          'maxResolution', 'minResolution', 'maxExtent',
	          'numZoomLevels'
	        );
	
	        var confProps:Object = new Object();        
	        for(var i:int=0; i < props.length; i++) {
	            var property:String = props[i];
	            confProps[property] = this.map[property];
	        }

	        if ( (!confProps.numZoomLevels) && (confProps.maxZoomLevel) ) {
	            confProps.numZoomLevels = confProps.maxZoomLevel + 1;
	        }

	        if ((confProps.scales != null) || (confProps.resolutions != null)) {
	            if (confProps.scales != null) {
	                confProps.resolutions = new Array();
	                for(i = 0; i < confProps.scales.length; i++) {
	                    var scale:Number = confProps.scales[i];
	                    confProps.resolutions[i] = 
	                       new Util().getResolutionFromScale(scale, 
	                                                              confProps.units);
	                }
	            }
	            confProps.numZoomLevels = confProps.resolutions.length;
	
	        } else {
	            
	            confProps.resolutions = new Array();
	           
	            if (confProps.minScale) {
	                confProps.maxResolution = 
	                    new Util().getResolutionFromScale(confProps.minScale, 
	                                                           confProps.units);
	            } else if (confProps.maxResolution == "auto") {
	                var viewSize:Size = this.map.size;
	                var wRes:Number = confProps.maxExtent.getWidth() / viewSize.w;
	                var hRes:Number = confProps.maxExtent.getHeight()/ viewSize.h;
	                confProps.maxResolution = Math.max(wRes, hRes);
	            } 

	            if (confProps.maxScale) {           
	                confProps.minResolution = 
	                    new Util().getResolutionFromScale(confProps.maxScale);
	            } else if ( (confProps.minResolution == "auto") && 
	                        (!confProps.minExtent) ) {
	                viewSize = this.map.size;
	                wRes = confProps.minExtent.getWidth() / viewSize.w;
	                hRes = confProps.minExtent.getHeight()/ viewSize.h;
	                confProps.minResolution = Math.max(wRes, hRes);
	            } 

	            if (confProps.minResolution) {
	                var ratio:Number = confProps.maxResolution / confProps.minResolution;
	                confProps.numZoomLevels = 
	                    Math.floor(Math.log(ratio) / Math.log(2)) + 1;
	            }

 	            for (i=0; i < confProps.numZoomLevels; i++) {
	                var res:Number = confProps.maxResolution / Math.pow(2, i)
	                confProps.resolutions.push(res);
	            }    
	        }
	        
	        confProps.resolutions.sort(Array.NUMERIC | Array.DESCENDING);
	
	        this.resolutions = confProps.resolutions;
	        this.maxResolution = confProps.resolutions[0];
	        var lastIndex:int = confProps.resolutions.length - 1;
	        this.minResolution = confProps.resolutions[lastIndex];        
	        this.numZoomLevels = confProps.numZoomLevels;

		}
		
		public function clone(obj:Object):Object {
			if (obj == null) {
	            obj = new Layer(this.name);
	        } 
	        
	        Util.applyDefaults(obj, this);

	        obj.map = null;
	        
	        return obj;
		}
		
		public function get extent():Bounds {
			return this.map.extent;
		}
		
		public function getZoomForExtent(extent:Bounds):Number {
			var viewSize:Size = this.map.size;
	        var idealResolution:Number = Math.max( extent.width  / viewSize.w,
	                                        extent.height / viewSize.h );
	
	        return this.getZoomForResolution(idealResolution);
		}
		
		public function getZoomForResolution(resolution:Number):Number {
			for(var i:int=1; i < this.resolutions.length; i++) {
	            if ( this.resolutions[i] < resolution) {
	                break;
	            }
	        }
	        return (i - 1);
		}
		
		public function getLonLatFromMapPx(viewPortPx:Pixel):LonLat {
			var lonlat:LonLat = null;
	        if (viewPortPx != null) {
	            var size:Size = this.map.size;
	            var center:LonLat = this.map.center;
	            if (center) {
	                var res:Number  = this.map.resolution;
	        
	                var delta_x:Number = viewPortPx.x - (size.w / 2);
	                var delta_y:Number = viewPortPx.y - (size.h / 2);
	            
	                lonlat = new LonLat(center.lon + delta_x * res ,
	                                             center.lat - delta_y * res); 
	            }
	        }
	        return lonlat;
		}
		
		public function getMapPxFromLonLat(lonlat:LonLat):Pixel {
			var px:Pixel = null; 
	        if (lonlat != null) {
	            var resolution:Number = this.map.resolution;
	            var extent:Bounds = this.map.extent;
	            px = new Pixel(
	                           Math.round(1/resolution * (lonlat.lon - extent.left)),
	                           Math.round(1/resolution * (extent.top - lonlat.lat))
	                           );    
	        }
	        return px;
		}
		
		public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false):void {
			var display:Boolean = this.visible;
	        if (!this.isBaseLayer) {
	            display = display && this.inRange;
	        }
	        this.visible = display;
		}
		
		public function calculateInRange():Boolean {
			var inRange:Boolean = false;
	        if (this.map) {
	            var resolution:Number = this.map.resolution;
	            inRange = ( (resolution >= this.minResolution) &&
	                        (resolution <= this.maxResolution) );
	        }
	        return inRange;
		}
		
		public function adjustBoundsByGutter(bounds:Bounds):Bounds {
			var mapGutter:Number = this.gutter * this.map.resolution;
	        bounds = new Bounds(bounds.left - mapGutter,
	                                       bounds.bottom - mapGutter,
	                                       bounds.right + mapGutter,
	                                       bounds.top + mapGutter);
	        return bounds;
		}
		
		public function get resolution():Number {	
	        var zoom:Number = this.map.zoom;
	        return this.resolutions[zoom];
		}
		
		public function getURL(bounds:Bounds):String {
			return null;
		}
		
		public function get imageSize():Size {
			return this._imageSize; 
		}
		
		public function set imageSize(value:Size):void {
			this._imageSize = value; 
		}
			    
	    public function get zindex():int
	    {
	    	return this.parent.getChildIndex(this);
	    }
	    
		public function set zindex(value:int):void {
			this.parent.setChildIndex(this, value);
	    }
	    
	    public function get displayOutsideMaxExtent():Boolean {
	    	return this._displayOutsideMaxExtent;
	    }
	    
		public function set displayOutsideMaxExtent(value:Boolean):void {
	    	this._displayOutsideMaxExtent = value;
	    }	    
	    
	    public function get minZoomLevel():Number {
			return this._minZoomLevel; 
		}
		
		public function set minZoomLevel(value:Number):void {
			this._minZoomLevel = value; 
		}
		
		public function get numZoomLevels():int {
			return this._numZoomLevels; 
		}
		
		public function set numZoomLevels(value:int):void {
			this._numZoomLevels = value; 
		}
		
		public function get maxResolution():Number {
			return this._maxResolution; 
		}
		
		public function set maxResolution(value:Number):void {
			this._maxResolution = value; 
		}
		
		public function get minResolution():Number {
			return this._minResolution; 
		}
		
		public function set minResolution(value:Number):void {
			this._minResolution = value; 
		}
		
		public function get maxExtent():Bounds {
			return this._maxExtent; 
		}
		
		public function set maxExtent(value:Bounds):void {
			this._maxExtent = value; 
		}
		
		public function get resolutions():Array {
			return this._resolutions; 
		}
		
		public function set resolutions(value:Array):void {
			this._resolutions = value; 
		}
		
		public function get units():String {
			return this._units; 
		}
		
		public function set units(value:String):void {
			this._units = value; 
		}
		
		public function get projection():IProjection {
			return this._projection; 
		}
		
		public function set projection(value:IProjection):void {
			this._projection = value; 
		}
		
		public function get gutter():Number {
			return this._gutter; 
		}
		
		public function set gutter(value:Number):void {
			this._gutter = value; 
		}
		
		public function get imageOffset():Pixel {
			return this._imageOffset; 
		}
		
		public function set imageOffset(value:Pixel):void {
			this._imageOffset = value; 
		}
		
		public function get inRange():Boolean {
	    	return this._inRange;
	    }
	    
		public function set inRange(value:Boolean):void {
	    	this._inRange = value;
	    }
	    
	    public function get isBaseLayer():Boolean {
	    	return this._isBaseLayer;
	    }
	    
		public function set isBaseLayer(value:Boolean):void {
	    	this._isBaseLayer = value;
	    }
	    
	    public function get buffer():Number {
			return this._buffer; 
		}
		
		public function set buffer(value:Number):void {
			this._buffer = value; 
		}
	    
		
	}
}