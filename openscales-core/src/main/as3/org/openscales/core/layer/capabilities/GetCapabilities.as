package org.openscales.core.layer.capabilities
{
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Request;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.maps.HashMap;
	
	/**
	 * Class to request Capabilities to a given server.
	 */
	public class GetCapabilities
	{
		private const VERSIONS:Array = new Array("1.1.0","1.0.0");
		private const PARSERS:Array = new Array(WFS110, WFS100);
		
		private var versionsToUse:Array = null;
		private var parsersToUse:Array = null;
		
		private var _service:String = null;
		private var _version:String = null;
		private var _request:String = null;
		private var _url:String = null;
		private var _proxy:String = null;
		
		private var _parser:CapabilitiesParser = null;
		
		private var _capabilities:HashMap = null;
		
		private var _requested:Boolean = false;
		
		private var _cbkFunc:Function = null;
		
		private var _use100:Boolean = true;
		
		private var _use110:Boolean = true;
		
		/**
		 * Class contructor
		 */
		public function GetCapabilities(service:String, url:String, cbkFunc:Function=null, use100:Boolean=true,
										use110:Boolean=true, proxy:String = null)
		{			
			this._service = service.toUpperCase();
			this._url = url;
			this._request = "GetCapabilities";
			this._capabilities = new HashMap(false)
			this._proxy = proxy;
			
			this._cbkFunc = cbkFunc;
			
			this.versionsToUse = [];
			this.parsersToUse = []
			
			this.use110 = use110;
			this.use100 = use100;
			
			this.requestCapabilities();
			
		}
		
		/**
		 * Method which will request the capabilities
		 * 
		 * @param failedVersion The last WFS version protocol requested unsuported by the server
		 * @return If the server was requested
		 */
		private function requestCapabilities(failedVersion:String = null):Boolean{
			
			if (this._service != "WFS" && this._service != "WMS"){
				Trace.error("Bad service for GetCapabilities: " + this._service);
				return false;
			}
			
			if (this._url == null) {
				Trace.error("GetCapabilities: URL must not be null");
				return false;
			}
			
			if (this._service == "WFS") {
				var foundVersion:Boolean = false;
				var i:Number = -1;
				while (!foundVersion && i < versionsToUse.length) {
					i += 1;
					if (failedVersion != null && versionsToUse[i] != failedVersion) {
						foundVersion = true;
					}
					else if (failedVersion == null) {
						foundVersion = true;
					}
				}
				
				if (!foundVersion) {
					Trace.error("GetCapabilities: Not found server compatible version");
					return false;
				}
				else {
					var parser:Class = parsersToUse[i];
					this._parser = new parser;
					this._version = versionsToUse[i];
				}
			}
			else if (this._service == "WMS") {
				Trace.warning("WMS parser not implemented yet");
				return false;
			}
			
			var urlRequest:String = this.buildRequestUrl(); 
			
			new Request(urlRequest, URLRequestMethod.GET, this.parseResult, null, null, this._proxy);
                      
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
		
		public function set proxy(value:String):void {
			this._proxy = value;
		}
		
		public function get proxy():String {
			return this._proxy;
		}
		
		public function set use100(value:Boolean):void {
			this._use100 = value;
			if (value) {
				var index:Number = VERSIONS.indexOf("1.0.0");
				if(index >= 0) {
					this.versionsToUse.push(VERSIONS[index]);
					this.parsersToUse.push(PARSERS[index]);
				}
			}
		}
		
		public function set use110(value:Boolean):void {
			this._use110 = value;
			if (value) {
				var index:Number = VERSIONS.indexOf("1.1.0");
				if(index >= 0) {
					this.versionsToUse.push(VERSIONS[index]);
					this.parsersToUse.push(PARSERS[index]);
				}
			}
		}
		

	}
}