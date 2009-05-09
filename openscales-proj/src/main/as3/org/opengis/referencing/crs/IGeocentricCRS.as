/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/crs/GeocentricCRS.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.crs
{
    import org.opengis.referencing.crs.IGeodeticCRS;

    /**
     * A 3D coordinate reference system with the origin at the approximate centre of mass of the earth.
     * A geocentric CRS deals with the earth's curvature by taking a 3D spatial view, which obviates the
     * need to model the earth's curvature.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IGeocentricCRS extends IGeodeticCRS {

    }

}
