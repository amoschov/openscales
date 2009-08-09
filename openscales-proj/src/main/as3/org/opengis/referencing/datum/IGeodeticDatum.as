/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/datum/GeodeticDatum.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.datum {
	import org.opengis.referencing.datum.IDatum;
	import org.opengis.referencing.datum.IEllipsoid;
	import org.opengis.referencing.datum.IPrimeMeridian;

	/**
	 * Defines the location and precise orientation in 3-dimensional space of a defined ellipsoid (or
	 * sphere) that approximates the shape of the earth. Used also for Cartesian coordinate system
	 * centered in this ellipsoid (or sphere).
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IGeodeticDatum extends IDatum {

		/**
		 * Return the ellipsoid.
		 *
		 * @return The ellipsoid.
		 */
		function get ellipsoid():IEllipsoid;

		/**
		 * Return the prime meridian.
		 *
		 * @return The prime meridian.
		 */
		function get primeMeridian():IPrimeMeridian;

	}

}
