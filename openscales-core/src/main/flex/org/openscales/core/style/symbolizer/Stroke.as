package org.openscales.core.style.symbolizer
{
	import flash.display.JointStyle;
	
	public class Stroke
	{
		/**
		 * Possible values for the linejoin of the stroke, i.e. how two segments of a line are connected
		 */
		public static const LINEJOIN_MITER:String = "miter";
		public static const LINEJOIN_ROUND:String = "round";
		public static const LINEJOIN_BEVEL:String = "bevel";
		
		/**
		 * Possible values for the linecap of the stroke, i.e. how the ends of the line are displayed
		 */
		public static const LINECAP_BUTT:String = "butt";
		public static const LINECAP_ROUND:String = "round";
		public static const LINECAP_SQUARE:String = "square";
		
		private var _color:uint = 0;
		
		private var _width:Number = 1;
		
		private var _opacity:Number = 1;
		
		private var _linecap:String;
		
		private var _linejoin:String;
		
		public function Stroke(color:uint = 0x000000, width:Number = 1, opacity:Number = 1, linecap:String = LINECAP_ROUND, linejoin:String = LINEJOIN_ROUND)
		{
			this._color = color;
			this._width = width;
			this._opacity = opacity;
			this._linecap = linecap;
			this._linejoin = linejoin;
		}
		
		/**
		 * The color of the stroke
		 */
		public function get color():uint{
			
			return this._color;
		}
		
		public function set color(value:uint):void{
			
			this._color = value;
		}
		
		/**
		 * The width of the stroke
		 */
		public function get width():Number{
		
			return this._width;	
		}
		
		public function set width(value:Number):void{
			
			this._width = value;
		}
		
		/**
		 * The height of the stroke
		 */
		public function get opacity():Number{
			
			return this._opacity;
		}
		
		public function set opacity(value:Number):void{
			
			this._opacity = value;
		}
		
		public function get linecap():String{
			
			return this._linecap;
		}
		
		public function set linecap(value:String):void{
			
			this._linecap = value;
		}
		
		public function get linejoin():String{
			
			return this._linejoin;
		}
		
		public function set linejoin(value:String):void{
			
			this._linejoin = value;
		}
	}
}