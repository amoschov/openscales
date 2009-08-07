package org.openscales.core.events
{
	import flash.system.Security;
	
	/**
	 * event related to the Security
	 * @author DamienNda 
	 **/
	public class SecurityEvent extends OpenScalesEvent
	{
		/**
		 * The type of security requester which dispatching the event
		 * private
		 * */
		private var  _securityType:String;
		/**
		 *To know if the layers concerned by the security are allowed to download
		 * @private 
		 **/
		private var _isAuthorized:Boolean;
		
		public static const LOAD_CONF_END:String="openscales.loadconfend";
		public static const SECURITY_LOAD:String="security.load";
		
		public function SecurityEvent(type:String,securityType:String,isauthorized:Boolean,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			this._securityType=securityType;
			this._isAuthorized=isauthorized;
			super(type, bubbles, cancelable);
		}
		/**
		 * The type of security requester which dispatching the event
		 * */
		public function get securityType():String{
			return this._securityType;
		}
		/**
		 * private
		 **/
		public function set securityType(value:String):void{
			this._securityType=value;
		}
		/**
		 *To know if the layers concerned by the security are allowed to download
		 **/
		public function get isAuthorized():Boolean{
			return this._isAuthorized;
		}
		/**
		  * @private 
		  **/
		public function set isAuthorized(value:Boolean):void{
			this._isAuthorized=value;
		}
	}
}