package org.openscales.core.style.marker {
	import flash.display.DisplayObject;

	/**
	 * DisplayObjectMarker defines the representation of a punctual feature
	 * as an instance of a given that extends DisplayObject
	 */
	public class DisplayObjectMarker extends Marker {
		private var _c:Class;

		private var _xOffset:Number;

		private var _yOffset:Number;

		public function DisplayObjectMarker(c:Class, xOffset:Number=0, yOffset:Number=0, size:Number=6, opacity:Number=1, rotation:Number=0) {

			super(size, opacity, rotation);

			this._c = c;
			this._xOffset = xOffset;
			this._yOffset = yOffset;
		}

		override protected function generateGraphic():DisplayObject {

			var result:DisplayObject = (new _c() as DisplayObject);
			result.x = this._xOffset;
			result.y = this._yOffset;
			return result;
		}

		/**
		 * Offset along the x axis for the position of the display object
		 */
		public function set xOffset(value:Number):void {

			this._xOffset = value;
		}

		public function get xOffset():Number {

			return this._xOffset;
		}


		/**
		 * Offset along the y axis for the position of the display object
		 */
		public function set yOffset(value:Number):void {

			this._yOffset = value;
		}

		public function get yOffset():Number {

			return this._yOffset;
		}

	}
}