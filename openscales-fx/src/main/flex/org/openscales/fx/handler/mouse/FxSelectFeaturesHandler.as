package org.openscales.fx.handler.mouse
{
	import org.openscales.core.handler.mouse.SelectFeaturesHandler;
	import org.openscales.fx.handler.FxHandler;

	public class FxSelectFeaturesHandler extends FxHandler
	{
		public function FxSelectFeaturesHandler()
		{
			this.handler = new SelectFeaturesHandler();
			super();
		}
		
	}
}