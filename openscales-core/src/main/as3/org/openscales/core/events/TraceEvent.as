package org.openscales.core.events
{
	/**
	 * Event related to trace messages
	 */
	public class TraceEvent extends OpenScalesEvent
	{
		private var _text:String = null;
		public static const INFO:String="openscales.info";
		public static const WARNING:String="openscales.warning";
		public static const ERROR:String="openscales.error";
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
