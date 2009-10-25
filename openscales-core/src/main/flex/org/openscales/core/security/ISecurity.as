package org.openscales.core.security
{
	import org.openscales.core.layer.Layer;

	/**
	 * Represent a security mecanism that will use remote services to authenticate and retreive a token.
	 * Secured layer will use the security parameter to request their data.
	 */
	public interface ISecurity
	{
		/**
		 * Intialize this security, and dispatch a SecurityEvent.SECURITY_INITIALIZED event
		 */
		function initialize():void;

		/**
		 * Update this security, and dispatch a SecurityEvent.SECURITY_UPDATED event
		 */
		function update():void;
		
		/**
		 * Logout and dispatch a SecurityEvent.SECURITY_LOGOUT event
		 */
		function logout():void;

		/**
		 * Return the string that will be appended to the request in order to make it autenticated
		 */
		function get securityParameter():String;

	}
}

