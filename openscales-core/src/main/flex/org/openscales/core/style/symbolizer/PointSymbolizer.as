package org.openscales.core.style.symbolizer
{
	public class PointSymbolizer extends Symbolizer
	{
		private var _graphic:Graphic;
		
		public function PointSymbolizer(graphic:Graphic = null)
		{
			this._graphic = graphic;
		}
		
		public function get graphic():Graphic{
			
			return this._graphic;
		}
		
		public function set graphic(value:Graphic):void{
			
			this._graphic = value;
		}

	}
}