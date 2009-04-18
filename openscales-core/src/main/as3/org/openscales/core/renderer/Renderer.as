package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
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
		
		private var _container:Sprite = null;
		
	    private var _extent:Bounds = null;
	    
	    private var _size:Size = null;
	    
	    private var _resolution:Number;

	    private var _map:Map = null;
	    
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
		
		public function drawFeature(feature:Vector, style:Style):void {
			if(style == null) {
	            style = feature.style;
	        }
	        if(feature && feature.geometry) {
	        	var node:Object = this.drawGeometry(feature.geometry, style, feature.id);
	        }
		}
		
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
		
		/*public function eraseFeatures(feature:Array):void {

	        if(feature && feature.geometry) {
	            this.eraseGeometry(feature.geometry);
	        }
		}*/
		
		public function eraseGeometry(geometry:Collection):void {
			
		}
		
		public function get container():Sprite {
			return this._container;
		}
		
		public function set container(value:Sprite):void {
			this._container = value;
		}
		
		public function get extent():Bounds {
			return this._extent;
		}
		
		public function set extent(value:Bounds):void {
			this._extent = value.clone();
			this.resolution = NaN;
		}
		
		public function get size():Size {
			return this._size;
		}
		
		public function set size(value:Size):void {
			this._size = value.clone();
			this.resolution = NaN;
		}
		
		public function get resolution():Number {
			this._resolution = this.resolution || this.map.resolution;
        	return this._resolution;
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