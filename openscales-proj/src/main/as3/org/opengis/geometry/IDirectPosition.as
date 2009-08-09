/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/geometry/DirectPosition.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.geometry {
	import org.opengis.referencing.crs.ICoordinateReferenceSystem;

	/**
	 * Holds the coordinates for a position within some coordinate reference system.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IDirectPosition {

		/**
		 * The location's coordinate.
		 *
		 * @return the coordinate as an array of numbers.
		 */
		function get coordinate():Array;

		/**
		 * The coordinates reference system in which this location is given.
		 *
		 * @return the coordinates reference system or null if the location is included in larger
		 *         geometry object that have reference to the coordinates reference system.
		 */
		function get coordinateReferenceSystem():ICoordinateReferenceSystem;

		/**
		 * The location dimension.
		 *
		 * @return the length of the coordinate, -1 if no coordinate.
		 *
		 * @throws ReferenceError no coordinates.
		 */
		function get dimension():Number;

		/**
		 * Get the a copy of the ordinate value along the specified dimension.
		 *
		 * @param dim the dimension for the ordinate of interest.
		 *
		 * @return the ordinate value of interest.
		 */
		function getOrdinate(dim:Number):Number;

		/**
		 * Set the ordinate value along the specified dimension.
		 *
		 * @param dim the dimension for the ordinate of interest.
		 * @param value the ordinate value of interest.
		 */
		function setOrdinate(dim:Number, value:Number):void;

	}

}
