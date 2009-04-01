package org.openscales.core.events{
	
	import flash.events.MouseEvent;

	public class MapEvent extends MouseEvent{
		
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
		
		public static const TILE_LOAD_START:String="openscales.loadstart";
		
		public static const TILE_LOAD_END:String="openscales.loadend";


				
		/**
		 * Class: OpenLayers.Map
		 * Instances of MapEvent are events dispatched by the Map
		 */
		public function MapEvent(type:String){
			
			super(type);
		}
		
	}
}