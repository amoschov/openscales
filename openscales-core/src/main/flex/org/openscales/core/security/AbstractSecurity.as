package org.openscales.core.security
{
	import org.openscales.core.Map;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.security.events.SecurityEvent;


	/**
	 * Base abstract class for all securities
	 */
	public class AbstractSecurity implements ISecurity
	{
		/**
		 * Map used to dispatch events
		 */
		private var _map:Map = null;
		
		/**
		 * Proxy eventually used to auhtenticate
		 */ 
		private var _proxy:String = null;

		public function AbstractSecurity(map:Map)
		{
			this._map = map;
			this.initialize();
		}

		public function initialize():void {
			map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_INITIALIZED, this));
		}

		public function update():void {
			map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_UPDATED, this));
		}

		public function get securityParameter():String
		{
			return null;
		}

		public function get map():Map {
			return this._map;
		}

		public function set map(value:Map):void {
			this._map = value;
		}
		
		public function get proxy():String {
			return this._proxy;
		}
		
		public function set proxy(value:String):void {
			this._proxy = value;
		}



	}
}

