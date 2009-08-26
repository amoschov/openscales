package org.openscales.core.events
{
	public class ZoomBoxEvent extends OpenScalesEvent
	{
		
		public static const END:String="openscales.zoombox.end";
		
		public function ZoomBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}