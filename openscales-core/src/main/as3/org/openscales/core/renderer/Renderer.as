package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.feature.Vector;
	
	public class Renderer
	{
		
		public var container:Sprite = null;
		
	    public var extent:Bounds = null;
	    
	    public var size:Size = null;
	    
	    public var resolution:Number;

	    public var map:Object = null;
	    
	    public function Renderer(container:Sprite):void {
	    	this.container = container;
	    }
	    
	    public function destroy():void {
	    	this.container = null;
	        this.extent = null;
	        this.size =  null;
	        this.resolution = NaN;
	        this.map = null;
	    }
	    
	    public function supported():Boolean {
	    	return false;
	    }
	    
	    public function setExtent(extent:Bounds):void {
	    	this.extent = extent.clone();
        	this.resolution = NaN;
	    }
	    
	    public function setSize(size:Size):void {
        	this.size = size.clone();
        	this.resolution = NaN;
	    }
		
		public function getResolution():Number {
			this.resolution = this.resolution || this.map.resolution;
        	return this.resolution;
		}
		
		public function drawFeature(feature:Vector, style:Object):void {
			if(style == null) {
	            style = feature.style;
	        }
	        var node:Object = this.drawGeometry(feature.geometry, style, feature.id);
		}
		
		public function redrawFeature(feature:Vector, style:Object):void {
			if(style == null) {
	            style = feature.style;
	        }
	        this.clearNode(feature.node);
	        this.redrawGeometry(feature.node, feature.geometry, style, feature.id);
		}
		
		public function moveFeature(feature:Vector):void {
			this.moveGeometry(feature.geometry);
		}
		
		public function drawGeometry(geometry:Object, style:Object, featureId:String):Object {
			return null;
		}
		
		public function redrawGeometry(node:*, geometry:Object, style:Object, featureId:String):Object {
			return null;
		}
		
		public function moveGeometry(geometry:Object):void {
		}
		
		public function clearNode(node:Object):void {
			
		}
		
		public function clear():void {
			
		}
		
		public function getFeatureIdFromEvent(evt:MouseEvent):String {
			return null;
		}
		
		public function eraseFeatures(features:Object):void {
			if(!(features is Array)) {
	            features = [features];
	        }
	        for(var i:int=0; i<features.length; ++i) {
	            this.eraseGeometry(features[i].geometry);
	        }
		}
		
		public function eraseGeometry(geometry:Object):void {
			
		}
		
	}
}