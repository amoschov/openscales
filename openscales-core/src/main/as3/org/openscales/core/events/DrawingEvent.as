package org.openscales.core.events
{
	
	/**
	 * Event related to the drawing action :
	 * 
	 * In order to not mix all handler (pan, drawing...), this event can determine when you're drawing.
	 * So if there are problems with control (like zoomBox or selectBox), you can easily manage 
	 * all different handlers.
	 **/
	public class DrawingEvent extends OpenScalesEvent
	{
		
		public static const ENABLED:String="openscales.drawing.enabled";
		public static const DISABLED:String="openscales.drawing.disabled";
		
		public function DrawingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}