package org.openscales.core.layer.ogc.params
{
	import org.openscales.core.basetypes.maps.HashMap;
		
	
	internal class OGCParams 
	{
		
		private var _service:String;
		private var _version:String;
		private var _request:String;
		private var _srs:String;
		private var _bbox:String;

		
		private var _additionalParams:HashMap = null;
		
		
		public function OGCParams(service:String, version:String, request:String) {
			this._service = service;
			this._version = version;
			this._request = request;
			
			_additionalParams = new HashMap();
			
			_srs = "EPSG:4326";
		}
		
		
		public function toGETString():String {
			var str:String = "";
			
			if (this._service != null)
				str += "SERVICE=" + this._service + "&";
				
			if (this._version != null)
				str += "VERSION=" + this._version + "&";
				
			if (this._request != null)
				str += "REQUEST=" + this._request + "&";
				
			if (this._srs != null)
				str += "SRS=" + this._srs + "&";
				
			if (this._bbox != null)
				str += "BBOX=" + this._bbox + "&";
				
			var keys:Array = _additionalParams.getKeys();
			for (var i:Number=0; i < keys.length; i++) {
				var key:String = keys.pop();
				var value:String = _additionalParams.getValue(key);
				
				str += key + "=" + value + "&";
			}
				
			return str;
		}
		
		//Getters and setters
		public function get service():String {
			return _service;
		}

		public function set service(service:String):void {
			_service = service;
		}

		public function get version():String {
			return _version;
		}

		public function set version(version:String):void {
			_version = version;
		}

		public function get request():String {
			return _request;
		}

		public function set request(request:String):void {
			_request = request;
		}

		public function get srs():String {
			return _srs;
		}

		public function set srs(srs:String):void {
			_srs = srs;
		}

		public function get bbox():String {
			return _bbox;
		}

		public function set bbox(bbox:String):void {
			_bbox = bbox;
		}
		
		public function setAdditionalParam(key:String, value:String):void {
			_additionalParams.put(key, value);
		}
	}
}