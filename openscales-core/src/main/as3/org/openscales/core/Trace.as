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
		
		public static function log(text:String,type:String):void
		{
			if(map != null)
			{
				if(type == Trace.ERROR)
				{
					map.dispatchEvent(new TraceEvent(TraceEvent.ERROR,text));
				}
				if(type == Trace.WARNING)
				{
					map.dispatchEvent(new TraceEvent(TraceEvent.WARNING,text));
				}
				if(type == Trace.INFO)
				{
					map.dispatchEvent(new TraceEvent(TraceEvent.INFO,text));
				}	
			}
			trace(text);
		}

	}
}