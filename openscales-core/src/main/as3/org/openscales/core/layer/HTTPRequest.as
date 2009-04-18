package org.openscales.core.layer
{
	import org.openscales.core.Util;
	
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
		
		private var _params:Object = null;
		
		public function HTTPRequest(name:String, url:String, params:Object = null, options:Object = null):void {
	        super(name, options);
	        this.url = url;
	        this.params = Util.extend( new Object(), params);
		}
		
		override public function destroy(setNewBaseLayer:Boolean = true):void {
			this.url = null;
			this.params = null;
			super.destroy(setNewBaseLayer);
		}
		
		override public function clone(obj:Object):Object {
			if (obj == null) {
	            obj = new HTTPRequest(this.name,
                                       this.url,
                                       this.params);
	        }

	        obj = new Layer(this.name, arguments).clone([obj]);
	        
	        return obj;
		}
		
		public function mergeNewParams(newParams:Array):void {
			this.params = Util.extend(this.params, newParams);
		}
		
		public function selectUrl(paramString:String, urls:Array):String {
			var product:Number = 1;
	        for (var i:int = 0, len:int=paramString.length; i < len; i++) { 
	            product *= paramString.charCodeAt(i) * this.URL_HASH_FACTOR; 
	            product -= Math.floor(product); 
	        }
	        
	        return urls[Math.floor(product * urls.length)];
		}
		
		public function getFullRequestString(newParams:Object = null, altUrl:String = null):String {
	        var url:String = altUrl || this.url;
	        
	        var allParams:Object = Util.extend(new Object(), this.params);
	        allParams = Util.extend(allParams, newParams);
	        var paramsString:String = Util.getParameterString(allParams);
	        
   	        if (this.altUrls != null) {
	            url = this.selectUrl(paramsString, this.getUrls());
	        }  

	        var urlParams:Object = 
	            Util.upperCaseObject(Util.getArgs(url));
	        for(var key:String in allParams) {
	            if(key.toUpperCase() in urlParams) {
	                delete allParams[key];
	            }
	        }
	        paramsString = Util.getParameterString(allParams);
	        
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
		
		public function get params():Object
		{
			return this._params;
		}
		
		public function set params(value:Object):void
		{
			this._params = value;
		}	
	}
}