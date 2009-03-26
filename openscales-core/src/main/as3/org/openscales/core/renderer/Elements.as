package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.control.Control;
	import org.openscales.core.control.SelectFeature;
	import org.openscales.core.event.OpenScalesEvent;
	import org.openscales.core.geometry.Collection;
	
	public class Elements extends Renderer
	{

	    
	    public function Elements(container:Sprite):void {
	    	super(container);
	        
	    }
	    
	    override public function destroy():void {
	        this.clear(); 
	
	        super.destroy();
	    }
	    
	    override public function clear():void {
	    	if (this.container) {
	            while (this.container.numChildren > 0) {
	            	this.container.removeChildAt(this.container.numChildren-1);
	            }
	        }
	    }
	    
	    public function getNodeType(geometry:Object):String {
	    	return null;
	    }
	    
	    override public function drawGeometry(geometry:Object, style:Object, featureId:String):Object {
		    if ((getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPoint") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiLineString") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPolygon")) {
	            for (i = 0; i < geometry.components.length; i++) {
	                this.drawGeometry(geometry.components[i], style, featureId);
	            }
	            return null;
	        };
	
	        //first we create the basic node and add it to the root
	        var nodeType:String = this.getNodeType(geometry);
	        var node:SpriteElement = this.nodeFactory(geometry.id, nodeType, geometry);
	        node.featureId = featureId;
	        node.geometryClass = getQualifiedClassName(geometry);
	        node.style = style;
	        this.container.addChild(node);

	        this.drawGeometryNode(node, geometry);
	        
	        for (var i:int=0; i < this.map.controls.length; i++) {
	        	var control:Control = this.map.controls[i];
	        	if (control is SelectFeature) {
	        		if (control.active) {
	        			for (var func:String in control.handler.callbacks) {
	        				var callback:Function = control.handler.callbacks[func];
	        				new OpenScalesEvent().observe(node, MouseEvent.CLICK, callback); 
	        			}
	        		}
	        	}
	        }
	        
	        return node;
	    }
	    
	    override public function redrawGeometry(node:*, geometry:Object, style:Object, featureId:String):Object {
		    if ((getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPoint") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiLineString") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPolygon")) {
	            for (var i:int = 0; i < geometry.components.length; i++) {
	                this.redrawGeometry(node, geometry.components[i], style, featureId);
	            }
	            return null;
	        };

	        this.drawGeometryNode(node, geometry, style);
	        
	        return node;
	    }
	    
	    override public function moveGeometry(geometry:Object):void {
	    	var node:SpriteElement = this.container.getChildAt(this.container.numChildren - 1) as SpriteElement;
	    	this.moveGeometryNode(node, geometry);
	    }
	    
	    public function moveGeometryNode(node:SpriteElement, geometry:Object):void {
	    	node.graphics.clear();
	    	this.drawGeometryNode(node, geometry);
	    }
    
    	public function drawGeometryNode(node:SpriteElement, geometry:Object, style:Object = null):void {
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
	                this.drawPoint(node, geometry);
	                break;
	            case "org.openscales.core.geometry::LineString":
	                this.drawLineString(node, geometry);
	                break;
	            case "org.openscales.core.geometry::LinearRing":
	                this.drawLinearRing(node, geometry);
	                break;
	            case "org.openscales.core.geometry::Polygon":
	                this.drawPolygon(node, geometry);
	                break;
	            case "org.openscales.core.geometry::Surface":
	                this.drawSurface(node, geometry);
	                break;
	            case "org.openscales.core.geometry::Rectangle":
	                this.drawRectangle(node, geometry);
	                break;
	            default:
	                break;
	        }
	        
	        this.removeStyle(node, style, options);
	
	        node.style = style; 
	        node.options = options; 
    	}
    
		public function setStyle(node:SpriteElement, style:Object, options:Object):void {	
	        style = style  || node.style;
	        options = options || node.options;
	
	        if (node.geometryClass == "org.openscales.core.geometry::Point") {
	            node.attributes.r = style.pointRadius;
	        }
	        
	        if (options.isFilled) {
	            node.attributes.fill = style.fillColor;
	            node.attributes.fillOpacity = style.fillOpacity;
	        } else {
	            node.attributes.fill = "none";
	        }
	
	        if (options.isStroked) {
	            node.attributes.stroke = style.strokeColor;
	            node.attributes.strokeOpacity = style.strokeOpacity;
	            node.attributes.strokeWidth = style.strokeWidth;
	            node.attributes.strokeLinecap = style.strokeLinecap;
	        } else {
	            node.attributes.stroke = "none";
	        }
	        
	        if (style.pointerEvents) {
	            node.attributes.pointerEvents = style.pointerEvents;
	        }
	        
	        if (style.cursor) {
	            node.attributes.cursor = style.cursor;
	        }
		}
		
		public function removeStyle(node:SpriteElement, style:Object, options:Object):void {};
		
        public function drawPoint(node:SpriteElement, geometry:Object):void {};
        public function drawLineString(node:SpriteElement, geometry:Object):void {};
        public function drawLinearRing(node:SpriteElement, geometry:Object):void {};
        public function drawPolygon(node:SpriteElement, geometry:Object):void {};
        public function drawRectangle(node:SpriteElement, geometry:Object):void {};
        public function drawCircle(node:SpriteElement, geometry:Object, radius:Number):void {};
        public function drawCurve(node:SpriteElement, geometry:Object):void {};
        public function drawSurface(node:SpriteElement, geometry:Object):void {};
    
    	override public function getFeatureIdFromEvent(evt:MouseEvent):String {
	        var node:Object = evt.currentTarget;
	        return node._featureId;
    	}
    	
    	override public function eraseGeometry(geometry:Collection):void {
    		if ((getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPoint") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiLineString") ||
	            (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPolygon")) {
	            for (var i:int = 0; i < geometry.components.length; i++) {
	                this.eraseGeometry(geometry.components[i]);
	            }
	        } else {    
	            var element:Object = geometry.id;
	            if (element && element.parent) {
	                if (element.geometry) {
	                    element.geometry.destroy();
	                    element.geometry = null;
	                }
	                element.parent.removeChild(element);
	            }
	        }
	    }
	    
	    public function nodeFactory(id:String, type:String, geometry:Object):SpriteElement {
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
		
		public function createNode(type:Object, id:Object):SpriteElement { 
			return null;
		}
	    
		
		public function createRoot():Sprite {
			return null;
		}
    
	}
}