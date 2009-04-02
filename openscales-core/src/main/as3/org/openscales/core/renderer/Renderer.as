package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.geometry.Collection;
	
	/**
	 * This is the base class for all renderers.
	 * 
	 * It is largely composed of virtual functions that are to be implemented 
	 * in technology-specific subclasses, but there is some generic code too.
	 * 
	 * The functions that are implemented here merely deal with the maintenance of the 
	 * size and extent variables, as well as the cached ‘resolution’ value.
	 * A note to the user that all subclasses should use getResolution() instead of 
	 * directly accessing this.resolution in order to correctly use the cacheing system.
	 * 
	 */
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
		
		public function drawFeature(feature:Vector, style:Style):void {
			if(style == null) {
	            style = feature.style;
	        }
	        if(feature && feature.geometry) {
	        	var node:Object = this.drawGeometry(feature.geometry, style, feature.id);
	        }
		}
		
		/* public function redrawFeature(feature:Vector, style:Object):void {
			if(style == null) {
	            style = feature.style;
	        }
	        this.clearNode(feature.node);
	        this.redrawGeometry(feature.node, feature.geometry, style, feature.id);
		} */
		
		public function moveFeature(feature:Vector):void {
			this.moveGeometry(feature.geometry);
		}
		
		public function drawGeometry(geometry:Object, style:Style, featureId:String):Object {
			return null;
		}
		
		public function redrawGeometry(node:*, geometry:Object, style:Style, featureId:String):Object {
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
		
		public function eraseFeatures(feature:Object):void {

	        if(feature && feature.geometry) {
	            this.eraseGeometry(feature.geometry);
	        }
		}
		
		public function eraseGeometry(geometry:Collection):void {
			
		}
		
	}
}