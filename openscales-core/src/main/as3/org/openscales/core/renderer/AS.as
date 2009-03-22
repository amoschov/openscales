package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.SpriteOL;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.geometry.LinearRing;
	
	public class AS extends Elements
	{
		
		public var localResolution:Number = 99999;
		public var left:Number;
		public var right:Number;
		public var top:Number;
		public var bottom:Number;
		public var maxPixel:Number;
		
		public function AS(container:Sprite):void {
			super(container);
		}
		
		override public function destroy():void {
			super.destroy();
		}
		
		override public function setExtent(extent:Bounds):void {
			super.setExtent(extent);
	        
	        var resolution:Number = this.getResolution();

	        if (!this.localResolution || resolution != this.localResolution) {
	            this.left = -extent.left / resolution;
	            this.top = extent.top / resolution;
	        }
	
	        
	        var left:Number = 0;
	        var top:Number = 0;
	
	        // If the resolution has not changed, we already have features, and we need
	        // to adjust the viewbox to fit them.
	        if (this.localResolution && resolution == this.localResolution) {
	            left = (this.left) - (-extent.left / resolution);
	            top  = (this.top) - (extent.top / resolution);
	        }    
	        
	        // Store resolution for use later.
	        this.localResolution = resolution;
	        
	        // Set the viewbox -- the left/top will be pixels-dragged-since-res change,
	        // the width/height will be pixels.
	        var extentString:String = left + " " + top + " " + 
	                             extent.getWidth() / resolution + " " + extent.getHeight() / resolution;
	        //var extentString = extent.left / resolution + " " + -extent.top / resolution + " " + 
/* 	        this.rendererRoot.viewBox = extentString; */
		}
		
		override public function setSize(size:Size):void {
			super.setSize(size);
	        
	      	this.rendererRoot.graphics.beginFill(0xFFFFFF);
			this.rendererRoot.graphics.drawRect(0,0,this.size.w,this.size.h);
			this.rendererRoot.graphics.endFill()
	        this.rendererRoot.width = this.size.w;
	        this.rendererRoot.height = this.size.h;
		}
		
		override public function getNodeType(geometry:Object):String {
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
		
		override public function setStyle(node:SpriteOL, style:Object, options:Object):void {	
	        style = style  || node._style;
	        options = options || node._options;
	
	        if (node._geometryClass == "org.openscales.core.geometry::Point") {
	            node.attributes.r = style.pointRadius;
	        }
	        
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
	        
	        if (style.pointerEvents) {
	            node.attributes.pointerEvents = style.pointerEvents;
	        }
	        
	        if (style.cursor) {
	            node.attributes.cursor = style.cursor;
	        }
		}
		
		override public function removeStyle(node:SpriteOL, style:Object, options:Object):void {
	        style = style  || node._style;
	        options = options || node._options;
	        
	        if (options.isFilled) {
	            node.graphics.beginFill(style.fillColor, style.fillOpacity);
	        }
	        
		}
		
		override public function drawPoint(node:SpriteOL, geometry:Object):void {
			this.drawCircle(node, geometry, node.attributes.r);
		}
		
		override public function drawCircle(node:SpriteOL, geometry:Object, radius:Number):void {
			var resolution:Number = this.getResolution();
	        var x:Number = (geometry.x / resolution + this.left);
	        var y:Number = (this.top - geometry.y / resolution);
	        var draw:Boolean = true;
	        if (x < -this.maxPixel || x > this.maxPixel) { draw = false; }
	        if (y < -this.maxPixel || y > this.maxPixel) { draw = false; }
	
	        if (draw) { 
	            node.graphics.drawCircle(x, y, radius);
	        } else {
	            this.root.removeChild(node);
	        } 
		}
		
		override public function drawLineString(node:SpriteOL, geometry:Object):void {
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
		
		override public function drawPolygon(node:SpriteOL, geometry:Object):void {
	        var draw:Boolean = true;
	        for (var j:int = 0; j < geometry.components.length; j++) {
	            var linearRing:LinearRing = geometry.components[j];
	            for (var i:int = 0; i < linearRing.components.length; i++) {
	                var component:String = this.getShortString(linearRing.components[i])
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
		
		override public function drawRectangle(node:SpriteOL, geometry:Object):void {
	        var x:Number = (geometry.x / resolution + this.left);
	        var y:Number = (geometry.y / resolution - this.top);
	        var draw:Boolean = true;
	        if (x < -this.maxPixel || x > this.maxPixel) { draw = false; }
	        if (y < -this.maxPixel || y > this.maxPixel) { draw = false; }
	        if (draw) {
	            node.graphics.drawRect(x, y, geometry.width, geometry.height);
	        } else {
	            node.graphics.drawRect(0, 0, 0, 0);
	        }
		}
		
		override public function drawCurve(node:SpriteOL, geometry:Object):void {
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
	        if (draw) {
	            node.attributes.d = d;
	        } else {
	            node.attributes.d = "";
	        }    
		}
		
		public function getComponentsString(components:Object):String {
			var strings:Array = [];
	        for(var i:int = 0; i < components.length; i++) {
	            var component:String = this.getShortString(components[i]);
	            if (component) {
	                strings.push(component);
	            }
	        }
	        return strings.join(",");
		}
		
		public function getShortString(point:Object):String {
	        var resolution:Number = this.getResolution();
	        var x:Number = (point.x / resolution + this.left);
	        var y:Number = (this.top - point.y / resolution);
	        if (x < -this.maxPixel || x > this.maxPixel) { return null; }
	        if (y < -this.maxPixel || y > this.maxPixel) { return null; }
	        var string:String =  x + "," + y;  
	        return string;
		}
		
		override public function supported():Boolean {
			return true;
		}
		
		override public function createNode(type:Object, id:Object):SpriteOL {
			var node:SpriteOL = new SpriteOL();
			node.id = String(id);
			node.name = String(id);
			node.type = String(type);
			node.alpha = 1.0;
	        return node;    
		}
		
		override public function createRendererRoot():Sprite {
	        var rendererRoot:Sprite = new Sprite();
			
			// Create a rect because empty Sprite can't have its width or height modified 
			rendererRoot.graphics.beginFill(0xFFFFFF);
			rendererRoot.graphics.drawRect(0,0,1,1);
			rendererRoot.graphics.endFill()
	        
	        return rendererRoot; 
		}
		
		override public function createRoot():Sprite {
		    var root:Sprite = new Sprite();
	        
	        // Create a rect because empty Sprite can't have its width or height modified
			root.graphics.beginFill(0xFFFFFF);
			root.graphics.drawRect(0,0,1,1);
			root.graphics.endFill()
	      
	        return root;
		}
		
		override public function nodeTypeCompare(node:SpriteOL, type:String):Boolean {
			return (type == node.type);
		}
		
		override public function eraseGeometry(geometry:Object):void {
			if ((getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPoint") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiLineString") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPolygon")) {
	            for (var i:int = 0; i < geometry.components.length; i++) {
	                this.eraseGeometry(geometry.components[i]);
	            }
	        } else {    
	            var element:Object = this.root.getChildByName(geometry.id);
	            if (element && element.parent) {
	                if (element.geometry) {
	                    element.geometry.destroy();
	                    element.geometry = null;
	                }
	                element.parent.removeChild(element);
	            }
	        }
		}
		
		override public function clearNode(node:Object):void {
			node.graphics.clear();
		}
	}
}