package org.openscales.core.style.fill {
	import flash.display.Graphics;

	import org.openscales.core.feature.Feature;

	/**
	 * Abstract class for defining how a fill is rendered
	 */
	public class Fill {
		/**
		 * Configure the <em>graphics</em> properties of a display object
		 * so that the fill is rendered when drawing
		 */
		public function configureGraphics(graphics:Graphics, feature:Feature):void {

			// To be implemented by children
		}
	}
}