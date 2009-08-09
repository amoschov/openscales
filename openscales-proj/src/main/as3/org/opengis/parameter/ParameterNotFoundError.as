/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/parameter/ParameterNotFoundException.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.parameter {

	/**
	 * Thrown when a required parameter was not found in a parameter group.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class ParameterNotFoundError extends Error {

		/**
		 * The parameter's name.
		 */
		private var _parameterName:String=null;

		/**
		 * Create an exception with the specified message and parameter name.
		 *
		 * @param message the error message.
		 * @param int the error number.
		 */
		public function ParameterNotFoundError(paramName:String, message:String="", id:int=0) {
			super(message, id);
			this._parameterName=paramName;
		}

		/**
		 * Return the parameter's name.
		 *
		 * @return The parameter's name.
		 */
		public function get parameterName():String {
			return this._parameterName;
		}

	}

}
