package org.openscales.core.style.symbolizer {
	import flash.display.Graphics;

	import org.openscales.core.feature.Feature;

	public class Symbolizer {
		private var _geometry:String;

		public function Symbolizer() {
		}

		/**
		 * The name of the geometry attribute of the rule that will be rendered using the symbolizer
		 */
		public function get geometry():String {

			return this._geometry;
		}

		public function set geometry(value:String):void {

			this._geometry = value;
		}

		/**
		 * Configure the <em>graphics</em> properties of a display object
		 * accordind to the symbolizer's definition
		 */
		public function configureGraphics(graphics:Graphics, feature:Feature):void {
		}

	}
}