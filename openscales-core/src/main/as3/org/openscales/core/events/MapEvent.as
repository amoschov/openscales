package org.openscales.core.events{
	
	import flash.events.MouseEvent;

	public class MapEvent extends MouseEvent{
		
		/* Events types initially in the Map class
		public var EVENT_TYPES:Array = [
        "addlayer", "removelayer", "changelayer", "movestart", "move", 
        "moveend", "zoomend", "popupopen", "popupclose",
        "addmarker", "removemarker", "clearmarkers", "mouseOver",
        "mouseOut", "mouseMove", "dragstart", "drag", "dragend",
        "changebaselayer"];*/
		
		public static const LAYER_ADDED:String="addlayer";
		
		public static const LAYER_REMOVED:String="removelayer";
		
		public static const LAYER_CHANGED:String="changelayer";
		
		public static const BASE_LAYER_CHANGED:String="changebaselayer";
		
		public static const MOVE_START:String="movestart";
		
		public static const MOVE:String="move";
		
		public static const MOVE_END:String="moveend";
		
		public static const ZOOM_END:String="zoomend";
		
		public static const POPUP_OPEN:String="popupopen";
		
		public static const POPUP_CLOSE:String="popupclose";
		
		public static const ADD_MARKER:String="addmarker";
		
		public static const REMOVE_MARKER:String="removemarker";
		
		public static const CLEAR_MARKERS:String="clearmarkers";
				
		public static const DRAG:String="drag";
		
		public static const DRAG_END:String="dragend";

				
		/**
		 * Class: OpenLayers.Map
		 * Instances of MapEvent are events dispatched by the Map
		 */
		public function MapEvent(type:String){
			
			super(type);
		}
		
	}
}