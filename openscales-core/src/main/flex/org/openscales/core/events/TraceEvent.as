package org.openscales.core.events
{
	/**
	 * Event related to trace messages. These messages will be for example displayed in the TraceInfo control (openscales-fx).
	 */
	public class TraceEvent extends OpenScalesEvent
	{
		/**
		 * Text message related to this event 
		 */
		private var _text:String = null;
		
		/**
		 * Event type dispatched for an INFO level trace.
		 */
		public static const INFO:String="openscales.info";
		
		/**
		 * Event type dispatched for a WARNING level trace.
		 */
		public static const WARNING:String="openscales.warning";
		
		/**
		 * Event type dispatched for an ERROR level trace.
		 */
		public static const ERROR:String="openscales.error";
		
		/**
		 * Event type dispatched for a DEBUG level trace.
		 */
		public static const DEBUG:String="openscales.debug";
		
		public function TraceEvent(type:String, text:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			this._text = text;
			super(type, bubbles, cancelable);
		}
		
		public function get text():String {
			return this._text;
		}

		public function set text(value:String):void {
			this._text = value;
		}
		
	}
}
