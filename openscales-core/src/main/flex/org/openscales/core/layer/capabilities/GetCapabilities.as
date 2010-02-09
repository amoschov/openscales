package org.openscales.core.layer.capabilities
{

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.request.XMLRequest;

	/**
	 * Class to request Capabilities to a given server.
	 */
	public class GetCapabilities
	{
		private var _parsers:HashMap = null;

		private var _service:String = null;
		private var _version:String = null;
		private var _request:String = null;
		private var _url:String = null;
		private var _proxy:String = null;

		private var _parser:CapabilitiesParser = null;
		
		private var _capabilities:HashMap = null;

		private var _requested:Boolean = false;

		private var _cbkFunc:Function = null;

		/**
		 * Class contructor
		 */
		public function GetCapabilities(service:String, url:String, cbkFunc:Function=null, version:String="1.1.0", proxy:String = null)
		{			
			this._service = service.toUpperCase();
			this._url = url;
			this._request = "GetCapabilities";
			this._capabilities = new HashMap(false)
			this._parsers = new HashMap();

			_parsers.put("WFS 1.0.0",WFS100);
		    _parsers.put("WFS 1.1.0",WFS110);
		    _parsers.put("WMS 1.0.0",WMS100);
		    _parsers.put("WMS 1.1.0",WMS110);
		    _parsers.put("WMS 1.1.1",WMS111);				
				
			this._proxy = proxy;

			this._cbkFunc = cbkFunc;
			
			this._version = version;

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
			
			var parser:Class = _parsers.getValue(this._service + " " + version);
            this._parser = new parser;

			if (this._parser == null) 
			{
				Trace.error("GetCapabilities: Not found server compatible version");
				return false;
			}
			
			var urlRequest:String = this.buildRequestUrl(); 

			new XMLRequest(urlRequest, this.parseResult, this._proxy,URLRequestMethod.GET,null,this.onFailure);

			return true;
		}

		/**
		 * Method to build the request url
		 *
		 * @return The built url with needed parameters
		 */
		private function buildRequestUrl():String {
			var url:String = this._url;

			if(url.charAt(url.length - 1) != "?") {
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
			
			try
			{
				var doc:XML =  new XML(loader.data);
			}
			catch (error:Error) 
			{
			     trace("XML parse error");
			     onFailure(event);
			     return;
			}

            // this can cause "infinite loops" on 'buggy' WMS servers
			//if (doc.@version != this._version) {
			//	this.requestCapabilities(doc.@version);
			//}

			this._capabilities = this._parser.read(doc);
			this._requested = true;

			if (this._cbkFunc != null) {
				this._cbkFunc.call(this,this);
			}
		}
		
		/**
		 * onFailure handler for XMLRequest 
		 */
		private function onFailure(event:Event):void 
		{		
			// load of capabilities failed. return empty capabilities map
			Trace.error("Failed loading GetCapabilities XML request");
			this._capabilities = new HashMap();
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

		public function get version():String {
			return this._version;
		}
	}
}

