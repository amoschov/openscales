package org.openscales.core.style.marker {
	import flash.display.DisplayObject;
	import flash.display.Shape;

	public class Marker {
		private var _opacity:Number = 1;

		private var _rotation:Number = 0;

		private var _size:Number = 6;

		public function Marker(size:Number=6, opacity:Number=1, rotation:Number=0) {
			this.opacity = opacity;
			this.rotation = rotation;
			this.size = size;
		}

		/**
		 * Returns an instance of the DisplayObject that contains the graphic.
		 */
		public function get instance():DisplayObject {

			var result:DisplayObject = this.generateGraphic();

			result.alpha = this.opacity;
			result.height = this.size;
			result.width = this.size;
			result.rotation = this.rotation;

			return result;
		}

		protected function generateGraphic():DisplayObject {
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

		public function get size():Number {

			return this._size;
		}

		public function set size(value:Number):void {

			this._size = value;
		}
	}
}