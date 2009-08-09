package org.openscales.core.events{

	/**
	 * Event allowing to get information about a WMS feature when we click on it.
	 * Dispatched for example by the WMSGetFeatureInfo handler
	 */
	public class GetFeatureInfoEvent extends OpenScalesEvent {

		/**
		 * Data returned by the WMSGetFeatureInfo request
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

