package org.openscales.core.request
{
	import org.openscales.core.Trace;
	import org.openscales.core.security.ISecurity;
	
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
