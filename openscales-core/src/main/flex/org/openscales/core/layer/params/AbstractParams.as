package org.openscales.core.layer.params
{
	/**
	 * This class is an abstract class don't use it directly use others oarams like
	 * wmsparams WFSparams...
	 * */
	public class AbstractParams implements IHttpParams
	{
		/**
		 *requesting bbox
		 **/
		private var _bbox:String;

		public function AbstractParams()
		{
		}

		public function toGETString():String
		{
			return null;
		}

		public function setAdditionalParam(key:String, value:String):void
		{
		}

		/**
		 *requesting bbox
		 **/
		public function get bbox():String {
			return _bbox;
		}
		/**
		 * @private
		 * */
		public function set bbox(bbox:String):void {
			_bbox = bbox;
		}
	}
}

