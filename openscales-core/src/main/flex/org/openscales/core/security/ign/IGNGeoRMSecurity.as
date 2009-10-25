package org.openscales.core.security.ign
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.request.XMLRequest;
	import org.openscales.core.security.AbstractSecurity;
	import org.openscales.core.security.events.SecurityEvent;

	/**
	 * IGN GeoRM security implementation.
	 * This module will retreive an GeoRM token in order to be able to request protected datas
	 * Documentation is available at https://api.ign.fr/geoportail/api/doc/index.html 
	 */
	public class IGNGeoRMSecurity extends AbstractSecurity
	{
		
		/** Host used to retreive the token **/
		private var _host:String = "http://jeton-api.ign.fr";
		
		/** Security parameter name, the value will be the token retreived from the server **/		
		private var _securityParameterName:String = "gppkey";
		
		/** 
		 * The key that will identify you. You have to create your own key for your own domain
		 * on https://api.ign.fr
		 */
		private var _key:String = null;
		
		/**
		 * The token returned by the GeoRM. It will be appended as a parameter to data request.
		 */
		private var _token:String = null;		
		
		/**
		 * Timer used to request token updates
		 */
		private var _timer:Timer = null;
		
		/**
		 * Time to live of the token in milliseconds. Default to 10 minutes.
		 */
		private var _ttl:int = 600000;
		

		public function IGNGeoRMSecurity(map:Map, key:String, proxy:String = null, host:String = null) {
			if(host)
				this.host = host;
			if(proxy)
				this.proxy = proxy;
			this.key = key;
			this._timer = new Timer(this.ttl);
			this._timer.addEventListener(TimerEvent.TIMER, updateHandler);

			super(map);
		}
		
		/**
		 * Authenticate and retreive config to print it in logs
		 */
		override public function initialize():void {
			new XMLRequest(this.authUrl, authenticationResponse, this.proxy);
			new XMLRequest(this.configUrl, configResponse, this.proxy);
		}
		
		/**
		 * Authentication asynchronous response
		 */
		private function authenticationResponse(e:Event):void {
			var loader:URLLoader = e.target as URLLoader;
			var doc:XML =  new XML(loader.data);
			this.token = doc.toString();
			map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_INITIALIZED, this));
			this._timer.start();	
		}
		
		/**
		 * Config asynchronous response
		 */
		private function configResponse(e:Event):void {
			var loader:URLLoader = e.target as URLLoader;
			var doc:XML =  new XML(loader.data);
			Trace.info(doc.toString());
		}

		/** Return authentication URL, use random parameter to avoid caching **/
		private function get authUrl():String {
			return this.host + "/getToken?key=" + this.key + "&output=xml&random=" + Math.random().toString();		
		}
		
		/** Return config URL, use random parameter to avoid caching  **/
		private function get configUrl():String {
			return this.host + "/getConfig?key=" + this.key + "&output=xml";			
		}
		
		/** Return update URL, use random parameter to avoid caching  **/
		private function get updateUrl():String {
			return this.host + "/getToken?gppkey=" + this.token + "&output=xml&random=" + Math.random().toString();
		}
		
		/** Return release URL, use random parameter to avoid caching  **/
		private function get releaseUrl():String {
			return this.host + "/release?gppkey=" + this.token + "&output=xml&random=" + Math.random().toString();
		}
		
		private function updateHandler(e:TimerEvent):void {
			update();
		}

		override public function update():void {
			new XMLRequest(this.updateUrl, authenticationUpdateResponse, this.proxy);
		}

		/**
		 * Authentication update asynchronous response
		 */
		private function authenticationUpdateResponse(e:Event):void {
			var loader:URLLoader = e.target as URLLoader;
			var doc:XML =  new XML(loader.data);
			this.token = doc.toString();
			map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_UPDATED, this));			
		}	
		
		override public function get securityParameter():String {
			return this.securityParameterName + "=" + this.token;
		}
		
		override public function logout():void {
			new XMLRequest(this.releaseUrl, authenticationLogoutResponse, this.proxy);
		}
		
		/**
		 * Authentication release asynchronous response
		 */
		private function authenticationLogoutResponse(e:Event):void {
			map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_LOGOUT, this));
			Trace.info("token " + this._key + " released");
		}
		
		public function get host():String {
			return this._host;
		}
		
		public function set host(value:String):void {
			this._host = value;
		}

		public function get key():String {
			return this._key;
		}

		public function set key(value:String):void {
			this._key = value;
		}
		
		public function get token():String {
			return this._token;
		}
		
		public function set token(value:String):void {
			this._token = value;
		}
		
		public function get securityParameterName():String {
			return this._securityParameterName;
		}
		
		public function set securityParameterName(value:String):void {
			this._securityParameterName = value;
		}		
		
		public function get ttl():int {
			return this._ttl;
		}
		
		public function set ttl(value:int):void {
			this._ttl = value;
			this._timer = new Timer(value);
			this._timer.addEventListener(TimerEvent.TIMER, updateHandler);
		}
		
	}
}

