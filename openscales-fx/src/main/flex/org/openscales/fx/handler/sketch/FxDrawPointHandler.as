package org.openscales.fx.handler.sketch
{
	import org.openscales.core.handler.feature.draw.DrawPointHandler;
	import org.openscales.fx.handler.FxHandler;

	public class FxDrawPointHandler extends FxHandler
	{
		public function FxDrawPointHandler()
		{
			this.handler = new DrawPointHandler();
			super();
		}
		
	}
}