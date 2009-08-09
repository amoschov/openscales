/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/cs/CoordinateSystemAxis.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.cs {
	import org.opengis.referencing.IIdentifiedObject;
	import org.opengis.referencing.cs.AxisDirection;
	import org.opengis.referencing.cs.RangeMeaning;

	/**
	 * Definition of a coordinate system axis. See axis name constraints.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface ICoordinateSystemAxis extends IIdentifiedObject {

		/**
		 * The abbreviation used for this coordinate system axes. This abbreviation is also used to
		 * identify the ordinates in coordinate tuple. Examples are "X" and "Y".
		 *
		 * @return The coordinate system axis abbreviation.
		 */
		function get abbreviation():String;

		/**
		 * Direction of this coordinate system axis. In the case of cartesian projected coordinates, this
		 * is the direction of this coordinate system axis locally. Examples: north or south, east or
		 * west, up or down. Within any set of coordinate system axes, only one of each pair of terms can
		 * be used. For earth-fixed coordinate reference systems, this direction is often approximate and
		 * intended to provide a human interpretable meaning to the axis. When a geodetic datum is used,
		 * the precise directions of the axes may therefore vary slightly from this approximate
		 * direction.
		 *
		 * @return The coordinate system axis direction.
		 */
		function get direction():AxisDirection;

		/**
		 * Return the maximum value normally allowed for this axis, in the unit of measure for the axis.
		 * If there is no maximum value, then this method returns positive infinity.
		 *
		 * @return The maximum value, or Infinity if none.
		 */
		function get maximumValue():Number;

		/**
		 * Return the minimum value normally allowed for this axis, in the unit of measure for the axis.
		 * If there is no minimum value, then this method returns negative infinity.
		 *
		 * @return The minimum value, or -Infinity if none.
		 */
		function get minimumValue():Number;

		/**
		 * Return the meaning of axis value range specified by the minimum and maximum values. This
		 * element shall be omitted when both minimum and maximum values are omitted. It may be included
		 * when minimum and/or maximum values are included. If this element is omitted when minimum or
		 * maximum values are included, the meaning is unspecified.
		 *
		 * @return The range meaning, or null in none.
		 */
		function get rangeMeaning():RangeMeaning;

		/**
		 * The unit of measure used for this coordinate system axis. The value of this coordinate in a
		 * coordinate tuple shall be recorded using this unit of measure, whenever those coordinates use
		 * a coordinate reference system that uses a coordinate system that uses this axis.
		 *
		 * @return The coordinate system axis unit.
		 */
		function get unit():String;

	}

}
