package org.openscales.core.layer.capabilities
{
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Map;
	import org.openscales.core.Request;
	import org.openscales.core.basetypes.maps.HashMap;
	
	/**
	 * Class to request Capabilities to a given server.
	 */
	public class GetCapabilities
	{
		private const VERSIONS:Array = new Array("1.1.0","1.0.0");
		private const PARSERS:Array = new Array(WFS110, WFS100);
		
		private var _service:String = null;
		private var _version:String = null;
		private var _request:String = null;
		private var _url:String = null;
		
		private var _parser:CapabilitiesParser = null;
		
		private var _capabilities:HashMap = null;
		
		private var _requested:Boolean = false;
		
		private var _cbkFunc:Function = null;
		
		/**
		 * Class contructor
		 */
		public function GetCapabilities(service:String, url:String, cbkFunc:Function=null)
		{
						
			this._service = service.toUpperCase();
			this._url = url;
			this._request = "GetCapabilities";
			this._capabilities = new HashMap(false);
			
			this._cbkFunc = cbkFunc;
			
			this.requestCapabilities();
			
		}
		
	
		private function requestCapabilities(failedVersion:String = null):Boolean{
			
			if (this._service != "WFS" && this._service != "WMS"){
				trace("Bad service for GetCapabilities: " + this._service);
				return false;
			}
			
			if (this._url == null) {
				trace("GetCapabilities: URL must not be null");
				return false;
			}
			
			if (this._service == "WFS") {
				var foundVersion:Boolean = false;
				var i:Number = -1;
				while (!foundVersion && i < VERSIONS.length) {
					i += 1;
					if (failedVersion != null && VERSIONS[i] != failedVersion) {
						foundVersion = true;
					}
					else if (failedVersion == null) {
						foundVersion = true;
					}
				}
				
				if (!foundVersion) {
					trace("GetCapabilities: Not found server compatible version");
					return false;
				}
				else {
					var parser:Class = PARSERS[i];
					this._parser = new parser;
					this._version = VERSIONS[i];
				}
			}
			else if (this._service == "WMS") {
				trace("WMS parser not implemented yet");
				return false;
			}
			
			var urlRequest:String = this.buildRequestUrl(); 
			
			new Request(urlRequest,
                     {   method: URLRequestMethod.GET, 
                         parameters: null,
                         onComplete: this.parseResult
                      }, Map.proxy);
                      
			return true;
		}
		
		/**
		 * Method to build the request url
		 * 
		 * @return The builded url with needed parameters
		 */
		private function buildRequestUrl():String {
			var url:String = this._url;
			
			if(!url.charAt(url.length - 1) != "?") {
				url += "?";
			}
			
			url += "REQUEST=" + this._request;
			url += "&VERSION=" + this._version;
			url += "&SERVICE=" + this._service;
			
			return url;
		}
		
		/**
		 * Callback method after GetCapabilities request
		 */
		private function parseResult(event:Event):void {
			var loader:URLLoader = event.target as URLLoader;
			var doc:XML =  new XML(loader.data);
			
			if (doc.@version != this._version) {
				this.requestCapabilities(doc.@version);
			}
			
			this._capabilities = this._parser.read(doc);
			this._requested = true;
						
			if (this._cbkFunc != null) {
				this._cbkFunc.call(this,this);
			}
			
			
		}
		
		/**
		 * Returns the capabilities HashMap representation of the specified layer name
		 * 
		 * @param layerName The layer's name
		 * @return An HashMap containing the capabilities of requested layer
		 */
		public function getLayerCapabilities(layerName:String):HashMap {
		
			return this._capabilities.getValue(layerName);
		}
		
		/**
		 * Returns all the capabilities (i.e. all layers or features available and their properties) of the
		 * requested server.
		 * 
		 * @return An HashMap containing capabilities of all layers available on the server
		 */
		public function getAllCapabilities():HashMap {

			return this._capabilities;
		}
		

	}
}