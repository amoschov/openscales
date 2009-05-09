/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/datum/Ellipsoid.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.datum
{
    import org.opengis.referencing.IIdentifiedObject;

    /**
     * Geometric figure that can be used to describe the approximate shape of the earth. In mathematical
     * terms, it is a surface formed by the rotation of an ellipse about its minor axis. An ellipsoid
     * requires two defining parameters:<ul>
     * <li>semi-major axis and inverse flattening, or</li>
     * <li>semi-major axis and semi-minor axis.</li>
     * </ul>
     * There is not just one ellipsoid. An ellipsoid is a matter of choice, and therefore many choices
     * are possible. The size and shape of an ellipsoid was traditionally chosen such that the surface
     * of the geoid is matched as closely as possible locally, e.g. in a country. A number of global
     * best-fit ellipsoids are now available. An association of an ellipsoid with the earth is made
     * through the definition of the size and shape of the ellipsoid and the position and orientation of
     * this ellipsoid with respect to the earth. Collectively this choice is captured by the concept of
     * "geodetic datum". A change of size, shape, position or orientation of an ellipsoid will result in
     * a change of geographic coordinates of a point and be described as a different geodetic datum.
     * Conversely geographic coordinates are unambiguous only when associated with a geodetic datum.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IEllipsoid extends IIdentifiedObject {

        /**
         * Return the linear unit of the semi-major and semi-minor axis values.
         *
         * @return The axis linear unit.
         */
        function get axisUnit ( ) : String;

        /**
         * Return the value of the inverse of the flattening constant. The inverse flattening is related
         * to the equatorial/polar radius by the formula ivf = re/(re-rp). For perfect spheres (i.e. if
         * isSphere() returns true), the POSITIVE_INFINITY value is used.
         *
         * @return The inverse flattening value.
         */
        function get inverseFlattening ( ) : Number;

        /**
         * Length of the semi-major axis of the ellipsoid. This is the equatorial radius in axis linear
         * unit.
         *
         * @return Length of semi-major axis.
         */
        function get semiMajorAxis ( ) : Number;

        /**
         * Length of the semi-minor axis of the ellipsoid. This is the polar radius in axis linear unit.
         *
         * @return Length of semi-minor axis.
         */
        function get semiMinorAxis ( ) : Number;

        /**
         * Indicate if the inverse flattening is definitive for this ellipsoid. Some ellipsoids use the
         * IVF as the defining value, and calculate the polar radius whenever asked. Other ellipsoids
         * use the polar radius to calculate the IVF whenever asked. This distinction can be important
         * to avoid floating-point rounding errors.
         *
         * @return true if the inverse flattening is definitive, or false if the polar radius is
         *         definitive.
         */
        function isIvfDefinitive ( ) : Boolean;

        /**
         * true if the ellipsoid is degenerate and is actually a sphere. The sphere is completely
         * defined by the semi-major axis, which is the radius of the sphere.
         *
         * @return true if the ellipsoid is degenerate and is actually a sphere.
         */
        function isSphere ( ) : Boolean;

    }

}
