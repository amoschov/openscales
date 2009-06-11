package org.openscales.core.events
{
	public class TraceEvent extends OpenScalesEvent
	{
		private var _text:String = null;
		public static const TRACE:String="openscales.trace";
		
		public function TraceEvent(type:String, text:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._text = text;
			super(type, bubbles, cancelable);
		}
		
		public function get text():String{
			return this._text;
		}
		
		public function set text(value:String):void{
			this._text = value;
		}
		
	}
}