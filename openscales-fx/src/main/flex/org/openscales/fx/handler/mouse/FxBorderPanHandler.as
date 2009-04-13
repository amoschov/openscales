package org.openscales.fx.handler.mouse
{
	import org.openscales.core.handler.mouse.BorderPanHandler;
	import org.openscales.fx.handler.FxHandler;

	public class FxBorderPanHandler extends FxHandler
	{
		public function FxBorderPanHandler()
		{
			this.handler = new BorderPanHandler();
			super();
		}
		
	}
}