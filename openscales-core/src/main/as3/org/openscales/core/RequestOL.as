package org.openscales.core
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class RequestOL
	{
		public var options:Object = null;
		public static var activeRequestCount:int = 0;
		private var url:String = null;
		
		public function RequestOL(url:String, options:Object, proxy:String = null):void {
			
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
		      if (this.options.method == URLRequestMethod.GET && parameters.length > 0)
		        this.url += (this.url.match(/\?/) ? '&' : '?') + parameters;
		
		      if (proxy != null) {
		      	this.url = proxy + encodeURIComponent(this.url);
		      }
		      
		      var loader:Loader = new Loader();
		      var urlRequest:URLRequest = new URLRequest(this.url);
		      urlRequest.method = this.options.method;
				
			  if (this.options.method == URLRequestMethod.POST) {
		      		urlRequest.data = body;
		      		urlRequest.contentType = "application/xml";
		      }
		      
			  loader.load ( urlRequest );		      
		      
		      if (this.options.onComplete) {
		      	loader.addEventListener(Event.COMPLETE, this.options.onComplete);
		      	/* loader.resultFormat = "e4x"; */
		      }
			  loader.addEventListener(IOErrorEvent.IO_ERROR, handleFault);
		
		    } catch (e:Error) {
		      this.dispatchException(e);
		    }
		}
		
		private function handleFault(event:IOErrorEvent):void {
			
		}
		
		
	}
}