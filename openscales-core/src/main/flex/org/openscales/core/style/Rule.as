package org.openscales.core.style {
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	
	import org.openscales.core.Trace;
	import org.openscales.core.filter.IFilter;
	import org.openscales.core.style.symbolizer.Fill;
	import org.openscales.core.style.symbolizer.FillSymbolizer;
	import org.openscales.core.style.symbolizer.Mark;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.Stroke;
	import org.openscales.core.style.symbolizer.StrokeSymbolizer;
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

				Rule.setStyle(symbolizer, result);
				drawMethod.apply(this, [symbolizer, result]);
			}

			return result;
		}

		public static function setStyle(symbolizer:Symbolizer, canvas:Sprite):void {
			if (symbolizer is FillSymbolizer) {
				configureGraphicsFill((symbolizer as FillSymbolizer).fill, canvas);
			}
			if (symbolizer is StrokeSymbolizer) {
				configureGraphicsStroke((symbolizer as StrokeSymbolizer).stroke, canvas);
			}
		}

		public static function configureGraphicsFill(fill:Fill, canvas:Sprite):void {
			if (fill) {
Trace.debug("Rule.configureGraphicsFill color="+fill.color);
				canvas.graphics.beginFill(fill.color, fill.opacity);
			} else {
				canvas.graphics.endFill();
			}
		}

		public static function configureGraphicsStroke(stroke:Stroke, canvas:Sprite):void {
			if (stroke) {
				var linecap:String;
				var linejoin:String;
				switch (stroke.linecap) {
					case Stroke.LINECAP_ROUND:
						linecap = CapsStyle.ROUND;
						break;
					case Stroke.LINECAP_SQUARE:
						linecap = CapsStyle.SQUARE;
						break;
					default:
						linecap = CapsStyle.NONE;
				}

				switch (stroke.linejoin) {
					case Stroke.LINEJOIN_ROUND:
						linejoin = JointStyle.ROUND;
						break;
					case Stroke.LINEJOIN_BEVEL:
						linejoin = JointStyle.BEVEL;
						break;
					default:
						linejoin = JointStyle.MITER;
				}

Trace.debug("Rule.configureGraphicsStroke color="+stroke.color);
				canvas.graphics.lineStyle(stroke.width, stroke.color, stroke.opacity, false, "normal", linecap, linejoin);
			} else {
				canvas.graphics.lineStyle();
			}
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
					if (pointSymbolizer.graphic is Mark) {

						this.drawMark(pointSymbolizer.graphic as Mark, canvas);
					}
				}
			}
		}

		protected function drawMark(mark:Mark, canvas:Sprite):void {

			Rule.configureGraphicsFill(mark.fill, canvas);
			Rule.configureGraphicsStroke(mark.stroke, canvas);

			switch (mark.wellKnownName) {

				case Mark.WKN_SQUARE:  {
					canvas.graphics.drawRect(15 - mark.size / 2, 15 - mark.size / 2, mark.size, mark.size);
					break;
				}
				case Mark.WKN_CIRCLE:  {
					canvas.graphics.drawCircle(15, 15, mark.size / 2);
					break;
				}
				case Mark.WKN_TRIANGLE:  {
					// TODO : Check for the drawing of the triangles
					canvas.graphics.moveTo(0, (mark.size / 2));
					canvas.graphics.lineTo(mark.size, mark.size);
					canvas.graphics.lineTo(0, mark.size);
					canvas.graphics.lineTo(0, (mark.size / 2));
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