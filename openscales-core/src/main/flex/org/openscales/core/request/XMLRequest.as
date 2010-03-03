package org.openscales.core.request
{
	//import org.openscales.core.Trace;
	
	/**
	 * XMLRequest
	 */
	public class XMLRequest extends AbstractRequest {
		
		/**
		 * @constructor
		 */
		public function XMLRequest(url:String, onComplete:Function, onFailure:Function=null) {
			super(false, url, onComplete, onFailure);
		}
		
	}
	
}
