package org.openscales.core.layer
{
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.layer.params.IHttpParams;
	import org.openscales.core.layer.requesters.AbstractRequest;
	import org.openscales.core.layer.requesters.IhttpRequest;
	
	
	/**
	 * Base class for layers based on a remote image server
	 */
	public class HTTPRequest extends RequestLayer
	{
		
		public var URL_HASH_FACTOR:Number = (Math.sqrt(5) - 1) / 2;
	
	
	/*
	TODO delete url & co
	*/
		
		
		
		private var _url:String = null;
		
		/**
		 * Alternative urls
		 */
		private var _altUrls:Array = null;
		
		private var _params:IHttpParams = null;
		
		
		
		public function HTTPRequest(name:String, url:String, params:IHttpParams = null,ihttpRequest:IhttpRequest=null,isBaseLayer:Boolean = false, 
									visible:Boolean = true, projection:String = null, proxy:String = null,onLoadComplete:Function=null) {
	       
	        super(name,ihttpRequest,isBaseLayer, visible, projection, proxy);

			//TODO remove that after creation of osmparams and georssparams extends IhttpRequest
			this._url=url;
			this.params = params;
		}
		
		override public function destroy(setNewBaseLayer:Boolean = true):void {
			
			super.destroy(setNewBaseLayer);
		}
		
		//we will remove this method after adding all params like osm params and wms params
		public function getUrls():Array 
		{
		var urls:Array = null;
			
			if((altUrls == null) || (altUrls.length == 0)) {
				urls = new Array(1);
				urls[0] = this.url;
			} else {
				urls = new Array(altUrls.length);
				urls[0] = this.url;
				for(var i:int=1; i<=altUrls.length; i++) {
					urls[i] = altUrls[i-1];
				}
			}
			
			return urls;
		
		}
		/**
	     * selectUrl() implements the standard floating-point multiplicative
	     *     hash function described by Knuth, and hashes the contents of the 
	     *     given param string into a float between 0 and 1. This float is then
	     *     scaled to the size of the provided urls array, and used to select
	     *     a URL.
	     *
	     * @param paramString
	     * @param urls
	     * 
	     * @return An entry from the urls array, deterministically selected based
	     *          on the paramString.
	     */
		public function selectUrl(paramString:String, urls:Array):String {
			var product:Number = 1;
	        for (var i:int = 0, len:int=paramString.length; i < len; i++) { 
	            product *= paramString.charCodeAt(i) * this.URL_HASH_FACTOR; 
	            product -= Math.floor(product); 
	        }
	        
	        return urls[Math.floor(product * urls.length)];
		}
		
		
		
		// Getters & setters	
		
		public function get url():String
		{
			return this._url;
		}
		
		public function set url(value:String):void
		{
			this._url = value;
			(this.requester as AbstractRequest).url=value;
		}
		
		public function get altUrls():Array
		{
			return this._altUrls;
		}
		
		public function set altUrls(value:Array):void
		{
			this._altUrls = value;
		}
		
		public function get params():IHttpParams
		{
			return this._params;
		}
		
		public function set params(value:IHttpParams):void
		{
			this._params = value;
		}
		
		
	
	}
}