package org.openscales.core
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	public class RequestOL extends Base
	{
		
		public static var activeRequestCount:int = 0;
		private var url:String = null;
		
		public function RequestOL(url:String, options:Object, proxy:String = null):void {
			this.transport = getTransport();
			this.setOptions(options);
			this.request(url, proxy);
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
		      	this.options.method = "post";
		      	if (parameters.BBOX) {
		      		var bbox:String = Util.getBBOXStringFromBounds(parameters.BBOX);
		      		body.*::Query.*::Filter.*::And.*::BBOX.*::Box.*::coordinates = bbox;
		      		url = url.split("?")[0];
		      	}
		      }
		      this.url = url;
		      if (this.options.method == 'get' && parameters.length > 0)
		        this.url += (this.url.match(/\?/) ? '&' : '?') + parameters;
		
		      if (proxy != null) {
		      	this.url = proxy + encodeURIComponent(this.url);
		      }
		      trace(this.url);
		      this.transport.url = this.url;
		      
		      
		      this.transport.method = this.options.method;
		      
		      if (this.options.onComplete) {
		      	this.transport.addEventListener(ResultEvent.RESULT, this.options.onComplete);
		      	this.transport.resultFormat = "e4x";
		      }

		      if (this.options.method == "post") {
		      		this.transport.request = body;
		      		this.transport.contentType = "application/xml";
		      }
		      
		      this.transport.showBusyCursor = true;
			  this.transport.addEventListener(FaultEvent.FAULT, handleFault);
		      this.transport.send();
		
		    } catch (e:Error) {
		      this.dispatchException(e);
		    }
		}
		
		private function handleFault(event:FaultEvent):void {
			
		}
		private function getTransport():HTTPService {
			return new HTTPService();
		}
		
	}
}