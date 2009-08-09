/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/operation/NoninvertibleTransformException.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.operation {

	/**
	 * Thrown when IMathTransform.inverse() is invoked but the transform can't be inverted.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class NonInvertibleTransformError extends Error {

		/**
		 * Creates an error.
		 *
		 * @param message the error message.
		 * @param int the error number.
		 */
		public function NonInvertibleTransformError(message:String="", id:int=0) {
			super(message, id);
		}

	}

}
