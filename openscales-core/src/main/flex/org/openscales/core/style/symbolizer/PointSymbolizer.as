package org.openscales.core.style.symbolizer
{
	import org.openscales.core.style.marker.Marker;
	
	public class PointSymbolizer extends Symbolizer
	{
		private var _graphic:Marker;
		
		public function PointSymbolizer(graphic:Marker = null)
		{
			this._graphic = graphic;
		}
		
		public function get graphic():Marker{
			
			return this._graphic;
		}
		
		public function set graphic(value:Marker):void{
			
			this._graphic = value;
		}

	}
}