package org.openscales.core
{
	import org.openscales.core.events.TraceEvent;
	
	public class Trace
	{
		public static var map:Map = null;
		public static const ERROR:String="openscales.error";
		public static const WARNING:String="openscales.warning";
		public static const INFO:String="openscales.info";
		
		public function Trace()
		{
		}
		
		public static function info(text:String):void
		{
			if(map != null)
			{
				map.dispatchEvent(new TraceEvent(TraceEvent.INFO,text));					
			}
			trace(text);
		}
		
		public static function warning(text:String):void
		{
			if(map != null)
			{
				map.dispatchEvent(new TraceEvent(TraceEvent.WARNING,text));					
			}
			trace(text);
		}
		
		public static function error(text:String):void
		{
			if(map != null)
			{
				map.dispatchEvent(new TraceEvent(TraceEvent.ERROR,text));					
			}
			trace(text);
		}

	}
}