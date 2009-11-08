package org.openscales.fx.handler.mouse
{
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.fx.handler.FxHandler;

	public class FxClickHandler extends FxHandler
	{
		/**
		 * Constructor of the handler component
		 */
		public function FxClickHandler()
		{
			super();
			this.handler = new ClickHandler();
		}
		
	}
}