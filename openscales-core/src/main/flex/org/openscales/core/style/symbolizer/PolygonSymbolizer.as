package org.openscales.core.style.symbolizer
{
	import flash.display.Graphics;
	
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.stroke.Stroke;
	
	public class PolygonSymbolizer extends Symbolizer implements IFillSymbolizer, IStrokeSymbolizer
	{
		private var _stroke:Stroke;
		
		private var _fill:SolidFill;
		
		public function PolygonSymbolizer(fill:SolidFill = null, stroke:Stroke = null)
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
		public function get fill():SolidFill{
			
			return this._fill;
		}
		
		public function set fill(value:SolidFill):void{
			
			this._fill = value;
		}
		
		override public function configureGraphics(graphics:Graphics):void{
			
			if(this._fill){
				
				this._fill.configureGraphics(graphics);
			}
			else{
				
				graphics.endFill();
			}
			
			if(this._stroke){
				
				this._stroke.configureGraphics(graphics);
			}
			else{
				
				graphics.lineStyle();
			}
			
			
		}
	}
}