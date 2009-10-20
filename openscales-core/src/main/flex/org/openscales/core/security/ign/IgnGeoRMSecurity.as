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

	public class IgnGeoRMSecurity extends AbstractSecurity
	{
		private var _key:String = null;
		private var _token:String = null;		
		private var _password:String = null;
		private var _timer:Timer = null;
		private var _initialized:Boolean = false;
		private var _proxy:String = null;

		public function IgnGeoRMSecurity(map:Map, key:String, proxy:String = null) {
			this.key = key;
			this.proxy = proxy;
			this._timer = new Timer(100000);
			this._timer.addEventListener(TimerEvent.TIMER, updateHandler);

			super(map);
		}

		override public function initialize():void {
			new XMLRequest(this.authUrl, authenticationResponse, this.proxy);
			new XMLRequest(this.configUrl, configResponse, this.proxy);
		}

		private function authenticationResponse(e:Event):void {
			var loader:URLLoader = e.target as URLLoader;
			var doc:XML =  new XML(loader.data);
			this.token = doc.toString();
			map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_INITIALIZED, this));
			this._timer.start();	
		}
		
		private function configResponse(e:Event):void {
			var loader:URLLoader = e.target as URLLoader;
			var doc:XML =  new XML(loader.data);
			Trace.info(doc.toString());
		}

		private function get authUrl():String {
			return "http://jeton-api.ign.fr/getToken?key=" + this.key + "&output=xml&random=" + Math.random().toString();		
		}
		
		private function get configUrl():String {
			return "http://jeton-api.ign.fr/getConfig?key=" + this.key + "&output=xml";			
		}
			
		private function get updateUrl():String {
			return "http://jeton-api.ign.fr/getToken?gppkey=" + this.token + "&output=xml&random=" + Math.random().toString();
		}

		private function updateHandler(e:TimerEvent):void {
			update();
		}

		override public function update():void {
			new XMLRequest(this.updateUrl+"", authenticationUpdateResponse, this.proxy);
		}

		private function authenticationUpdateResponse(e:Event):void {
			var loader:URLLoader = e.target as URLLoader;
			var doc:XML =  new XML(loader.data);
			this.token = doc.toString();
			map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_UPDATED, this));			
		}	

		override public function get securityParameter():String {
			return "gppkey=" + this.token;
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
		
		public function get initialized():Boolean {
			return this._initialized;
		}
		
		public function set initialized(value:Boolean):void {
			this._initialized = value;
		}
		
		public function get proxy():String {
			return this._proxy;
		}
		
		public function set proxy(value:String):void {
			this._proxy = value;
		}

	}
}

