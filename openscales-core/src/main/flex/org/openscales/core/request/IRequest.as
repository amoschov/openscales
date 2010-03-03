package org.openscales.core.request {

	/**
	 * This interface is intended to hide different ways of requesting data
	 * behind a common interface that will be used, for instance, by layers to
	 * request data or by a geocoding form to define a position.
	 **/
	public interface IRequest {

		/**
		 * Destroy the request.
		 */
		function destroy():void;
		
		/**
		 * Send the request.
		 */
		function send():void;

	}
}

