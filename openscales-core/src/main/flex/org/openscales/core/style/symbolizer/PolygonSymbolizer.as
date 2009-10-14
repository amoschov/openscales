package org.openscales.core.style.symbolizer
{
	public class PolygonSymbolizer extends Symbolizer implements FillSymbolizer, StrokeSymbolizer
	{
		private var _stroke:Stroke;
		
		private var _fill:Fill;
		
		public function PolygonSymbolizer(fill:Fill = null, stroke:Stroke = null)
		{
			this._fill = fill;
			this._stroke = stroke;
		}
		
		/**
		 * Defines how the polygon line are rendered 
		 */
		public function get stroke():Stroke{
			
			return this._stroke;
		}
		
		public function set stroke(value:Stroke):void{
			
			this._stroke = value;
		}
		
		/**
		 * Describes how the polygon fill is rendered
		 */
		public function get fill():Fill{
			
			return this._fill;
		}
		
		public function set fill(value:Fill):void{
			
			this._fill = value;
		}
	}
}