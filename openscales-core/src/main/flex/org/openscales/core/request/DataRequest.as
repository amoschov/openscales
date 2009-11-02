package org.openscales.core.request {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Bitmap;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.system.LoaderContext;
	
	import org.openscales.core.Trace;
	import org.openscales.core.security.ISecurity;
	/**
	 * DisplayRequest is used to download binary data available from an URL, like picture
	 */
	public class DataRequest extends AbstractRequest {

		/**
		 * Loader to download to content of the remote URL
		 */
		private var _loader:Loader = null;

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
				this._onComplete = onComplete;
				this._onFailure = onFailure;

				this._loader.name=url;
				this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete,false, 0, true);
				if(onFailure != null) {
					this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onFailure, false, 0, true);
				}
				var finalUrl:String = url;

				if(security != null) {
					
					if(!security.initialized) {
						// A redraw will be called on the layer when a SecurityEvent.SECURITY_INITIALIZED will be dispatched 
						Trace.info("Security not initialized so cancel request");
						return;	
					}
					if(url.indexOf("?") == -1) {
						// No ? in the url, will have to add it	
						finalUrl = url + "?" + security.securityParameter;
					} else {
						// There is already a ? in the url
						finalUrl = url + "&" + security.securityParameter;
					}
				}		      

				if ((proxy != null) && (proxy != "")) {
					finalUrl = proxy + encodeURIComponent(finalUrl);
				}
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.checkPolicyFile = true;
				//Trace.debug(finalUrl);
				this._loader.load(new URLRequest(finalUrl),loaderContext);
				
			} catch (e:Error) {
				Trace.error(e.message);
			}
		}

		override public function destroy():void {
			
			if((this._onComplete != null) && (this.loader))
				this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this._onComplete);

			if((this._onFailure != null) && (this.loader))
				this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this._onFailure);
				
			
			try {
				this.loader.close();
			} catch(e:Error){
				// Empty catch are generally evil, but it is right in this case
			};
			
			this._loader = null;
		}



		public function get loader():Loader {
			return this._loader;
		}
	}
}

