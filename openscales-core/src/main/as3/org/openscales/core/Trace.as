package org.openscales.core
{
	import org.openscales.core.events.TraceEvent;
	
	public class Trace
	{
		public static var map:Map = null;
		
		public function Trace()
		{
		}
		
		public static function log(text:String):void
		{
			if(map != null)
			{
				map.dispatchEvent(new TraceEvent(TraceEvent.TRACE,text));
			}
			trace(text);
		}

	}
}