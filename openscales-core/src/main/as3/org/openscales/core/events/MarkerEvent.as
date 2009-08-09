package org.openscales.core.events
{
	import org.openscales.core.feature.Marker;

	/**
	 * Event related to a marker.
	 */
	public class MarkerEvent extends OpenScalesEvent
	{
		/**
		 * Marker concerned by the event.
		 */
		private var _marker:Marker = null;

		public static const ADD_MARKER:String="openscales.addmarker";		
		public static const REMOVE_MARKER:String="openscales.removemarker";		
		public static const CLEAR_MARKERS:String="openscales.clearmarkers";

		public function MarkerEvent(type:String, marker:Marker, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._marker = marker;
			super(type, bubbles, cancelable);
		}

		public function get marker():Marker {
			return this._marker;
		}

		public function set marker(marker:Marker):void {
			this._marker = marker;	
		}

	}
}

