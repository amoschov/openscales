package org.openscales.core.events
{
	import org.openscales.core.Marker;
	import org.openscales.core.layer.Layer;
	
	public class MarkerEvent extends OpenScalesEvent
	{
		private var _marker:Marker = null;
		
		public static const ADD_MARKER:String="openscales.addmarker";
		
		public static const REMOVE_MARKER:String="openscales.removemarker";
		
		public static const CLEAR_MARKERS:String="openscales.clearmarkers";
		
		public function MarkerEvent(type:String, marker:Marker, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._marker = marker;
			super(type, bubbles, cancelable);
		}
		
	}
}