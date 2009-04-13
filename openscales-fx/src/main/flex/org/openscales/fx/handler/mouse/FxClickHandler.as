package org.openscales.fx.handler.mouse
{
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.fx.handler.FxHandler;

	public class FxClickHandler extends FxHandler
	{
		public function FxClickHandler()
		{
			this.handler = new ClickHandler();
			super();
		}
		
	}
}