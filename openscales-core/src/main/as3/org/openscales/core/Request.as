package org.openscales.core
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.basetypes.Bounds;

	public class Request
	{
		public static var activeRequestCount:int = 0;
		private var _url:String = null;
		private var _method:String = null;
		private var _onComplete:Function = null;
		private var _postBody:Object = null;
		private var _parameters:Object = null;
		
		/**
		 * Request constructor
		 * 
		 * @param url
		 * @param method
		 * @param onComplete
		 * @param postBody
		 * @param parameters
		 * @param proxy
		 */
		public function Request(url:String, method:String, onComplete:Function = null, 
								postBody:Object = null, parameters:Object = null, proxy:String = null) {
			
			this._url = url;
			this._method = method;
			this._onComplete = onComplete;
			this._postBody = postBody;
			this._parameters = parameters;
			
			if (this._parameters == null)
				this._parameters = '';
			
			this.request(proxy);
		}
		
		private function request(proxy:String):void {
			var parameters:Object = this._parameters;

		    try {

		      var body:Object= this._postBody;
		      
		      if (body) {
		      	this._method = URLRequestMethod.POST;
		      	
		      	if (parameters.BBOX) {
		      		var bbox:String = Bounds.getBBOXStringFromBounds(parameters.BBOX);
		      		body.*::Query.*::Filter.*::And.*::BBOX.*::Box.*::coordinates = bbox;
		      		url = url.split("?")[0];
		      	}
		      }

		      Trace.info(this.url);
		      
		      if (this._method == URLRequestMethod.GET && parameters.length > 0)
		        this.url += (this.url.match(/\?/) ? '&' : '?') + Util.getParameterString(parameters);

		      if ((proxy != null) && (proxy != "")) {
		      	this.url = proxy + encodeURIComponent(this.url);
		      }
		      var loader:URLLoader = new URLLoader();
			  configureListeners(loader);

		      var urlRequest:URLRequest = new URLRequest(this.url);
		      urlRequest.method = this._method;

			  if (this._method == URLRequestMethod.POST) {
		      		urlRequest.data = body;
		      		urlRequest.contentType = "application/xml";
		      }

		      if (this._onComplete != null) {
		      	loader.addEventListener(Event.COMPLETE, this._onComplete);
		      	/* loader.resultFormat = "e4x"; */
		      }

			  loader.load ( urlRequest );


		    } catch (e:Error) {
		      Trace.error(e.message);
		    }
		}

		public function get url():String {
        	return this._url;
        }

        public function set url(value:String):void {
        	this._url = value;
        }


		private function configureListeners(dispatcher:IEventDispatcher):void {
            /* dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler); */
        }

        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            Trace.info("completeHandler: " + loader.data);
        }

        private function openHandler(event:Event):void {
            Trace.info("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            Trace.info("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            Trace.info("securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            Trace.info("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            Trace.info("ioErrorHandler: " + event);
        }



	}
}