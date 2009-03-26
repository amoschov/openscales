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
		
		public static const LAYER_ADDED:String="openscales.addlayer";
		
		public static const LAYER_REMOVED:String="openscales.removelayer";
		
		public static const LAYER_CHANGED:String="openscales.changelayer";
		
		public static const BASE_LAYER_CHANGED:String="openscales.changebaselayer";
		
		public static const MOVE_START:String="openscales.movestart";
		
		public static const MOVE:String="openscales.lmove";
		
		public static const MOVE_END:String="openscales.moveend";
		
		public static const ZOOM_END:String="openscales.zoomend";
		
		public static const POPUP_OPEN:String="openscales.popupopen";
		
		public static const POPUP_CLOSE:String="openscales.popupclose";
		
		public static const ADD_MARKER:String="openscales.addmarker";
		
		public static const REMOVE_MARKER:String="openscales.removemarker";
		
		public static const CLEAR_MARKERS:String="openscales.clearmarkers";
				
		public static const DRAG:String="openscales.drag";
		
		public static const DRAG_END:String="openscales.dragend";

				
		/**
		 * Class: OpenLayers.Map
		 * Instances of MapEvent are events dispatched by the Map
		 */
		public function MapEvent(type:String){
			
			super(type);
		}
		
	}
}