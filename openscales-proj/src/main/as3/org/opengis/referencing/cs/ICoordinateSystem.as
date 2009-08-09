/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/cs/CoordinateSystem.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.cs {
	import org.opengis.referencing.IIdentifiedObject;
	import org.opengis.referencing.cs.ICoordinateSystemAxis;

	/**
	 * The set of coordinate system axes that spans a given coordinate space. A coordinate system (CS) is
	 * derived from a set of (mathematical) rules for specifying how coordinates in a given space are to
	 * be assigned to points. The coordinate values in a coordinate tuple shall be recorded in the order
	 * in which the coordinate system axes associations are recorded, whenever those coordinates use a
	 * coordinate reference system that uses this coordinate system.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface ICoordinateSystem extends IIdentifiedObject {

		/**
		 * Return the axis for this coordinate system at the specified dimension.
		 *
		 * @param dim The zero based index of axis.
		 *
		 * @return The axis at the specified dimension.
		 *
		 * @throws RangeError if dimension is out of bounds.
		 */
		function getAxis(dim:Number):ICoordinateSystemAxis;

		/**
		 * Returns the dimension of the coordinate system.
		 *
		 * @return The dimension of the coordinate system.
		 */
		function get dimension():Number;

	}

}
