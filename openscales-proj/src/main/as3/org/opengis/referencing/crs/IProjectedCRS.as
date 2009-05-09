/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/crs/ProjectedCRS.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.crs
{
    import org.opengis.referencing.crs.IGeneralDerivedCRS;

    /**
     * A 2D coordinate reference system used to approximate the shape of the earth on a planar surface.
     * It is done in such a way that the distortion that is inherent to the approximation is carefully
     * controlled and known. Distortion correction is commonly applied to calculated bearings and
     * distances to produce values that are a close match to actual field values.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IProjectedCRS extends IGeneralDerivedCRS {

    }

}
