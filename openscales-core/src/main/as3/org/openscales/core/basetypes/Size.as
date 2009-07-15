package org.openscales.core.basetypes
{
	/**
	 * Instances of this class represent a width/height pair.
	 */
	public class Size
	{
		private var _w:Number = 0.0;
		private var _h:Number = 0.0;
		
		public function Size(w:Number = NaN, h:Number = NaN) {
			this.w = w;
			this.h = h;
		}
		
		public function toString():String {
			return "w=" + this.w + ",h=" + this.h;
		}
		
		public function clone():Size {
			return new Size(this.w, this.h);
		}
		
		public function equals(sz:Size):Boolean {
			var equals:Boolean = false;
			if (sz != null) {
				equals = this.w == sz.w && this.h == sz.h;
			}
			return equals;
		}
		
		// Getters & setters
		
		public function get w():Number
		{
			return _w;
		}
		public function set w(newW:Number):void
		{
			_w = newW;
		}
		
		public function get h():Number
		{
			return _h;
		}
		public function set h(newH:Number):void
		{
			_h = newH;
		}
	}
}