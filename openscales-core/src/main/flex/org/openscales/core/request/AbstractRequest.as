package org.openscales.core.request
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	import org.openscales.core.Trace;
	import org.openscales.core.UID;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.security.ISecurity;

	// See http://github.com/yahoo/yos-social-as3/blob/2e12ae0d3cfd01cd950b63db8c601495bdaf318d/Source/com/yahoo/net/Connection.as
	// for improvements ?
	public class AbstractRequest implements IRequest
	{
		/**
		 * This class manage a pool of connections so that the it
		 * can manage the number of simultaneous connections and
		 * prevent browser's "saturation"
		 */
		public static const DEFAULT_MAX_CONN:uint = 10; // number of parallel requests
		private static const DEFAULT_MAX_ACTIVE_TIME:uint = 0; // 5000 for a timeout of 5s by request
		private static var _maxConn:uint = DEFAULT_MAX_CONN;
		private static var _pendingRequests:Vector.<AbstractRequest> = new Vector.<AbstractRequest>();
		private static var _activeConn:HashMap = new HashMap();
		
		private var _duration:Number = DEFAULT_MAX_ACTIVE_TIME;
		private var _timer:Timer = null;

		public static const PUT:String = "put";
		public static const DELETE:String = "delete";

		private var _url:String;
		private var _method:String = null;
		private var _postContent:Object = null;
		private var _postContentType:String = null;
		// getter of postRequestData:Object
		private var _proxy:String = null;
        private var _security:ISecurity = null;

		private var _onComplete:Function = null;
		private var _onFailure:Function = null;
		private var _isSent:Boolean = false;
		private var _isCompleted:Boolean = false;
		private var _loader:Object = null;
		
		private var _uid:String;

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
		public function AbstractRequest(SWForImage:Boolean,
										url:String,
										onComplete:Function,
										onFailure:Function=null) {
			var uID:UID = new UID();
			this._uid = uID.gen_uid();
			// Create a loader for a SWF or an image (Loader), or for an URL (URLLoader)
			this._loader = (SWForImage) ? new Loader() : new URLLoader();

			this.url = url;
			this._onComplete = onComplete;
			this._onFailure = onFailure;
			
			this._addListeners();
		}

		/**
		 * Destroy the request.
		 */
		public function destroy():void {
			this._removeListeners();
			if(!this._isSent && this.security!=null)
				this.security.removeWaitingRequest(this);
			this._isSent = true;
			try {
				if (this._isCompleted && (this.loader is Loader)) {
					(this.loader as Loader).unloadAndStop(true);
				} // else ? // FixMe
				this.loader.close();
			} catch(e:Error) {
				// Empty catch is evil, but here it's fair.
			}
			if (AbstractRequest._activeConn.containsKey(uid)) {
				AbstractRequest._activeConn.remove(uid);
				AbstractRequest._runPending();
			} else {
				var i:int = AbstractRequest._pendingRequests.indexOf(this);
				if (i!=-1) {
					AbstractRequest._pendingRequests.splice(i, 1);
				}
			}
			if (this._timer) {
				this._timer = null;
			}
			//this._loader = null; // FixMe
		}
		
		/**
		 * Add listeners
		 */
		private function _addListeners():void {
			try {
				this.loaderInfo.addEventListener(Event.COMPLETE, this._loadEnd, false, int.MAX_VALUE, true);
				this.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this._loadEnd, false, int.MAX_VALUE, true);
				// IOErrorEvent.IO_ERROR must be listened to avoid this following error:
				// IOErrorEvent non pris en charge : text=Error #2124: Le type du fichier chargé est inconnu.
				this.loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this._loadEnd, false, int.MAX_VALUE, true);
				// SecurityErrorEvent.SECURITY_ERROR must be listened for the cross domain errors
				
				if (this._onComplete != null) {
					this.loaderInfo.addEventListener(Event.COMPLETE, this._onComplete);
				}
				
				if (this._onFailure != null) {
					this.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this._onFailure);
					this.loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this._onFailure);
				}
			} catch (e:Error) {
				Trace.error(e.message);
			}
		}
		
		/**
		 * Remove listeners
		 */
		private function _removeListeners():void {
			try {
				this.loaderInfo.removeEventListener(Event.COMPLETE, this._loadEnd);
				this.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this._loadEnd);
				this.loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this._loadEnd);
				
				if (this._onComplete != null) {
					this.loaderInfo.removeEventListener(Event.COMPLETE, this._onComplete);
				}
				
				if (this._onFailure != null) {
					this.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this._onFailure);
					this.loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this._onFailure);
				}
			} catch (e:Error) {
				Trace.error(e.message);
			}
		}
		
		/**
		 * When a loader ends, then start another if one
		 * 
		 * @param e:Event one of the listened events.
		 * We don't care about whitch one it is because it just means that a connection have been released.
		 */
		private function _loadEnd(event:Event=null):void {
			if (this._timer) {
				this._timer.stop();
			}
			if (event==null || (event.type == TimerEvent.TIMER)) {
				if (this._onFailure != null) {
					this._onFailure(new IOErrorEvent(IOErrorEvent.IO_ERROR));
				}
				this.destroy(); // called last since the listeners will be removed
			} else {
				if (event.type == Event.COMPLETE) {
					this._isCompleted = true;
				}
				else if (this._onFailure == null) {
					switch (event.type) {
						case IOErrorEvent.IO_ERROR:
						case SecurityErrorEvent.SECURITY_ERROR:
							Trace.error(event.toString());
							break;
					}
				}
			}
			AbstractRequest._activeConn.remove(uid);
			AbstractRequest._runPending();
		}
		
		/**
		 * Run pending connections if there is at least one
		 */
		static private function _runPending():void {
			var i:int = (AbstractRequest.maxConn==0) ? AbstractRequest._pendingRequests.length : (AbstractRequest.maxConn - AbstractRequest._activeConn.size());
			while ((i > 0) && (AbstractRequest._pendingRequests.length > 0)) {
				var pending:AbstractRequest = AbstractRequest._pendingRequests.shift();
				pending.execute();
				i--;
			}
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

		public function get uid():String {
			return this._uid;
		}

		/**
		 * Getter and setter of the method of the request.
		 * The valid values are null (default), URLRequestMethod.GET,
		 * URLRequestMethod.POST, AbstractRequest.PUT and AbstractRequest.DELETE.
		 * If the value is null, the getter returns URLRequestMethod.POST if
		 * postContent is not null and URLRequestMethod.GET otherwise.
		 */
		public function get method():String {
			if (this._method) {
				return this._method;
			} else {
				return (this.postContent) ? URLRequestMethod.POST : URLRequestMethod.GET;
			}
		}
		public function set method(value:String):void {
			switch (value) {
				case URLRequestMethod.GET:
				case URLRequestMethod.POST:
				case AbstractRequest.PUT:
				case AbstractRequest.DELETE:
					this._method = value;
					break;
				default:
					Trace.warning("AbstractRequest - set method: invalid value, null will be used");
					this._method = null;
					break;
			}
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

			if ((this.proxy != null)) {
				_finalUrl = this.proxy + encodeURIComponent(_finalUrl);
			}

			return _finalUrl;
		}

		/**
		 * Send the request (can be called only once).
		 * The request is really launched if the maximum number of parallels
		 * requests is not reached and it is pooled otherwise.
		 * If AbstractRequest.maxConn is zero, all the requests are launched
		 * immediately.
		 */
		public function send():void {
			if (this.isSent) {
				Trace.warning("AbstractRequest - send: the request has already been sent");
				return;
			}
			this._isSent = true;
			if(this.security != null && !this.security.initialized) {
				Trace.log("wait for security token");
				this.security.addWaitingRequest(this);
				this.security.initialize();
				return;
			}
			if ((AbstractRequest.maxConn == 0) || (AbstractRequest._activeConn.size() < AbstractRequest.maxConn)) {
				this.execute();
			} else {
				AbstractRequest._pendingRequests.push(this);
			}
		}

		/**
		 * Execute the request
		 */
		private function execute():void {
			AbstractRequest._activeConn.put(uid, null);
			try {
				// Define the urlRequest
				var _finalUrl:String = this.finalUrl;
				if ((_finalUrl==null) || (_finalUrl=="")) {
					// invalid url, abort
					this._loadEnd(null);
					return;
				}
				var urlRequest:URLRequest = new URLRequest(_finalUrl);
				urlRequest.method = this.method;
				if (urlRequest.method == URLRequestMethod.POST) {
					urlRequest.contentType = this.postContentType;
					urlRequest.data = this.postContent;
				}
				if (this.duration > 0) {
					this._timer = new Timer(this.duration, 1);
					this._timer.addEventListener(TimerEvent.TIMER, this._loadEnd);
					this._timer.start();
				} // else there is no timeout for the request
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
				this._loadEnd(null);
			}
		}

		/**
		 * Setter for the maximum running connections
		 * If the value is zero, all the pending requests will be sent and the
		 * future requests will be sent immediately.
		 * 
		 * @param value:uint the number of connections allowed
		 */
		static public function set maxConn(value:uint):void {
			AbstractRequest._maxConn = value;
			AbstractRequest._runPending();
		}

		/**
		 * getter for the maximum running connections
		 * 
		 * @return uint the allowed number of running connection
		 */
		static public function get maxConn():uint {
			return AbstractRequest._maxConn;
		}

		/**
		 * Setter for the delay before forcing an active connexion to close.
		 * If the value is zero (default), no timeout will be used.
		 * 
		 * @param Number value delay in milliseconds
		 */ 
		public function set duration(value:Number):void {
			if (this.isSent) {
				return;
			}
			this._duration = value;
		}

		/**
		 * getter for the delay before forcing an active connexion to close
		 * 
		 * @return Number duration in milliseconds
		 */
		public function get duration():Number {
			return this._duration;
		}
		
	}
	
}
