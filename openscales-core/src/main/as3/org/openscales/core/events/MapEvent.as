package org.openscales.core.events{
	
	import org.openscales.core.Map;

	public class MapEvent extends OpenScalesEvent {
		
		private var _map:Map = null;
		
		public static const MOVE_START:String="openscales.movestart";
		
		public static const MOVE:String="openscales.move";
		
		public static const MOVE_END:String="openscales.moveend";
		
		public static const ZOOM_END:String="openscales.zoomend";
		
		public static const DRAG:String="openscales.drag";
		
		public static const DRAG_END:String="openscales.dragend";
		
		/**
		 * Class: OpenLayers.Map
		 * Instances of MapEvent are events dispatched by the Map
		 */
		public function MapEvent(type:String, map:Map, bubbles:Boolean = false, cancelable:Boolean = false){
			this._map = map;
			super(type, bubbles, cancelable);
		}
		
	}
}