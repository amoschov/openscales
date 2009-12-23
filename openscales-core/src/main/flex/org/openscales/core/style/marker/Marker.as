package org.openscales.core.style.marker {
	import flash.display.DisplayObject;
	import flash.display.Shape;

	import org.openscales.core.feature.Feature;
	import org.openscales.core.filter.expression.IExpression;

	public class Marker {
		private var _opacity:Number = 1;

		private var _rotation:Number = 0;

		private var _size:Object = 6;

		public function Marker(size:Object=6, opacity:Number=1, rotation:Number=0) {
			this.opacity = opacity;
			this.rotation = rotation;
			this.size = size;
		}

		/**
		 * Returns an instance of the DisplayObject that contains the graphic.
		 */
		public function getDisplayObject(feature:Feature):DisplayObject {

			var result:DisplayObject = this.generateGraphic(feature);

			result.alpha = this.opacity;
			result.rotation = this.rotation;

			return result;
		}

		protected function generateGraphic(feature:Feature):DisplayObject {
			return new Shape();
		}

		public function get opacity():Number {

			return this._opacity;
		}

		public function set opacity(value:Number):void {

			this._opacity = value;
		}

		public function get rotation():Number {

			return this._rotation;
		}

		public function set rotation(value:Number):void {

			this._rotation = value;
		}

		public function get size():Object {

			return this._size;
		}

		public function set size(value:Object):void {

			if (!(value is Number || value is IExpression)) {

				throw new ArgumentError("Marker size must be either a Number or a IExpression");
			}

			this._size = value;
		}

		/**
		 * Evaluates the size value for given feature
		 */
		public function getSizeValue(feature:Feature):Number {

			if (this._size) {

				if (this._size is IExpression) {

					return ((this._size as IExpression).evaluate(feature) as Number);
				} else {

					return (this._size as Number);
				}
			}

			return 6;
		}
	}
}