/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/FactoryException.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing {

	/**
	 * Thrown when a factory can't create an instance of the requested object. It may be a failure to
	 * create a datum, a coordinate system, a reference system or a coordinate operation. If the failure
	 * is caused by an illegal authority code, then the actual exception should be
	 * NoSuchAuthorityCodeError. Otherwise, if the failure is caused by some error in the underlying
	 * database, then this cause should be specified.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class FactoryError extends Error {

		/**
		 * Creates an error.
		 *
		 * @param message the error message.
		 * @param int the error number.
		 */
		public function FactoryError(message:String="", id:int=0) {
			super(message, id);
		}

	}

}
