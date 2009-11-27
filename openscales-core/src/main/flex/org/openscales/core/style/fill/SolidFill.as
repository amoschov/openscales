package org.openscales.core.style.fill
{
	import flash.display.Graphics;
	
	/**
	 * Class defining a solid fill, which is characterized by its color and opacity 
	 */
	public class SolidFill extends Fill
	{
		private var _color:uint;
		
		private var _opacity:Number;
		
		public function SolidFill(color:uint = 0xffffff, opacity:Number = 1)
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
		
		override public function configureGraphics(graphics:Graphics):void{
			
			graphics.beginFill(this._color,this._opacity);
		}

	}
}