package org.openscales.core.layer.capabilities
{
	
	import flash.events.Event;
	import flash.net.URLLoader;
	
	import org.openscales.core.OpenScales;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.WFS;
	
	/**
	 * Class to request Capabilities to a given server.
	 */
	public class GetCapabilities
	{
		
		private var _service:String = null;
		private var _version:String = null;
		private var _request:String = null;
		private var _url:String = null;
		
		private var _layer:Layer = null;
		
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
		
	
		private function requestCapabilities():Boolean{
			
			if (this._service != "WFS" && this._service != "WMS"){
				trace("Bad service for GetCapabilities: " + this._service);
				return false;
			}
			
			if (this._url == null) {
				trace("GetCapabilities: URL must not be null");
				return false;
			}
			
			if (this._service == "WFS") {
				this._parser = new WFS100();
				this._version = this._parser.version;
			}
			else if (this._service == "WMS") {
				trace("WMS parser not implemented yet");
				return false;
			}
			
			var urlRequest:String = this.buildRequestUrl(); 
			
			OpenScales.loadURL(urlRequest,null,this,this.parseResult);
			
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

			this._capabilities = this._parser.read(doc);
			this._requested = true;
			
			if (this._layer != null) {
				if (this._service == "WFS") {
					(this._layer as WFS).capabilitiesGetter(this);
				}
				else if (this._service == "WMS") {
					trace("GetCapabilities: WMS GetCapabilites not implemented yet");
				}
			}
			
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