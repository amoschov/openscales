/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/datum/Datum.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.datum {
	import org.opengis.metadata.extent.IExtent;
	import org.opengis.referencing.IIdentifiedObject;

	/**
	 * Specifies the relationship of a coordinate system to the earth, thus creating a coordinate
	 * reference system. A datum uses a parameter or set of parameters that determine the location of
	 * the origin of the coordinate reference system. Each datum subtype can be associated with only
	 * specific types of coordinate systems.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IDatum extends IIdentifiedObject {

		/**
		 * Description, possibly including coordinates, of the point or points used to anchor the datum
		 * to the Earth. Also known as the "origin", especially for Engineering and Image Datums.
		 * <ul>
		 *   <li>For a geodetic datum, this point is also known as the fundamental point, which is
		 *       traditionally the point where the relationship between geoid and ellipsoid is defined.
		 *       In some cases, the "fundamental point" may consist of a number of points. In those
		 *       cases, the parameters defining the geoid/ellipsoid relationship have then been averaged
		 *       for these points, and the averages adopted as the datum definition.</li>
		 *   <li>For an engineering datum, the anchor point may be a physical point, or it may be a
		 *       point with defined coordinates in another CRS.</li>
		 *   <li>For an image datum, the anchor point is usually either the centre of the image or the
		 *       corner of the image.</li>
		 *   <li>For a temporal datum, this attribute is not defined. Instead of the anchor point, a
		 *       temporal datum carries a separate time origin of type Date.</li>
		 *
		 * @return A description of the anchor point, or null if none.
		 */
		function get anchorPoint():String;

		/**
		 * The time after which this datum definition is valid. This time may be precise (e.g. 1997 for
		 * IRTF97) or merely a year (e.g. 1983 for NAD83). In the latter case, the epoch usually refers
		 * to the year in which a major recalculation of the geodetic control network, underlying the
		 * datum, was executed or initiated. An old datum can remain valid after a new datum is defined.
		 * Alternatively, a datum may be superseded by a later datum, in which case the realization
		 * epoch for the new datum defines the upper limit for the validity of the superseded datum.
		 *
		 * @return The datum realization epoch, or null if not available.
		 */
		function get realizationEpoch():Date;

		/**
		 * Area or region or timeframe in which this datum is valid.
		 *
		 * @return The datum valid domain, or null if not available.
		 */
		function get domainOfValidity():IExtent;

		/**
		 * Description of domain of usage, or limitations of usage, for which this datum object is valid.
		 *
		 * @return A description of domain of usage, or null if none.
		 */
		function get scope():String;

	}

}
