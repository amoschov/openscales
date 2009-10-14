package org.openscales.core.style.symbolizer
{
	public class LineSymbolizer extends Symbolizer implements StrokeSymbolizer
	{
		private var _stroke:Stroke;
		
		public function LineSymbolizer(stroke:Stroke = null)
		{
			this._stroke = stroke;
		}
		
		public function get stroke():Stroke{
			
			return this._stroke;
		}
		
		public function set stroke(value:Stroke):void{
			
			this._stroke = value;
		}
	}
}