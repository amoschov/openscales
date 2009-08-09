package org.openscales.core.request {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.openscales.core.Trace;
	import org.openscales.core.security.ISecurity;
	/**
	 * DisplayRequest is used to download binary data available from an URL, like picture
	 */
	public class DataRequest implements IRequest {
		
		/**
		 * Create a new Request to download data like images
		 * 
		 * @param url URL of the data to download, for example http://server/dir/image123.png
		 * @param proxy If a proxy (server side script) is used to avoid cross domain issues, specify its address here, for example http://server/proxy.php?url= 
		 * @param onComplete Function called when the data has been downloaded
		 * @param onFailure Function called of an error occured
		 */
		public function DataRequest(url:String, onComplete:Function=null, proxy:String = null, security:ISecurity = null, onFailure:Function=null) {
			try {
				this._loader = new Loader();
				this._loader.name=url;
				this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete,false, 0, true);
				if(onFailure!=null) {
					this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onFailure, false, 0, true);
				}
				var finalUrl:String = url;
				
		      	if(security != null) {
			      	if(url.indexOf("?") == -1) {
			      		// No ? in the url, will have to add it	
			      		finalUrl = url + "?" + security.securityParameter;
			      	} else {
			      		// There is already a ? in the url
			      		finalUrl = url + "&" + security.securityParameter;
			      	}
		      	}		      

				if(proxy!=null) {
					finalUrl = proxy + encodeURIComponent(finalUrl);
				}
				
				this._loader.load(new URLRequest(finalUrl));
			} catch (e:Error) {
		    	Trace.error(e.message);
		    }
		}
		
		/**
		 * Loader to download to content of the remote URL
		 */
		private var _loader:Loader = null;
		
		public function get loader():Loader {
	    	return this._loader;
	    }
	}
}