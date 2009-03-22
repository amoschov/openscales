package org.openscales.core.basetypes
{
	public class Pixel
	{
		
		private var _x:Number = 0.0;
		private var _y:Number = 0.0;
		
		public function Pixel(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		public function toString():String {
			return "x=" + this.x + ",y=" + this.y;
		}
		
		public function clone():Pixel {
			return new Pixel(this.x, this.y);
		}
		
		public function equals(px:Pixel):Boolean {
			var equals:Boolean = false;
			if (px != null) {
				equals = this.x == px.x && this.y == px.y;
			}
			return equals;
		}
		
		public function add(x:Number, y:Number):Pixel {
			return  new Pixel(this.x + x, this.y + y);
		}
		
		public function offset(px:Pixel):Pixel {
			var newPx:Pixel = this.clone();
			if (px) {
				newPx = this.add(px.x, px.y);
			}
			return newPx;
		}
		
		// Getters & setters
		
		public function get x():Number
		{
			return _x;
		}
		public function set x(newX:Number):void
		{
			_x = newX;
		}
		
		public function get y():Number
		{
			return _y;
		}
		public function set y(newY:Number):void
		{
			_y = newY;
		}
	}
}