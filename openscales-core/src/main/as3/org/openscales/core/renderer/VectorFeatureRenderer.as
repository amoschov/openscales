package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.geometry.Rectangle;
	import org.openscales.core.geometry.Surface;
	import org.openscales.core.Map;
	import org.openscales.core.geometry.Curve;
	import org.openscales.core.layer.Grid;
	
	/**
	 * Flash Sprite based renderer.
	 * Need to be refactored to be less DOM and element oriented.
	 */
	public class VectorFeatureRenderer
	{
	
		private var _container:Sprite = null;	
	    private var _extent:Bounds = null;
	    private var _size:Size = null;
	    private var _resolution:Number;
	    private var _map:Map = null;
		private var _localResolution:Number = 99999;
		private var _left:Number;
		private var _right:Number;
		private var _top:Number;
		private var _bottom:Number;
		private var _maxPixel:Number;
		
		public function VectorFeatureRenderer(container:Sprite) {
			this.container = container;
		}
		
		public function destroy():void {
			this.container = null;
	        this.extent = null;
	        this.size =  null;
	        this.resolution = NaN;
	        this.map = null;
		}
		
		public function onMapresize():void
		{
		    this._left = -extent.left / resolution;
	        this._top = extent.top / resolution;
		}		
			
		public function applyStyle(sprite:Sprite, style:Style):void {
	        
	        if (style.isFilled) {
				sprite.graphics.beginFill(style.fillColor, style.fillOpacity);
           	} else {
            	sprite.graphics.endFill();
           	}
	    
            if (style.isStroked) {
                sprite.graphics.lineStyle(style.strokeWidth, style.strokeColor, style.strokeOpacity, false, "normal", style.strokeLinecap);
            }
	        
		}
		
		public function drawPoint(geometry:Point, radius:Number, feature:Sprite):void {
			this.drawCircle(geometry, radius, feature);
		}
		
		public function drawCircle(geometry:Point, radius:Number, feature:Sprite):void {
			var resolution:Number = this.resolution;
	        var x:Number = (geometry.x / resolution + this._left);
	        var y:Number = (this._top - geometry.y / resolution);
	        var draw:Boolean = true;
	        if (x < -this._maxPixel || x > this._maxPixel) { draw = false; }
	        if (y < -this._maxPixel || y > this._maxPixel) { draw = false; }
	
	        if (draw) { 
	            feature.graphics.drawCircle(x, y, radius);
	        } else {
	            this.container.removeChild(feature);
	        } 
		}
		
		public function drawLineString(geometry:LineString, feature:Sprite):void {
			for (var i:int = 0; i < geometry.components.length; i++) {
				var componentString:String = this.getShortString(geometry.components[i]);
				var componentPoint:Array = componentString.split(",");
				if (i==0) {
					feature.graphics.moveTo(int(componentPoint[0]), int(componentPoint[1]));
				} else {
					feature.graphics.lineTo(int(componentPoint[0]), int(componentPoint[1])); 
				}
			}  
		}
		
		public function drawPolygon(geometry:Polygon, feature:Sprite):void {
	        var draw:Boolean = true;
	        for (var j:int = 0; j < geometry.components.length; j++) {
	            var linearRing:LinearRing = geometry.components[j];
	            for (var i:int = 0; i < linearRing.components.length; i++) {
	                var component:String = this.getShortString(linearRing.components[i]);
	                if (component) {
	                	var coords:Array = component.split(",");
	                	if (i==0) {
	                    	feature.graphics.moveTo(int(coords[0]), int(coords[1]));
	                 	} else {
	                 		feature.graphics.lineTo(int(coords[0]), int(coords[1]));
	                 	}
	                } else {
	                    draw = false;
	                    feature.graphics.clear();
	                }    
	            }
	        } 
		}
		
		public function drawRectangle(geometry:Rectangle, feature:Sprite):void {
	        var x:Number = (geometry.x / resolution + this._left);
	        var y:Number = (geometry.y / resolution - this._top);
	        var draw:Boolean = true;
	        if (x < -this._maxPixel || x > this._maxPixel) { draw = false; }
	        if (y < -this._maxPixel || y > this._maxPixel) { draw = false; }
	        if (draw) {
	            feature.graphics.drawRect(x, y, geometry.width, geometry.height);
	        } else {
	            feature.graphics.drawRect(0, 0, 0, 0);
	        }
		}
		
		public function drawCurve(geometry:Curve, feature:Sprite):void {
			var d:String = null;
	        var draw:Boolean = true;
	        var component:String;
	        for (var i:int = 0; i < geometry.components.length; i++) {
	            if ((i%3) == 0 && (i/3) == 0) {
	                component = this.getShortString(geometry.components[i]);
	                if (!component) { draw = false; }
	                d = "M " + component;
	            } else if ((i%3) == 1) {
	                component = this.getShortString(geometry.components[i]);
	                if (!component) { draw = false; }
	                d += " C " + component;
	            } else {
	                component = this.getShortString(geometry.components[i]);
	                if (!component) { draw = false; }
	                d += " " + component;
	            }
	        }
		}
		
		public function drawLinearRing():void {
			Trace.warning("drawLinearRing : To be implemented");
		}
		
		 public function drawSurface():void {
		 	Trace.warning("drawSurface : To be implemented");
		 }
		
		public function getComponentsString(components:Collection):String {
			var strings:Array = [];
	        for(var i:int = 0; i < components.length; i++) {
	            var component:String = this.getShortString(components[i]);
	            if (component) {
	                strings.push(component);
	            }
	        }
	        return strings.join(",");
		}
		
		public function getShortString(point:Point):String {
	        var resolution:Number = this.resolution;
	        var x:Number = (point.x / resolution + this._left);
	        var y:Number = (this._top - point.y / resolution);
	        if (x < -this._maxPixel || x > this._maxPixel) { return null; }
	        if (y < -this._maxPixel || y > this._maxPixel) { return null; }
	        var string:String =  x + "," + y;  
	        return string;
		}
				
		public function eraseGeometry(geometry:Geometry):void {
			
			if ((geometry is MultiPoint) || (geometry is MultiLineString) || (geometry is MultiPolygon)) {
	            for (var i:int = 0; i < (geometry as Collection).components.length; i++) {
	                this.eraseGeometry((geometry as Collection).components[i]);
	            }
	        } 
	        else 
	        {
	        	var element:Object = this.container.getChildByName(geometry.id);
	        	if(element!=null) element.parent.removeChild(element);
	        }
	        
		}
		
		// Elements functions
		
		public function clear():void {
	    	if (this.container) {
	            while (this.container.numChildren > 0) {
	            	this.container.removeChildAt(this.container.numChildren-1);
	            }
	        }
	    }
	    
	    public function drawFeature(feature:VectorFeature):void {
			feature.graphics.clear();   
	        this.container.addChild(feature);
	        
		    if(feature.geometry is Collection)
		    {
		    	// Draw child components
		    	var col:Collection = feature.geometry as Collection;
	            for (var i:int = 0; i < col.components.length; i++) {
	                this.drawGeometry(col.components[i], feature, feature.style);
	            }
	        }
	        
	        // Draw the geometry
	        this.drawGeometry(feature.geometry, feature, feature.style);
	        
	    }
	    	    
	    public function moveFeature(feature:VectorFeature):void {
	    	feature.graphics.clear();
	    	this.drawFeature(feature);
	    }
    
    	private function drawGeometry(geometry:Geometry, sprite:Sprite, style:Style):void {       
			
			this.applyStyle(sprite, style);
			
	        switch (getQualifiedClassName(geometry)) {
	            case "org.openscales.core.geometry::Point":
	                this.drawPoint(geometry as Point, style.pointRadius, sprite);
	                break;
	            case "org.openscales.core.geometry::LineString":
	                this.drawLineString(geometry as LineString, sprite);
	                break;
	            case "org.openscales.core.geometry::Polygon":
	                this.drawPolygon(geometry as Polygon, sprite);
	                break;
	            case "org.openscales.core.geometry::Rectangle":
	                this.drawRectangle(geometry as Rectangle, sprite);
	                break;
	            default:
	                break;
	        }
	        
    	}
    	
    	//Getters and Setters
		public function get container():Sprite {
			return this._container;
		}
		
		public function set container(value:Sprite):void {
			this._container = value;
		}
		
		public function get extent():Bounds {
			return this._extent;
		}
		
		public function set extent(extent:Bounds):void {
			this._extent = extent;
	        
	        var resolution:Number = this.resolution;

	    //TO resolve resizing problems  //  
	    if (!this._localResolution || resolution != this._localResolution) {
	            this._left = -extent.left / resolution;
	            this._top = extent.top / resolution;
	        }
	        var left:Number = 0;
	        var top:Number = 0;
	
	        // If the resolution has not changed, we already have features, and we need
	        // to adjust the viewbox to fit them.
	        if (this._localResolution && resolution == this._localResolution) {
	            left = (this._left) - (-extent.left / resolution);
	            top  = (this._top) - (extent.top / resolution);
	        }    
	        
	        // Store resolution for use later.
	        this._localResolution = resolution;
	        
	        // Set the viewbox -- the left/top will be pixels-dragged-since-res change,
	        // the width/height will be pixels.
	        var extentString:String = left + " " + top + " " + 
	                             extent.width / resolution + " " + extent.height / resolution;

		}
				
		public function get size():Size {
			return this._size;
		}
		
		public function set size(size:Size):void {
			this._size = size;
	        
	      	// Ugly trick due to the fact we can't set the size of and empty Sprite 
			this.container.graphics.drawRect(0,0,this.size.w,this.size.h);
	        this.container.width = this.size.w;
	        this.container.height = this.size.h;
        	
		}
				
		public function get resolution():Number {
			var resolution:Number = this._resolution || this.map.resolution;
        	return resolution;
		}
		
		public function set resolution(value:Number):void {
			this._resolution = value;
		}
		
		public function get map():Map {
			return this._map;
		}
		
		public function set map(value:Map):void {
			this._map = value;
		}   		    	
		
	}
}