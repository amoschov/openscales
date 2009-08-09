/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/operation/Projection.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.operation {
	import org.opengis.referencing.operation.IConversion;

	/**
	 * A conversion transforming (longitude,latitude) coordinates to cartesian coordinates (x,y).
	 * Although some map projections can be represented as a geometric process, in general a map
	 * projection is a set of formulae that converts geodetic latitude and longitude to plane (map)
	 * coordinates. Height plays no role in this process, which is entirely two-dimensional. The same
	 * map projection can be applied to many geographic CRSs, resulting in many projected CRSs each of
	 * which is related to the same geodetic datum as the geographic CRS on which it was based.
	 * <p>An unofficial list of projections and their parameters can be found <a
	 * href="http://www.remotesensing.org/geotiff/proj_list/" target="_blank">there</a>. Most
	 * projections expect the following parameters: "semi_major" (mandatory), "semi_minor" (mandatory),
	 * "central_meridian" (default to 0), "latitude_of_origin" (default to 0), "scale_factor" (default
	 * to 1), "false_easting" (default to 0) and "false_northing" (default to 0).
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IProjection extends IConversion {

	}

}
