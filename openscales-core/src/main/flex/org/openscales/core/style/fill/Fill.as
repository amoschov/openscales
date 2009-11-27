package org.openscales.core.style.fill
{
	import flash.display.Graphics;
	
	/**
	 * Abstract class for defining how a fill is rendered
	 */
	public class Fill
	{
		/**
		 * Configure the <em>graphics</em> properties of a display object 
		 * so that the fill is rendered when drawing
		 */
		public function configureGraphics(graphics:Graphics):void{
			
			// To be implemented by children
		}
	}
}