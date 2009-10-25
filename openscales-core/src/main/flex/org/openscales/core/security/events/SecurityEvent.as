package org.openscales.core.security.events
{

	import org.openscales.core.events.OpenScalesEvent;
	import org.openscales.core.security.ISecurity;

	/**
	 * event related to the Security
	 * @author DamienNda
	 **/
	public class SecurityEvent extends OpenScalesEvent
	{
		/**
		 * The type hat dispatch this event
		 * private
		 * */
		private var  _security:ISecurity;

		/**
		 * The security is initialized. Usually, this event is dispatched in the callback of the authentication URL
		 * The security service should be initialized
		 */
		public static const SECURITY_INITIALIZED:String="openscales.security.initialized";

		/**
		 * The security service is updated. Usually, this event is dispatched in the callback of the authentication URL
		 * used to update the authentication credentials.
		 */
		public static const SECURITY_UPDATED:String="openscales.security.updated";
		
		/**
		 * The security service is no more authenticated
		 */
		public static const SECURITY_LOGOUT:String="openscales.security.logout";

		public function SecurityEvent(type:String, security:ISecurity, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._security = security;
			super(type, bubbles, cancelable);
		}
		/**
		 * The type of security requester which dispatching the event
		 * */
		public function get security():ISecurity {
			return this._security;
		}
		/**
		 * private
		 **/
		public function set security(value:ISecurity):void{
			this._security=value;
		}

	}
}

