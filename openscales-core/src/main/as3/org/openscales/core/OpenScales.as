package org.openscales.core
{
	import flash.net.URLRequestMethod;
	
	public class OpenScales
	{
		
		public static var ProxyHost:String;
		
		public static function loadURL(uri:String, params:Object, caller:Object, onComplete:Function = null, proxyIn:String = null):void {
			
			var proxy:String = null;
	        
	        if (proxyIn) {
	        	proxy = proxyIn;
	        } else if (OpenScales.ProxyHost && uri.indexOf("http") == 0) {
	            proxy = OpenScales.ProxyHost;
	        }
			
			var successorfailure:Function = onComplete;
			
			new RequestOL(uri,
                     {   method: URLRequestMethod.GET, 
                         parameters: params,
                         onComplete: successorfailure
                      }, proxy);
		}
		
	}
}