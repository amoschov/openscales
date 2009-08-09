package org.openscales.core.security.sample
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.core.request.XMLRequest;
	import org.openscales.core.security.AbstractSecurity;
	import org.openscales.core.security.events.SecurityEvent;
	
	public class SampleSecurity extends AbstractSecurity
	{
		private var _token:String = null;		
		private var _login:String = null;
		private var _password:String = null;
		private var _timer:Timer = null;

		public function SampleSecurity(map:Map, login:String, password:String) {
			this.login = login;
			this.password = password;
			this._timer = new Timer(10000);
			this._timer.addEventListener(TimerEvent.TIMER, updateHandler);

			super(map);
		}
		
		/**
		 * Make a fake request to openscales.org to simulate authentication
		 */
		override public function initialize():void {
			new XMLRequest(this.authUrl, authenticationResponse, this.map.proxy);
		}
		
		/**
		 * Fake init callback
		 */
		private function authenticationResponse(e:Event):void {
			this.token = Math.floor(Math.random()*1000).toString();
			map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_INITIALIZED, this));
			this._timer.start();
		}
		
		private function get authUrl():String {
			// Random to avoid cache
			return "http://www.openscales.org?login" + this.login + "&password=" + this.password + "&random=" + Math.random().toString();
		}
		
		private function updateHandler(e:TimerEvent):void {
			update();
		}
		
		override public function update():void {
			new XMLRequest(this.authUrl, authenticationUpdateResponse, this.map.proxy);
		}
		
		/**
		 * Fake update callback
		 */
		private function authenticationUpdateResponse(e:Event):void {
			this.token = Math.floor(Math.random()*1000).toString();
			map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_UPDATED, this));
		}	
		
		override public function get securityParameter():String {
			return "token=" + this.token;
		}
		
		public function get token():String {
			return this._token;
		}
		
		public function set token(value:String):void {
			this._token = value;
		}
		
		public function get login():String {
			return this._login;
		}
		
		public function set login(value:String):void {
			this._login = value;
		}
		
		public function get password():String {
			return this._password;
		}
		
		public function set password(value:String):void {
			this._password = value;
		}

	}
}