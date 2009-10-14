package org.openscales.core.style.symbolizer
{
	public class Fill
	{
		private var _color:uint;
		
		private var _opacity:Number;
		
		public function Fill(color:uint = 0xffffff, opacity:Number = 1)
		{
			this.color = color;
			this.opacity = opacity;
		}
		
		/**
		 * The color of the fill
		 */
		public function get color():uint{
			
			return this._color;
		}
		
		public function set color(value:uint):void{
			
			this._color = value;
		}
		
		/**
		 * The opacity of the fill
		 */
		public function get opacity():Number{
			
			return this._opacity;
		}
		
		public function set opacity(value:Number):void{
			
			this._opacity = value;
		}

	}
}