/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/geometry/Envelope.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.geometry {
	import org.opengis.referencing.crs.ICoordinateReferenceSystem;
	import org.opengis.geometry.IDirectPosition;

	/**
	 * A minimum bounding box or rectangle. Regardless of dimension, an Envelope can be represented
	 * without ambiguity as two direct positions (coordinate points). To encode an Envelope, it is
	 * sufficient to encode these two points. This is consistent with all of the data types in this
	 * specification, their state is represented by their publicly accessible attributes.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IEnvelope {

		/**
		 * Returns the envelope coordinate reference system, or null if unknown. If non-null, it shall
		 * be the same as lower corner and upper corner CRS.
		 *
		 * @return The envelope CRS, or null if unknown.
		 */
		function get coordinateReferenceSystem():ICoordinateReferenceSystem;

		/**
		 * The length of coordinate sequence (the number of entries) in this envelope. Mandatory even
		 * when the coordinate reference system is unknown.
		 *
		 * @return The dimensionality of this envelope.
		 */
		function get dimension():Number;

		/**
		 * A coordinate position consisting of all the minimal ordinates for each
		 * dimension of all the points within the Envelope.
		 *
		 * @return The lower corner.
		 */
		function get lowerCorner():IDirectPosition;

		/**
		 * A coordinate position consisting of all the maximal ordinates for each
		 * dimension of all the points within the Envelope.
		 *
		 * @return The upper corner.
		 */
		function get upperCorner():IDirectPosition;

		/**
		 * Return the minimal ordinate along the specified dimension. This is a shortcut for the
		 * following without the cost of creating a temporary DirectPosition object:<ul>
		 * <li>lowerCorner.ordinate(dimension)</li></ul>
		 *
		 * @param dimension The dimension for which to obtain the ordinate value.
		 *
		 * @return The minimal ordinate at the given dimension.
		 *
		 * @throws MismatchedDimensionError If the given index is negative or is equals or greater than
		 *                                  the envelope dimension.
		 */
		function getMinimum(dimension:Number):Number;

		/**
		 * Return the maximal ordinate along the specified dimension. This is a shortcut for the
		 * following without the cost of creating a temporary DirectPosition object:<ul>
		 * <li>upperCorner.ordinate(dimension)</li></ul>
		 *
		 * @param dimension The dimension for which to obtain the ordinate value.
		 *
		 * @return The maximal ordinate at the given dimension.
		 *
		 * @throws MismatchedDimensionError If the given index is negative or is equals or greater than
		 *                                  the envelope dimension.
		 */
		function getMaximum(dimension:Number):Number;

		/**
		 * Return the median ordinate along the specified dimension. The result should be equals (minus
		 * rounding error) to:<ul>
		 * <li>(getMinimum(dimension) + getMaximum(dimension)) / 2</li></ul>
		 *
		 * @param dimension The dimension for which to obtain the ordinate value.
		 *
		 * @return The median ordinate at the given dimension.
		 *
		 * @throws MismatchedDimensionError If the given index is negative or is equals or greater than
		 *                                  the envelope dimension.
		 */
		function getMedian(dimension:Number):Number;

		/**
		 * Return the envelope span (typically width or height) along the specified dimension. The
		 * result should be equals (minus rounding error) to:<ul>
		 * <li>getMaximum(dimension) - getMinimum(dimension)</li></ul>
		 *
		 * @param dimension The dimension for which to obtain the ordinate value.
		 *
		 * @return The span (typically width or height) at the given dimension.
		 *
		 * @throws MismatchedDimensionError If the given index is negative or is equals or greater than
		 * the envelope dimension.
		 */
		function getSpan(dimension:Number):Number;
	}

}
