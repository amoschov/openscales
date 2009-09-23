package org.openscales.core.events
{
	
	/**
	 * Event related to zoombox
	 */
	public class ZoomBoxEvent extends OpenScalesEvent
	{
		
		/**
		 * Event type dispatched at the end of the drawing of the zoombox.
		 */
		public static const END:String="openscales.zoombox.end";
		
		public function ZoomBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}