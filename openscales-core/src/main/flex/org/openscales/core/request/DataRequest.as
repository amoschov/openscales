package org.openscales.core.request
{
	//import org.openscales.core.Trace;
	
	/**
	 * DataRequest is used to download binary data available from an URL, like
	 * an image.
	 */
	public class DataRequest extends AbstractRequest {
		
		/**
		 * @constructor
		 */
		public function DataRequest(url:String, onComplete:Function, onFailure:Function=null) {
			super(true, url, onComplete, onFailure);
		}
		
	}
	
}
