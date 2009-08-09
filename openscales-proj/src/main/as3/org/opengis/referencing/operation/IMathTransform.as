/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/operation/MathTransform.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.operation {
	import org.opengis.geometry.IDirectPosition;

	import org.opengis.geometry.MismatchedDimensionError;
	import org.opengis.referencing.operation.TransformError;

	/**
	 * Transforms multi-dimensional coordinate points. This interface transforms coordinate value for a
	 * point given in the source coordinate reference system to coordinate value for the same point in
	 * the target coordinate reference system. In a conversion, the transformation is accurate to within
	 * the limitations of the computer making the calculations. In a transformation, where some of the
	 * operational parameters are derived from observations, the transformation is accurate to within
	 * the limitations of those observations. If a client application wishes to query the source and
	 * target coordinate reference systems  of an operation, then it should keep hold of the
	 * ICoordinateOperation interface, and use the contained math transform object whenever it wishes to
	 * perform a transform.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IMathTransform {

		/**
		 * Gets the dimension of input points.
		 *
		 * @return The dimension of input points.
		 */
		function get sourceDimensions():Number;

		/**
		 * Gets the dimension of output points.
		 *
		 * @return The dimension of output points.
		 */
		function get targetDimensions():Number;

		/**
		 * Transforms a list of coordinate point ordinal values. This method is provided for efficiently
		 * transforming many points. The supplied array of ordinal values will contain packed ordinal
		 * values. For example, if the source dimension is 3, then the ordinals will be packed in this
		 * order: (x0,y0,z0, x1,y1,z1 ...).
		 *
		 * @param srcPts the array containing the source point coordinates.
		 * @param srcOff the offset to the first point to be transformed in the source array.
		 * @param dstPts the array into which the transformed point coordinates are returned.
		 * @param dstOff the offset to the location of the first transformed point that is stored in the
		 *               destination array.
		 * @param numPts the number of point objects to be transformed.
		 *
		 * @return the coordinate point after transforming ptSrc and storing the result in ptDst, or a
		 *         newly created point if ptDst was null.
		 *
		 * @throws TransformError if the point can't be transformed. Some implementations will stop at
		 *                        the first failure, wile some other implementations will fill the
		 *                        untransformable points with NaN values, continue and throw the
		 *                        exception only at end. Implementations that fall in the later case
		 *                        should set the last completed transform to this.
		 */
		function transform(srcPts:Array, srcOff:Number, dstPts:Array, dstOff:Number, numPts:Number):void;

	}

}
