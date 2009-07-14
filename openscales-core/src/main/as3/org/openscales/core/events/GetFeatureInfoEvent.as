package org.openscales.core.events{

	/**
	 * Event related to a data.
	 */
	public class GetFeatureInfoEvent extends OpenScalesEvent {
		
		/**
		 * data concerned by the event.
		 */
		private var _data:Object = null;
		
		public static const GET_FEATURE_INFO_DATA:String="openscales.getfeatureinfodata";
		
		/**
		 * Class: OpenLayers.data
		 * Instances of dataEvent are events dispatched by the data
		 */
		public function GetFeatureInfoEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false){
			this._data = data;
			super(type, bubbles, cancelable);
		}
		
		public function get data():Object {
			return this._data;
		}
		
		public function set data(data:Object):void {
			this._data = data;	
		}
	}
}