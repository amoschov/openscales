package org.openscales.core.events
{
	import flash.events.Event;

	public class OpenScalesEvent extends Event
	{
		public function OpenScalesEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}