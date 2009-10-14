package org.openscales.core.style.symbolizer
{
	public class Graphic
	{
		private var _opacity:Number = 1;
		
		private var _rotation:Number = 0;
		
		private var _size:Number = 6;
		
		public function Graphic()
		{
		}

		public function get opacity():Number{
			
			return this._opacity;
		}
		
		public function set opacity(value:Number):void{
			
			this._opacity = value;
		}
		
		public function get rotation():Number{
			
			return this._rotation;
		}
		
		public function set rotation(value:Number):void{
			
			this._rotation = value;
		}
		
		public function get size():Number{
			
			return this._size;
		}
		
		public function set size(value:Number):void{
			
			this._size = value;
		}
	}
}