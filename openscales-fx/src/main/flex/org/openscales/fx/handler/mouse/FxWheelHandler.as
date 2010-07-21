package org.openscales.fx.handler.mouse
{
	import org.openscales.core.handler.mouse.WheelHandler;
	import org.openscales.fx.handler.FxHandler;

	public class FxWheelHandler extends FxHandler
	{
		public function FxWheelHandler()
		{
			this.handler = new WheelHandler();
			super();
		}
		public function set changeCenter(value:Boolean):void {
			(this.handler as WheelHandler).changeCenter = value;
		}
	}
}