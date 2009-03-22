package org.openscales.core
{
	import mx.rpc.http.mxml.HTTPService;
	
	public class Responders
	{

		private var responders:Array = [];
		private static var activeRequestCount:int = 0;
		
		public function register(responderToAdd:Object):void {
			for (var i:int = 0; i < this.responders.length; i++)
				if (responderToAdd == this.responders[i])
					return;
			this.responders.push(responderToAdd);
		}
		
		public function dispatch(callback:String, request:RequestOL, transport:HTTPService, json:Object = null):void {
			for (var i:int = 0; i < this.responders.length; i++) {
				var responder:Object = this.responders[i];
				if (responder[callback] && typeof responder[callback] == 'function') {
					try {
						responder[callback].apply(responder, [request, transport, json]);
					} catch (e:Error) {}
				}
			}
		}
	   
		public function register1():void {
			register({onCreate: onCreateF, onComplete: onCompleteF});
		}
		
		public function onCreateF():void {
			RequestOL.activeRequestCount++;
		}
		
		public function onCompleteF():void {
			RequestOL.activeRequestCount--;
		}
	}
}