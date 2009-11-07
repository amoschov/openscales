package org.openscales.fx.handler
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import org.openscales.core.Trace;
	import org.openscales.core.control.IControl;
	import org.openscales.core.handler.IHandler;

	public class FxHandler extends UIComponent
	{
		private var _handler:IHandler;
		
		public function FxHandler()
		{
			super();
		}
		
		public function get handler():IHandler {
			return this._handler;
		}
		public function set handler(value:IHandler):void {
			this._handler = value;
		}

		[Bindable(event="propertyChange")]
		public function get active():Boolean {
			return this._handler.active;
		}
		public function set active(value:Boolean):void {
Trace.debug("FxHandler.active="+value);
			this._handler.active = value;
			// Dispatch an event to allow binding for the map of this Control
			dispatchEvent(new Event("propertyChange"));
		}
				
	}
}