package org.openscales.core
{
	import org.openscales.core.events.TraceEvent;
	
	/**
	 * Class which allows to show trace messages in a flex component.
	 *
	 * To that goal, we have to use one of its three static methods info, warning or error
	 * instead of trace native method.
	 * It does two things : call trace native method and dispatch a Trace event through the map
	 * in order to be able to catch it elsewhere.
	 *
	 * According to the trace level (info, warning, error or debug), the flex
	 * component will show it in a diffrent color.
	 */
	public class Trace
	{
		public static var map:Map = null;
		public static const INFO:String="openscales.info";
		public static const WARNING:String="openscales.warning";
		public static const ERROR:String="openscales.error";
		public static const DEBUG:String="openscales.debug";
		
		public function Trace() {
			// Nothing to do
		}
		
		public static function info(text:String):void {
			if(map != null) {
				map.dispatchEvent(new TraceEvent(TraceEvent.INFO,text));					
			}
			trace(text);
		}
		
		public static function warning(text:String):void {
			if(map != null) {
				map.dispatchEvent(new TraceEvent(TraceEvent.WARNING,text));					
			}
			trace(text);
		}
		
		public static function error(text:String):void {
			if(map != null) {
				map.dispatchEvent(new TraceEvent(TraceEvent.ERROR,text));					
			}
			trace(text);
		}
		
		public static function debug(text:String):void {
			if(map != null) {
				map.dispatchEvent(new TraceEvent(TraceEvent.DEBUG,text));					
			}
			trace(text);
		}
		
	}
}
