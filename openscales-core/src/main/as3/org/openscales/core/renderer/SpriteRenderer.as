package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.geometry.Rectangle;
	import org.openscales.core.geometry.Surface;
	
	/**
	 * Flash Sprite based renderer.
	 * Need to be refactored to be less DOM and element oriented.
	 */
	public class SpriteRenderer extends Renderer
	{
		
		private var _localResolution:Number = 99999;
		private var _left:Number;
		private var _right:Number;
		private var _top:Number;
		private var _bottom:Number;
		private var _maxPixel:Number;
		
		public function SpriteRenderer(container:Sprite):void {
			super(container);
		}
		
		override public function destroy():void {
			super.destroy();
		}
		
		override public function set extent(extent:Bounds):void {
			super.extent = extent;
	        
	        var resolution:Number = this.resolution;

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
	        //var extentString = extent.left / resolution + " " + -extent.top / resolution + " " + 
/* 	        this.rendererRoot.viewBox = extentString; */
		}
		
		override public function set size(size:Size):void {
			super.size = size;
	        
	      	// Ugly trick due to the fact we can't set the size of and empty Sprite 
			this.container.graphics.drawRect(0,0,this.size.w,this.size.h);
	        this.container.width = this.size.w;
	        this.container.height = this.size.h;
        	
		}
		
		public function getNodeType(geometry:Geometry):String {
			var nodeType:String = null;
	        switch (getQualifiedClassName(geometry)) {
	            case "org.openscales.core.geometry::Point":
	                nodeType = "circle";
	                break;
	            case "org.openscales.core.geometry::Rectangle":
	                nodeType = "rect";
	                break;
	            case "org.openscales.core.geometry::LineString":
	                nodeType = "line";
	                break;
	            case "org.openscales.core.geometry::LinearRing":
	                nodeType = "line";
	                break;
	            case "org.openscales.core.geometry::Polygon":
	            case "org.openscales.core.geometry::Curve":
	            case "org.openscales.core.geometry::Surface":
	                nodeType = "line";
	                break;
	            default:
	                break;
	        }
	        return nodeType;
		}
		
		public function setStyle(node:SpriteElement, style:Style, options:Object):void {	
	        style = style  || node.style;
	        options = options || node.options;
	
	        /*if (node.geometryClass == "org.openscales.core.geometry::Point") {
	            node.attributes.r = style.pointRadius;
	        }*/
	        
	        if (options.isFilled) {
	            node.graphics.beginFill(style.fillColor, style.fillOpacity);
	        } else {
	            node.graphics.endFill();
	        }
	
	        if (options.isStroked) {
	        	node.graphics.lineStyle(style.strokeWidth, style.strokeColor, style.strokeOpacity, false, "normal", style.strokeLinecap);
	        } else {
	            //don't draw the line
	        }
	        
	        /*if (style.pointerEvents) {
	            node.attributes.pointerEvents = style.pointerEvents;
	        }
	        
	        if (style.cursor) {
	            node.attributes.cursor = style.cursor;
	        }*/
		}
		
		public function removeStyle(node:SpriteElement, style:Style, options:Object):void {
	        style = style  || node.style;
	        options = options || node.options;
	        
	        if (options.isFilled) {
	            node.graphics.beginFill(style.fillColor, style.fillOpacity);
	        }
	        
		}
		
		public function drawPoint(node:SpriteElement, geometry:Point):void {
			this.drawCircle(node, geometry, node.style.pointRadius);
		}
		
		public function drawCircle(node:SpriteElement, geometry:Point, radius:Number):void {
			var resolution:Number = this.resolution;
	        var x:Number = (geometry.x / resolution + this._left);
	        var y:Number = (this._top - geometry.y / resolution);
	        var draw:Boolean = true;
	        if (x < -this._maxPixel || x > this._maxPixel) { draw = false; }
	        if (y < -this._maxPixel || y > this._maxPixel) { draw = false; }
	
	        if (draw) { 
	            node.graphics.drawCircle(x, y, radius);
	        } else {
	            this.container.removeChild(node);
	        } 
		}
		
		public function drawLineString(node:SpriteElement, geometry:LineString):void {
			for (var i:int = 0; i < geometry.components.length; i++) {
				var componentString:String = this.getShortString(geometry.components[i]);
				var componentPoint:Array = componentString.split(",");
				if (i==0) {
					node.graphics.moveTo(int(componentPoint[0]), int(componentPoint[1]));
				} else {
					node.graphics.lineTo(int(componentPoint[0]), int(componentPoint[1])); 
				}
			}  
		}
		
		public function drawPolygon(node:SpriteElement, geometry:Polygon):void {
	        var draw:Boolean = true;
	        for (var j:int = 0; j < geometry.components.length; j++) {
	            var linearRing:LinearRing = geometry.components[j];
	            for (var i:int = 0; i < linearRing.components.length; i++) {
	                var component:String = this.getShortString(linearRing.components[i]);
	                if (component) {
	                	var coords:Array = component.split(",");
	                	if (i==0) {
	                    	node.graphics.moveTo(int(coords[0]), int(coords[1]));
	                 	} else {
	                 		node.graphics.lineTo(int(coords[0]), int(coords[1]));
	                 	}
	                } else {
	                    draw = false;
	                    node.graphics.clear();
	                }    
	            }
	        } 
		}
		
		public function drawRectangle(node:SpriteElement, geometry:Rectangle):void {
	        var x:Number = (geometry.x / resolution + this._left);
	        var y:Number = (geometry.y / resolution - this._top);
	        var draw:Boolean = true;
	        if (x < -this._maxPixel || x > this._maxPixel) { draw = false; }
	        if (y < -this._maxPixel || y > this._maxPixel) { draw = false; }
	        if (draw) {
	            node.graphics.drawRect(x, y, geometry.width, geometry.height);
	        } else {
	            node.graphics.drawRect(0, 0, 0, 0);
	        }
		}
		
		public function drawCurve(node:SpriteElement, geometry:Geometry):void {
			var d:String = null;
	        var draw:Boolean = true;
	        var component:String;
	        for (var i:int = 0; i < (geometry as Collection).components.length; i++) {
	            if ((i%3) == 0 && (i/3) == 0) {
	                component = this.getShortString((geometry as Collection).components[i]);
	                if (!component) { draw = false; }
	                d = "M " + component;
	            } else if ((i%3) == 1) {
	                component = this.getShortString((geometry as Collection).components[i]);
	                if (!component) { draw = false; }
	                d += " C " + component;
	            } else {
	                component = this.getShortString((geometry as Collection).components[i]);
	                if (!component) { draw = false; }
	                d += " " + component;
	            }
	        }
	        if (draw) {
	            node.attributes.d = d;
	        } else {
	            node.attributes.d = "";
	        }    
		}
		
		public function drawLinearRing(node:SpriteElement, geometry:LinearRing):void {
			trace("drawLinearRing : To be implemented");
		}
		
		 public function drawSurface(node:SpriteElement, geometry:Surface):void {
		 	trace("drawSurface : To be implemented");
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
		
		public function createNode(type:Object, id:Object):SpriteElement {
			var node:SpriteElement = new SpriteElement();
			//node.id = String(id);
			node.name = String(id);
			//node.type = String(type);
			node.alpha = 1.0;
	        return node;    
		}
		
		
		/* override public function nodeTypeCompare(node:SpriteOL, type:String):Boolean {
			return (type == node.type);
		} */
		
		override public function eraseGeometry(geometry:Geometry):void {
			
			if ((getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPoint") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiLineString") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPolygon")) {
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
		
		/**
	 * This function erases simple features which are not  collections like  
	 * Point LineString or Polygon
	 */
	/*	private function eraseFeature(geometry:Geometry):void{
			if(geometry) {	            	
	            	
	            }
		}*/
	
		override public function clearNode(node:SpriteElement):void {
			node.graphics.clear();
		}
		
		// Elements functions
		
		override public function clear():void {
	    	if (this.container) {
	            while (this.container.numChildren > 0) {
	            	this.container.removeChildAt(this.container.numChildren-1);
	            }
	        }
	    }
	    
	    override public function drawGeometry(geometry:Geometry, style:Style, feature:VectorFeature):SpriteElement {
		    if ((getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPoint") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiLineString") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPolygon")) {
	            for (var i:int = 0; i < (geometry as Collection).components.length; i++) {
	                this.drawGeometry((geometry as Collection).components[i], style, feature);
	            }
	            return null;
	        };
	
	        //first we create the basic node and add it to the root
	        var nodeType:String = this.getNodeType(geometry);
	        var node:SpriteElement = this.nodeFactory(geometry.id, nodeType, geometry);
	        node.feature = feature;
	        node.geometryClass = getQualifiedClassName(geometry);
	        node.style = style;
	        this.container.addChild(node);

	        this.drawGeometryNode(node, geometry);
	        
	        return node;
	    }
	    
	    override public function redrawGeometry(node:SpriteElement, geometry:Geometry, style:Style, feature:VectorFeature):SpriteElement {
		    if ((getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPoint") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiLineString") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPolygon")) {
	            for (var i:int = 0; i < (geometry as Collection).components.length; i++) {
	                this.redrawGeometry(node, (geometry as Collection).components[i], style, feature);
	            }
	            return null;
	        };

	        this.drawGeometryNode(node, geometry, style);
	        
	        return node;
	    }
	    
	    override public function moveGeometry(geometry:Geometry):void {
	    	var node:SpriteElement = this.container.getChildAt(this.container.numChildren - 1) as SpriteElement;
	    	this.moveGeometryNode(node, geometry);
	    }
	    
	    public function moveGeometryNode(node:SpriteElement, geometry:Geometry):void {
	    	node.graphics.clear();
	    	this.drawGeometryNode(node, geometry);
	    }
    
    	public function drawGeometryNode(node:SpriteElement, geometry:Geometry, style:Style = null):void {
    		style = style || node.style;

	        var options:Object = {
	            'isFilled': true,
	            'isStroked': true
	        };
	        
	        if (getQualifiedClassName(geometry) == "org.openscales.core.geometry::LineString") {
	        	options.isFilled = false;
	        }
	        
	        this.setStyle(node, style, options);

	        switch (getQualifiedClassName(geometry)) {
	            case "org.openscales.core.geometry::Point":
	                this.drawPoint(node, geometry as Point);
	                break;
	            case "org.openscales.core.geometry::LineString":
	                this.drawLineString(node, geometry as LineString);
	                break;
	            case "org.openscales.core.geometry::LinearRing":
	                this.drawLinearRing(node, geometry as LinearRing);
	                break;
	            case "org.openscales.core.geometry::Polygon":
	                this.drawPolygon(node, geometry as Polygon);
	                break;
	            case "org.openscales.core.geometry::Surface":
	                this.drawSurface(node, geometry as Surface);
	                break;
	            case "org.openscales.core.geometry::Rectangle":
	                this.drawRectangle(node, geometry as Rectangle);
	                break;
	            default:
	                break;
	        }
	        
	        this.removeStyle(node, style, options);
	
	        node.style = style; 
	        node.options = options; 
    	}
		
    	override public function getFeatureFromEvent(evt:MouseEvent):VectorFeature {
	        var node:Object = evt.currentTarget;
	        return node._feature;
    	}
    		    
	    public function nodeFactory(id:String, type:String, geometry:Geometry):SpriteElement {
	    	var node:SpriteElement = this.container.getChildByName(id) as SpriteElement;
	        if (node) {
	            if (!this.nodeTypeCompare(node, type)) {
	                node.parent.removeChild(node);
	                node = this.nodeFactory(id, type, geometry);
	            }
	        } else {
	            node = this.createNode(type, id);
	        }
	        return node;
	    }

		public function nodeTypeCompare(node:SpriteElement, type:String):Boolean {
			return false;
		}
				
		
	}
}