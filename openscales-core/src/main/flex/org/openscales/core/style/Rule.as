package org.openscales.core.style {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import org.openscales.core.filter.IFilter;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;

	public class Rule {

		public static const LEGEND_LINE:String = "Line";

		public static const LEGEND_POINT:String = "Point";

		public static const LEGENT_POLYGON:String = "Polygon";

		private var _name:String = "";

		private var _title:String = "";

		private var _abstract:String = "";

		private var _minScaleDenominator:Number = NaN;

		private var _maxScaleDenominator:Number = NaN;

		private var _filter:IFilter = null;

		private var _symbolizers:Array = [];

		public function Rule() {
		}

		/**
		 * Name of the Rule
		 */
		public function get name():String {

			return this._name;
		}

		public function set name(value:String):void {

			this._name = value;
		}

		/**
		 * Human readable short description (a few words and less than one line preferably)
		 */
		public function get title():String {

			return this._title;
		}

		public function set title(value:String):void {

			this._title = value;
		}

		/**
		 * Human readable description that may be several paragraph long
		 */
		public function get abstract():String {

			return this._abstract;
		}

		public function set abstract(value:String):void {

			this._abstract = value;
		}

		/**
		 * The minimum scale at which the rule is active
		 */
		public function get minScaleDenominator():Number {

			return this._minScaleDenominator;
		}

		public function set minScaleDenominator(value:Number):void {

			this._minScaleDenominator = value;
		}

		/**
		 * The maximum scale at which the rule is active
		 */
		public function get maxScaleDenominator():Number {

			return this._maxScaleDenominator;
		}

		public function set maxScaleDenominator(value:Number):void {

			this._maxScaleDenominator = value;
		}

		/**
		 * A filter used to determine if the rule is active for given feature
		 */
		public function get filter():IFilter {

			return this._filter;
		}

		public function set filter(value:IFilter):void {

			this._filter = value;
		}

		/**
		 * The list of symbolizers defining the ruless
		 */
		public function get symbolizers():Array {

			return this._symbolizers;
		}

		public function set symbolizers(value:Array):void {

			this._symbolizers = value;
		}

		// TODO: Externalise all the legend rendering stuff to a renderer class
		/**
		 * Renders the legend for the rule on given DisplayObject
		 */
		public function getLegendGraphic(type:String):DisplayObject {

			var result:Sprite = new Sprite();

			var drawMethod:Function;
			switch (type) {

				case LEGEND_POINT:  {

					drawMethod = this.drawPoint;
					break;
				}
				case LEGEND_LINE:  {

					drawMethod = this.drawLine;
					break;
				}
				default:  {

					drawMethod = this.drawPolygon;
				}

			}

			for each (var symbolizer:Symbolizer in this.symbolizers) {

				symbolizer.configureGraphics(result.graphics, null);
				drawMethod.apply(this, [symbolizer, result]);
			}

			return result;
		}

		private function drawLine(symbolizer:Symbolizer, canvas:Sprite):void {

			canvas.graphics.moveTo(5, 25);
			canvas.graphics.curveTo(5, 15, 15, 15);
			canvas.graphics.curveTo(25, 15, 25, 5);
		}

		private function drawPoint(symbolizer:Symbolizer, canvas:Sprite):void {

			if (symbolizer is PointSymbolizer) {

				var pointSymbolizer:PointSymbolizer = (symbolizer as PointSymbolizer);
				if (pointSymbolizer.graphic) {
					if (pointSymbolizer.graphic is WellKnownMarker) {

						this.drawMark(pointSymbolizer.graphic as WellKnownMarker, canvas);
					}
				}
			}
		}

		protected function drawMark(mark:WellKnownMarker, canvas:Sprite):void {

			mark.fill.configureGraphics(canvas.graphics, null);
			mark.stroke.configureGraphics(canvas.graphics);

			var size:Number = mark.getSizeValue(null);

			switch (mark.wellKnownName) {

				case WellKnownMarker.WKN_SQUARE:  {
					canvas.graphics.drawRect(15 - size / 2, 15 - size / 2, size, size);
					break;
				}
				case WellKnownMarker.WKN_CIRCLE:  {
					canvas.graphics.drawCircle(15, 15, size / 2);
					break;
				}
				case WellKnownMarker.WKN_TRIANGLE:  {
					// TODO : Check for the drawing of the triangles
					canvas.graphics.moveTo(0, (size / 2));
					canvas.graphics.lineTo(size, size);
					canvas.graphics.lineTo(0, size);
					canvas.graphics.lineTo(0, (size / 2));
					break;
				}
				// TODO : Implement other well known names and take into account opacity, rotation of the mark
			}
		}

		private function drawPolygon(symbolizer:Symbolizer, canvas:Sprite):void {

			canvas.graphics.moveTo(5, 5);
			canvas.graphics.lineTo(25, 5);
			canvas.graphics.lineTo(25, 25);
			canvas.graphics.lineTo(5, 25);
			canvas.graphics.lineTo(5, 5);
		}
	}
}