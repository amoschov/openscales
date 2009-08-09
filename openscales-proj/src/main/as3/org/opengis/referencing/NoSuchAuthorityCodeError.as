/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/NoSuchAuthorityCodeException.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing {

	/**
	 * Thrown when an authority factory can't find the requested authority code.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class NoSuchAuthorityCodeError extends Error {

		/**
		 * The authority.
		 * @private
		 */
		private var _authority:String=null;

		/**
		 * The code.
		 * @private
		 */
		private var _code:String=null;

		/**
		 * Creates an error with the specified detail message and authority code.
		 *
		 * @param aut the authority.
		 * @param cod the code.
		 * @param message the error message.
		 * @param int the error number.
		 */
		public function NoSuchAuthorityCodeError(aut:String, cod:String, message:String="", id:int=0) {
			super(message, id);
			this._authority=aut;
			this._code=cod;
		}

		/**
		 * Return the authority.
		 *
		 * @return the authority.
		 */
		public function get authority():String {
			return this._authority;
		}

		/**
		 * Return the code.
		 *
		 * @return the code.
		 */
		public function get code():String {
			return this._code;
		}

	}

}
