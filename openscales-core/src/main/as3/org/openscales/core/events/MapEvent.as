package org.openscales.core.events{

	import org.openscales.core.Map;

	/**
	 * Event related to a map.
	 */
	public class MapEvent extends OpenScalesEvent {

		/**
		 * Map concerned by the event.
		 */
		private var _map:Map = null;
		
		/**
		 * old zoom of the map
		 */
		 private var _oldZoom:Number = 0;
		 
		 /**
		 * old zoom of the map
		 */
		 private var _newZoom:Number = 0;

		/**
		 * Event type dispatched before map move.
		 */
		public static const MOVE_START:String="openscales.movestart";

		/**
		 * Event type dispatched during map move.
		 */
		public static const MOVE:String="openscales.move";

		/**
		 * Event type dispatched after map move if the center has changed.
		 * There is no DRAG_END since a MOVE_END event is emitted if the center has finally changed
		 */
		public static const MOVE_END:String="openscales.moveend";
		
		/**
 		 * Event type dispatched before map zoom.
		 */
		public static const ZOOM_START:String="openscales.zoomstart";
		
		/**
		 * Event type dispatched after map zoom.
		 */
		public static const ZOOM_END:String="openscales.zoomend";

		/**
		 * Event type dispatched just before dragging the map.
		 */
		public static const DRAG_START:String="openscales.dragstart";
		
		/**
 		 * Event type dispatched during map resize.
		 */
		public static const RESIZE:String="openscales.resize";


		/**
		 * Instances of MapEvent are events dispatched by the Map
		 */
		public function MapEvent(type:String, map:Map, bubbles:Boolean = false, cancelable:Boolean = false){
			this._map = map;
			super(type, bubbles, cancelable);
		}

		public function get map():Map {
			return this._map;
		}

		public function set map(map:Map):void {
			this._map = map;	
		}
		
		public function get oldZoom():Number {
			return this._oldZoom;
		}

		public function set oldZoom(value:Number):void {
			this._oldZoom = value;	
		}
		
		public function get newZoom():Number {
			return this._newZoom;
		}

		public function set newZoom(value:Number):void {
			this._newZoom = value;	
		}
	}
}

