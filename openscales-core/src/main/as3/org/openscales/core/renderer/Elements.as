package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Control;
	import org.openscales.core.event.OpenScalesEvent;
	import org.openscales.core.Renderer;
	import org.openscales.core.SpriteOL;
	import org.openscales.core.control.SelectFeature;
	
	public class Elements extends Renderer
	{
		
		public var rendererRoot:Sprite = null;

	    public var root:Sprite = null;

	    public var xmlns:String = null;
	    
	    public function Elements(container:Sprite):void {
	    	super(container);

	        this.rendererRoot = this.createRendererRoot();
	        this.root = this.createRoot();
	        
	        this.rendererRoot.addChild(this.root);
	        this.container.addChild(this.rendererRoot);
	        
	    }
	    
	    override public function destroy():void {
	        this.clear(); 
	
	        this.rendererRoot = null;
	        this.root = null;
	        this.xmlns = null;
	
	        super.destroy();
	    }
	    
	    override public function clear():void {
	    	if (this.root) {
	            while (this.root.numChildren > 0) {
	            	this.root.removeChildAt(this.root.numChildren-1);
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
	        var node:SpriteOL = this.nodeFactory(geometry.id, nodeType, geometry);
	        node._featureId = featureId;
	        node._geometryClass = getQualifiedClassName(geometry);
	        node._style = style;
	        this.root.addChild(node);

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
	    	var node:SpriteOL = this.root.getChildAt(this.root.numChildren - 1) as SpriteOL;
	    	this.moveGeometryNode(node, geometry);
	    }
	    
	    public function moveGeometryNode(node:SpriteOL, geometry:Object):void {
	    	node.graphics.clear();
	    	this.drawGeometryNode(node, geometry);
	    }
    
    	public function drawGeometryNode(node:SpriteOL, geometry:Object, style:Object = null):void {
    		style = style || node._style;

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
	
	        node._style = style; 
	        node._options = options; 
    	}
    
		public function setStyle(node:SpriteOL, style:Object, options:Object):void {	
	        style = style  || node._style;
	        options = options || node._options;
	
	        if (node._geometryClass == "org.openscales.core.geometry::Point") {
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
		
		public function removeStyle(node:SpriteOL, style:Object, options:Object):void {};
		
        public function drawPoint(node:SpriteOL, geometry:Object):void {};
        public function drawLineString(node:SpriteOL, geometry:Object):void {};
        public function drawLinearRing(node:SpriteOL, geometry:Object):void {};
        public function drawPolygon(node:SpriteOL, geometry:Object):void {};
        public function drawRectangle(node:SpriteOL, geometry:Object):void {};
        public function drawCircle(node:SpriteOL, geometry:Object, radius:Number):void {};
        public function drawCurve(node:SpriteOL, geometry:Object):void {};
        public function drawSurface(node:SpriteOL, geometry:Object):void {};
    
    	override public function getFeatureIdFromEvent(evt:MouseEvent):String {
	        var node:Object = evt.currentTarget;
	        return node._featureId;
    	}
    	
    	override public function eraseGeometry(geometry:Object):void {
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
	    
	    public function nodeFactory(id:String, type:String, geometry:Object):SpriteOL {
	    	var node:SpriteOL = this.root.getChildByName(id) as SpriteOL;
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

		public function nodeTypeCompare(node:SpriteOL, type:String):Boolean {
			return false;
		}
		
		public function createNode(type:Object, id:Object):SpriteOL { 
			return null;
		}
	    
	    public function createRendererRoot():Sprite {	
			return null; 
		}
		
		public function createRoot():Sprite {
			return null;
		}
    
	}
}