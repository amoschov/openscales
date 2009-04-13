package org.openscales.fx.handler
{
	import mx.core.UIComponent;
	
	import org.openscales.core.control.IControl;
	import org.openscales.core.handler.IHandler;

	public class FxHandler extends UIComponent
	{
		private var _handler:IHandler;
		
		public function FxHandler()
		{
			super();
		}
		
		public function set handler(value:IHandler):void {
			this._handler = value;
		}
		
		public function get handler():IHandler {
			return this._handler;
		}
		
	}
}