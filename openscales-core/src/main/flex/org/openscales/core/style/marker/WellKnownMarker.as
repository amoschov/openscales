package org.openscales.core.style.marker {
	import flash.display.DisplayObject;
	import flash.display.Shape;

	import org.openscales.core.feature.Feature;
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.stroke.Stroke;

	public class WellKnownMarker extends Marker {
		public static const WKN_SQUARE:String = "square";

		public static const WKN_CIRCLE:String = "circle";

		public static const WKN_TRIANGLE:String = "triangle";

		public static const WKN_STAR:String = "star";

		public static const WKN_CROSS:String = "cross";

		public static const WKN_X:String = "x";

		private var _wkn:String;

		private var _fill:SolidFill;

		private var _stroke:Stroke;

		public function WellKnownMarker(wellKnownName:String=WKN_SQUARE, fill:SolidFill=null, stroke:Stroke=null, size:Object=6, opacity:Number=1, rotation:Number=0) {

			super(size, opacity, rotation);
			this._wkn = wellKnownName;
			this._fill = fill ? fill : new SolidFill(0x888888);
			this._stroke = stroke ? stroke : new Stroke(0x000000);
		}

		override public function getDisplayObject(feature:Feature):DisplayObject {

			var result:DisplayObject = this.generateGraphic(feature);

			result.alpha = this.opacity;
			result.rotation = this.rotation;

			return result;
		}

		override protected function generateGraphic(feature:Feature):DisplayObject {

			var shape:Shape = new Shape();

			var size:Number = this.getSizeValue(feature);

			// Configure fill and stroke for drawing
			if (this._fill) {

				this._fill.configureGraphics(shape.graphics, feature);
			}
			if (this._stroke) {

				this._stroke.configureGraphics(shape.graphics);
			}

			switch (this.wellKnownName) {

				case WellKnownMarker.WKN_SQUARE:  {
					shape.graphics.drawRect(-(size / 2), -(size / 2), size, size);
					break;
				}
				case WellKnownMarker.WKN_CIRCLE:  {
					shape.graphics.drawCircle(0, 0, size / 2);
					break;
				}
				case WellKnownMarker.WKN_TRIANGLE:  {
					shape.graphics.moveTo(0, -(size / 2));
					shape.graphics.lineTo(size / 2, size / 2);
					shape.graphics.lineTo(-size / 2, size / 2);
					shape.graphics.lineTo(0, -(size / 2));
					break;
				}
				// TODO : Add support for other well known names
			}

			return shape;
		}

		public function get fill():SolidFill {
			return this._fill;
		}

		public function set fill(value:SolidFill):void {
			this._fill = value;
		}


		public function get stroke():Stroke {
			return this._stroke;
		}

		public function set stroke(value:Stroke):void {
			this._stroke = value;
		}

		public function get wellKnownName():String {
			return this._wkn;
		}

		public function set wellKnownName(value:String):void {
			this._wkn = value;
		}

	}
}