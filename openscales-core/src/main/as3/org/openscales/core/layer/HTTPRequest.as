package org.openscales.core.layer
{
	import org.openscales.core.Util;
	import org.openscales.core.layer.params.IHttpParams;
	
	
	/**
	 * Base class for layers based on a remote image server
	 */
	public class HTTPRequest extends Layer
	{
		
		public var URL_HASH_FACTOR:Number = (Math.sqrt(5) - 1) / 2;
		
		/**
		 * Main url
		 */
		private var _url:String = null;
		
		/**
		 * Alternative urls
		 */
		private var _altUrls:Array = null;
		
		private var _params:IHttpParams = null;
		
		public function HTTPRequest(name:String, url:String, params:IHttpParams = null, isBaseLayer:Boolean = false, 
									visible:Boolean = true, projection:String = null, proxy:String = null) {
	       
	        super(name, isBaseLayer, visible, projection, proxy);
	        
	        this.url = url;
	        this.params = params;
		}
		
		override public function destroy(setNewBaseLayer:Boolean = true):void {
			this.url = null;
			this.params = null;
			super.destroy(setNewBaseLayer);
		}
		
		/**
	     * Create a clone
	     *
	     * @param obj
	     * 
	     * @return An exact clone
	     */
	/*	override public function clone(obj:Object):Object {
			if (obj == null) {
	            obj = new HTTPRequest(this.name,
                                       this.url,
                                       this.params);
	        }

	        obj = new Layer(this.name, arguments).clone([obj]);
	        
	        return obj;
		}*/

		
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
		
		/** 
	     * Combine url with layer's params and these newParams. 
	     *   
	     *    does checking on the serverPath variable, allowing for cases when it 
	     *     is supplied with trailing ? or &, as well as cases where not. 
	     *
	     * @param newParams
	     * @param altUrl Use this as the url instead of the layer's url
	     *   
	     * @return return in formatted string
	     */
		public function getFullRequestString(altUrl:String = null):String {
	        var url:String = altUrl || this.url;
	        
	        var paramsString:String = this.params.toGETString();
	        
   	        if (this.altUrls != null) {
	            url = this.selectUrl(paramsString, this.getUrls());
	        }  
	        
	        var requestString:String = url;        
	        
	        if (paramsString != "") {
	            var lastServerChar:String = url.charAt(url.length - 1);
	            if ((lastServerChar == "&") || (lastServerChar == "?")) {
	                requestString += paramsString;
	            } else {
	                if (url.indexOf('?') == -1) {
	                    requestString += '?' + paramsString;
	                } else {
	                    requestString += '&' + paramsString;
	                }
	            }
	        }
	        return requestString;	
		}
		
		public function getUrls():Array {
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
		
		// Getters & setters	
		public function get url():String
		{
			return this._url;
		}
		
		public function set url(value:String):void
		{
			this._url = value;
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
		
		public function mergeNewParams(param:String, value:String):Boolean {
			this._params.setAdditionalParam(param, value)
			return this.redraw();
		}
	}
}