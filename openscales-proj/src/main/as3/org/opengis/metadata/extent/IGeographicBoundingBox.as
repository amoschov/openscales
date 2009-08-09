/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/extent/GeographicBoundingBox.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.extent {
	import org.opengis.metadata.extent.IGeographicExtent;

	/**
	 * Geographic position of the dataset. This is only an approximate so specifying the co-ordinate
	 * reference system is unnecessary.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IGeographicBoundingBox extends IGeographicExtent {

		/**
		 * The western-most coordinate of the limit of the dataset extent. The value is expressed in
		 * longitude in decimal degrees (positive east).
		 *
		 * @return The western-most longitude between -180 and +180°.
		 */
		function get westBoundLongitude():Number;

		/**
		 * The eastern-most coordinate of the limit of the dataset extent. The value is expressed in
		 * longitude in decimal degrees (positive east).
		 *
		 * @return The eastern-most longitude between -180 and +180°.
		 */
		function get eastBoundLongitude():Number;

		/**
		 * The southern-most coordinate of the limit of the dataset extent. The value is expressed in
		 * latitude in decimal degrees (positive north).
		 *
		 * @return The southern-most latitude between -90 and +90°.
		 */
		function get southBoundLatitude():Number;

		/**
		 * The northern-most, coordinate of the limit of the dataset extent. The value is expressed in
		 * latitude in decimal degrees (positive north).
		 *
		 * @return The northern-most latitude between -90 and +90°.
		 */
		function get northBoundLatitude():Number;

	}

}
