/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/crs/GeographicCRS.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.crs
{
    import org.opengis.referencing.crs.IGeodeticCRS;

    /**
     * A coordinate reference system based on an ellipsoidal approximation of the geoid; this provides
     * an accurate representation of the geometry of geographic features for a large portion of the
     * earth's surface.
     *  A geographic CRS is not suitable for mapmaking on a planar surface, because it describes
     * geometry on a curved surface. It is impossible to represent such geometry in a Euclidean plane
     * without introducing distortions. The need to control these distortions has given rise to the
     * development of the science of map projections.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IGeographicCRS extends IGeodeticCRS {

    }

}
