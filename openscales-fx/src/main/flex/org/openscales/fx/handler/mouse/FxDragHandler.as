package org.openscales.fx.handler.mouse
{
	import org.openscales.core.handler.mouse.DragHandler;
	import org.openscales.fx.handler.FxHandler;

	public class FxDragHandler extends FxHandler
	{
		public function FxDragHandler()
		{
			super();
			this.handler = new DragHandler();
		}
		
	}
}