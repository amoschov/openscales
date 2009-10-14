package org.openscales.core.style.symbolizer
{
	public class Mark extends Graphic
	{
		public static const WKN_SQUARE:String = "square";
		
		public static const WKN_CIRCLE:String = "circle";
		
		public static const WKN_TRIANGLE:String = "triangle";
		
		public static const WKN_STAR:String = "star";
		
		public static const WKN_CROSS:String = "cross";
		
		public static const WKN_X:String = "x";
		
		private var _wkn:String;
		
		private var _fill:Fill;
		
		private var _stroke:Stroke;
		
		public function Mark(wellKnownName:String = WKN_SQUARE, fill:Fill = null, stroke:Stroke = null, size:Number = 6, opacity:Number = 1, rotation:Number = 0)
		{
			this._wkn = wellKnownName;
			this._fill = fill ? fill : new Fill(0x888888);
			this._stroke = stroke ? stroke : new Stroke(0x000000);
			this.opacity = opacity;
			this.rotation = rotation;
			this.size = size;
		}
		
		public function get fill():Fill{
			
			return this._fill;
		}
		
		public function set fill(value:Fill):void{
			
			this._fill = value;
		}
		
		
		public function get stroke():Stroke{
			
			return this._stroke;
		}
		
		public function set stroke(value:Stroke):void{
			
			this._stroke = value;
		}
		
		public function get wellKnownName():String{
			
			return this._wkn;
		}
		
		public function set wellKnownName(value:String):void{
			
			this._wkn = value;
		}

	}
}