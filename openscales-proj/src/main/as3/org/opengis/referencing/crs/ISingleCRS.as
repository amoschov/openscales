/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/crs/SingleCRS.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.crs {
	import org.opengis.referencing.crs.ICoordinateReferenceSystem;
	import org.opengis.referencing.datum.IDatum;

	/**
	 * Abstract coordinate reference system, consisting of a single Coordinate System and a single Datum
	 * (as opposed to Compound CRS).
	 * A coordinate reference system consists of an ordered sequence of coordinate system axes that are
	 * related to the earth through a datum. A coordinate reference system is defined by one datum and
	 * by one coordinate system. Most coordinate reference system do not move relative to the earth,
	 * except for engineering coordinate reference systems defined on moving platforms such as cars,
	 * ships, aircraft, and spacecraft.
	 * Coordinate reference systems are commonly divided into sub-types. The common classification
	 * criterion for sub-typing of coordinate reference systems is the way in which they deal with earth
	 * curvature. This has a direct effect on the portion of the earth's surface that can be covered by
	 * that type of CRS with an acceptable degree of error. The exception to the rule is the subtype
	 * "Temporal" which has been added by analogy.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface ISingleCRS extends ICoordinateReferenceSystem {

		/**
		 * Return the datum.
		 *
		 * @return The datum.
		 */
		function get datum():IDatum;

	}

}
