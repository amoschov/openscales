package org.openscales.core.request
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	
	import org.openscales.core.Trace;
	import org.openscales.core.security.ISecurity;
	
	// See http://github.com/yahoo/yos-social-as3/blob/2e12ae0d3cfd01cd950b63db8c601495bdaf318d/Source/com/yahoo/net/Connection.as
	// for improvements ?
	public class AbstractRequest implements IRequest
	{

		private var _url:String;
		private var _postContent:Object = null;
		private var _postContentType:String = null;
		// getter of postRequestData:Object
		private var _proxy:String = null;
        private var _security:ISecurity = null;

		private var _onComplete:Function = null;
		private var _onFailure:Function = null;

		private var _isSent:Boolean = false;
		private var _loader:Object = null;
		// getter of loaderInfo:Object
		// getter of finalUrl:String
		
		/**
		 * @constructor
		 * Create a new Request
		 * 
		 * @param SWForImage Boolean that defines if the request is a loading of a SWF object / an image or not
		 * @param url URL to use for the request (for instance http://server/dir/image123.png to dowload an image)
		 * @param onComplete Function called when the request is completed
		 * @param onFailure Function called when an error occurs
		 */
		public function AbstractRequest(SWForImage:Boolean, url:String, onComplete:Function, onFailure:Function=null) {
			try {
				// Create a loader for a SWF or an image (Loader), or for an URL (URLLoader)
				this._loader = (SWForImage) ? new Loader() : new URLLoader();
				
				this.url = url;
				
				this._onComplete = onComplete;
				if (this._onComplete != null) {
					this.loaderInfo.addEventListener(Event.COMPLETE, this._onComplete);
				}
				
				this._onFailure = onFailure;
				if (this._onFailure != null) {
					this.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this._onFailure);
					this.loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this._onFailure);
				}
			} catch (e:Error) {
				Trace.error(e.message);
			}
		}
		
		/**
		 * Destroy the request.
		 */
		public function destroy():void {
			this._isSent = true;

			if (this._onComplete != null) {
				this.loaderInfo.removeEventListener(Event.COMPLETE, this._onComplete);
			}

			if (this._onFailure != null) {
				this.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this._onFailure);
				this.loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this._onFailure);
			}
			
			try {
				this.loader.close();
			} catch(e:Error){
				// Empty catch are generally evil, but it is right in this case
			};
			
			//this._loader = null; // FixMe
		}
		
		/**
		 * Getter and setter of the url of the request.
		 */
		public function get url():String {
			return this._url;
		}
		public function set url(value:String):void {
			if ((! value) || (value=="")) {
				Trace.error("AbstractRequest - set url: invalid void value");
				return;
			}
			this._url = value;
		}
		
		/**
		 * Getter and setter of the content of a POST request.
		 * Default value is null, so the request is a GET request.
		 */
		public function get postContent():Object {
			return this._postContent;
		}
		public function set postContent(value:Object):void {
			this._postContent = value;
		}
		
		/**
		 * Getter and setter of the content type of a POST request.
		 * If postContentType is not explicitly defined, then
		 * "application/x-www-form-urlencoded" is returned if the postContent is
		 * an URLVariables and "application/xml" is returned otherwise.
		 */
		public function get postContentType():String {
			if (this._postContentType) {
				return this._postContentType;
			} else {
				return (this.postContent is URLVariables) ? "application/x-www-form-urlencoded" : "application/xml";
			}
		}
		public function set postContentType(value:String):void {
			this._postContentType = value;
		}
		
		/**
		 * Getter and setter of the proxy to use for a request.
		 * If a proxy (server side script) is used to avoid cross domain issues,
		 * specify its address here (for instance http://server/proxy.php?url=).
		 * Default value is null.
		 */
		public function get proxy():String {
			return this._proxy;
		}
		public function set proxy(value:String):void {
			this._proxy = value;
		}
		
		/**
		 * Getter and setter of the security module to use for a request.
		 * Default value is null.
		 */
		public function get security():ISecurity {
			return this._security;
		}
		public function set security(value:ISecurity):void {
			this._security = value;
		}
		
		/**
		 * Has the request been already sent ?
		 */
		protected function get isSent():Boolean {
			return this._isSent;
		}
		
		/**
		 * Getter of the loader of the request.
		 */
		public function get loader():Object {
			return this._loader;
		}
		
		/**
		 * Getter of the object that can be listened while loading.
		 */
		protected function get loaderInfo():Object {
			return (this.loader is Loader) ? this.loader.contentLoaderInfo : this.loader;
		}
		
		/**
		 * Getter of the final url of the request (using proxy and security).
		 */
		protected function get finalUrl():String {
			var _finalUrl:String = this.url;
			
			if (this.security != null) {
				if (! this.security.initialized) {
					// A redraw will be called on the layer when a SecurityEvent.SECURITY_INITIALIZED will be dispatched
					Trace.log("Security not initialized so cancel request");
					return null;
				}
				_finalUrl += (_finalUrl.indexOf("?") == -1) ? "?" : "&"; // If there is no "?" in the url, we will have to add it, else we will have to add "&"
				_finalUrl += this.security.securityParameter;
			}
			
			if ((this.proxy != null) && (this.proxy != "")) {
				_finalUrl = this.proxy + encodeURIComponent(_finalUrl);
			}
			
			return _finalUrl;
		}
		
		/**
		 * Send the request (can be called only once).
		 * URLRequestMethod.POST is used if postContent is not null and
		 * URLRequestMethod.GET otherwise (default).
		 */
		public function send():void {
			if (this.isSent) {
				Trace.warning("AbstractRequest - send: the request has already been sent");
				return;
			}
			this._isSent = true;
			try {
				// Define the urlRequest
				var _finalUrl:String = this.finalUrl;
				if ((_finalUrl==null) || (_finalUrl=="")) {
					return;
				}
				var urlRequest:URLRequest = new URLRequest(_finalUrl);
				urlRequest.method = (this.postContent) ? URLRequestMethod.POST : URLRequestMethod.GET;
				if (urlRequest.method == URLRequestMethod.POST) {
					urlRequest.contentType = this.postContentType;
					urlRequest.data = this.postContent;
				}
				
				if (this.loader is Loader) {
					this.loader.name = this.url; // Needed, see KMLFormat.updateImages for instance
					// Define the context for the loading of the SWF or Image
					var loaderContext:LoaderContext = new LoaderContext();
					loaderContext.checkPolicyFile = true;
					// Send the request
					(this.loader as Loader).load(urlRequest, loaderContext);
				} else {
					// Send the request
					(this.loader as URLLoader).load(urlRequest);
				}
			} catch (e:Error) {
				Trace.error("OpenLSRequest - send: " + e.message);
			}
		}
		
	}
	
}
