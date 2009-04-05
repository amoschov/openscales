package org.openscales.core.control
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.commons.Util;
	import org.openscales.commons.basetypes.Pixel;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.Vector;
	
	/**
	 * Controls affect the display or behavior of the map.
	 * They allow everything from panning and zooming to displaying a scale indicator.
	 */
	public class Control extends Sprite
	{
		
		public static var TYPE_BUTTON:int = 1;
		public static var TYPE_TOGGLE:int = 2;
		public static var TYPE_TOOL:int = 3;
		public static var TYPES:Array = new Array(TYPE_BUTTON, TYPE_TOGGLE, TYPE_TOOL);
		
		public var id:String = null;
		public var map:Map = null;
		public var type:Array = null;
		public var displayClass:String = "";
		public var active:Boolean = false;
		public var handler:Handler = null;
		public var layer:Vector = null;
		public var layerZPos:int;
		public var keyMask:int;
		/* private var _size:Size = null; */
		
		public function Control(options:Object = null):void {
			
			this.displayClass = getQualifiedClassName(this).split('::')[1];
					
			if (options != null && options.position != null) {
		    	this.position = (options.position as Pixel);
		    } else {
		    	this.position = new Pixel(0,0);
		    }

			this.name = this.displayClass;
			
			Util.extend(this, options);
			
			this.id = Util.createUniqueID(getQualifiedClassName(this) + "_");
			
		}
		
		public function destroy():void {  
	        this.map = null;
		}
		
		public function setMap(map:Map):void {
			this.map = map;
	        if (this.handler) {
	            this.handler.setMap(map);
	        }
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
		
		public function activate():Boolean {
			if (this.active) {
	            return false;
	        }
	        if (this.handler) {
	        	this.handler.activate();
	        }
	        this.active = true;
	        return true;
		}
		
		public function deactivate():Boolean {
	        if (this.active) {
	            if (this.handler) {
	                this.handler.deactivate();
	            }
	            this.active = false;
	            return true;
	        }
	        return false;
		}
		
		/* public function get size():Size
		{
			var size:Size = null;
	        if (_size != null) {
	            size = _size.clone();
	        }
	        return size;
		}
		
		public function set size(newSize:Size):void
		{
			_size= newSize;
			
			this.draw();
		} */
				
	}
}