package org.openscales.core.control
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Pixel;
	
	/**
	 * Controls affect the display or behavior of the map.
	 * They allow everything from panning and zooming to displaying a scale indicator.
	 */
	public class Control extends Sprite implements IControl
	{
		
		public var _map:Map = null;
		public var _active:Boolean = false;
		
		public function Control(options:Object = null):void {
								
			if (options != null && options.position != null) {
		    	this.position = (options.position as Pixel);
		    } else {
		    	this.position = new Pixel(0,0);
		    }

			this.name = getQualifiedClassName(this).split('::')[1];
			
			Util.extend(this, options);
		}
		
		public function destroy():void {  
	        this.map = null;
		}
		
		public function get map():Map {
			return this._map;   
		}
		
		public function set map(value:Map):void {
			this._map = value;   
		}
		
		public function get active():Boolean {
			return this._active;   
		}
		
		public function set active(value:Boolean):void {
			this._active = value;   
		}
		
		public function draw():void {
	        // Reset before drawing
	        this.graphics.clear();
	        while (this.numChildren > 0) {
	    		var child:DisplayObject = removeChildAt(0);
	        }
		}
		
		public function set position(px:Pixel):void {
			if (px != null) {
	            this.x = px.x;
	            this.y = px.y;
	        }
		}
		
		public function get position():Pixel {
			return new Pixel(this.x, this.y);
		}
				
	}
}