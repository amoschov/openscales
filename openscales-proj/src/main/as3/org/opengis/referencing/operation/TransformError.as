/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/operation/TransformException.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.operation {
	import org.opengis.referencing.operation.IMathTransform;

	/**
	 * Common superclass for a number of transformation-related exceptions. TransformError are thrown
	 * by IMathTransform  when a coordinate transformation can't be inverted
	 * (NoninvertibleTransformError), when the derivative can't be computed or when a coordinate can't
	 * be transformed. It is also thrown when ICoordinateOperationFactory fails to find a path between
	 * two coordinate reference systems.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class TransformError extends Error {

		/**
		 * The last transform that either transformed successfuly all coordinates, or filled the
		 * untransformable coordinates with NaN values.
		 */
		private var _lastCompletedTransform:IMathTransform=null;

		/**
		 * Creates an exception.
		 *
		 * @param message the error message.
		 * @param int the error number.
		 */
		public function TransformError(message:String="", id:int=0) {
			super(message, id);
		}

		/**
		 * Return the last transform that either transformed successfuly all coordinates, or filled the
		 * untransformable coordinates with NaN values. This information is useful in the context of
		 * concatenated transforms. May be null if unknown.
		 *
		 * @return The last reliable transform.
		 */
		public function get lastCompletedTransform():IMathTransform {
			return this._lastCompletedTransform;
		}

		/**
		 * Set the last transform that either transformed successfuly all coordinates, or filled the
		 * untransformable coordinates with NaN values.
		 *
		 * @param transform The last reliable transform.
		 */
		public function set lastCompletedTransform(transform:IMathTransform):void {
			this._lastCompletedTransform=transform;
		}

	}

}
