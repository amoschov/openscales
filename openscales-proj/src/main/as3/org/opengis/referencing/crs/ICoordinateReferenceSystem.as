/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/crs/CoordinateReferenceSystem.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.crs {
	import org.opengis.referencing.IReferenceSystem;
	import org.opengis.referencing.cs.ICoordinateSystem;

	/**
	 * Abstract coordinate reference system, usually defined by a coordinate system and a datum. The
	 * concept of a coordinate reference system (CRS) captures the choice of values for the parameters
	 * that constitute the degrees of freedom of the coordinate space. The fact that such a choice has
	 * to be made, either arbitrarily or by adopting values from survey measurements, leads to the large
	 * number of coordinate reference systems in use around the world. It is also the cause of the
	 * little understood fact that the latitude and longitude of a point are not unique. Without the
	 * full specification of the coordinate reference system, coordinates are ambiguous at best and
	 * meaningless at worst. However for some interchange purposes it is sufficient to confirm the
	 * identity of the system without necessarily having the full system definition.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface ICoordinateReferenceSystem extends IReferenceSystem {

		/**
		 * Return a relevant coordinate system instance.
		 *
		 * @return The coordinate system.
		 */
		function get coordinateSystem():ICoordinateSystem;

	}

}
