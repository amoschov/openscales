package org.openscales.core.request
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Trace;
	import org.openscales.core.security.ISecurity;

	public class XMLRequest extends AbstractRequest {
	
		private var _loader:URLLoader = null;
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
		public function XMLRequest(url:String, onComplete:Function, proxy:String = null, method:String = URLRequestMethod.GET, security:ISecurity = null, onFailure:Function = null, postBody:Object = null) {
			try {
		      
		      Trace.info(url);
		      
		      if(security != null) {
		      	if(url.indexOf("?") == -1) {
		      		// No ? in the url, will have to add it	
		      		url = url + "?" + security.securityParameter;
		      	} else {
		      		// There is already a ? in the url
		      		url = url + "&" + security.securityParameter;
		      	}
		      }		      
		      
		      if ((proxy != null) && (proxy != "")) {
		      	url = proxy + encodeURIComponent(url);
		      }
		      this._loader = new URLLoader();

		      var urlRequest:URLRequest = new URLRequest(url);
		      urlRequest.method = method;

			  if (method == URLRequestMethod.POST) {
		      		urlRequest.data = postBody;
		      		urlRequest.contentType = "application/xml";
		      }

		      if (onComplete != null) {
		      	_loader.addEventListener(Event.COMPLETE, onComplete);
		      }
		      
		      if(onFailure != null) {
		      	_loader.addEventListener(IOErrorEvent.IO_ERROR, onFailure);
		      	_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFailure);
		      }
		      
			  _loader.load ( urlRequest );

		    } catch (e:Error) {
		      Trace.error(e.message);
		    }
		}
		
		override public function destroy():void {
			try {
	        	this.loader.close();
	        } catch(e:Error){
	        	// Empty catch are generally evil, but it is right in this case
	        };
	        
	        if(this._onComplete != null)
	        	this.loader.removeEventListener(Event.COMPLETE, this._onComplete);
	        
	        if(this._onFailure != null)
	        	this.loader.removeEventListener(IOErrorEvent.IO_ERROR, this._onFailure);
		}
		
		public function get loader():URLLoader {
	    	return this._loader;
	    }

	}
}