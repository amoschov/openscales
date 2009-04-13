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
	
	import org.openscales.core.Util;
	
	public class Request
	{
		public var options:Object = null;
		public static var activeRequestCount:int = 0;
		private var url:String = null;
		
		public function Request(url:String, options:Object, proxy:String = null):void {
			
			this.setOptions(options);
			this.request(url, proxy);
		}
		
		public function setOptions(options:Object):void {
			this.options = {
			  method:       URLRequestMethod.POST,
			  parameters:   ''
			}
			Util.extend(this.options, options || {});
		}

		
		private function request(url:String, proxy:String):void {
			var parameters:Object = this.options.parameters || '';
		
		    try {
		      var postBody:Object = null;
		      if (parameters) {
		    		postBody = parameters.postBody;
		      }
		      var body:Object= this.options.postBody ? this.options.postBody : postBody;
		      if (body) {
		      	this.options.method = URLRequestMethod.POST;
		      	if (parameters.BBOX) {
		      		var bbox:String = Util.getBBOXStringFromBounds(parameters.BBOX);
		      		body.*::Query.*::Filter.*::And.*::BBOX.*::Box.*::coordinates = bbox;
		      		url = url.split("?")[0];
		      	}
		      }
		      this.url = url;
		      trace(this.url);
		      if (this.options.method == URLRequestMethod.GET && parameters.length > 0)
		        this.url += (this.url.match(/\?/) ? '&' : '?') + parameters;
		
		      if (proxy != null) {
		      	this.url = proxy + encodeURIComponent(this.url);
		      }
		      var loader:URLLoader = new URLLoader();
			  configureListeners(loader);
			
		      var urlRequest:URLRequest = new URLRequest(this.url);
		      urlRequest.method = this.options.method;
				
			  if (this.options.method == URLRequestMethod.POST) {
		      		urlRequest.data = body;
		      		urlRequest.contentType = "application/xml";
		      }
		      
		      if (this.options.onComplete) {
		      	loader.addEventListener(Event.COMPLETE, this.options.onComplete);
		      	/* loader.resultFormat = "e4x"; */
		      }
			  
			  loader.load ( urlRequest );		      
		      
		
		    } catch (e:Error) {
		      trace(e.message);
		    }
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
            trace("completeHandler: " + loader.data);
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }

		
		
	}
}