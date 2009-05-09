/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/crs/DerivedCRS.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.crs
{
    import org.opengis.referencing.crs.IGeneralDerivedCRS;

    /**
     * A coordinate reference system that is defined by its coordinate conversion from another
     * coordinate reference system but is not a projected coordinate reference system. This category
     * includes coordinate reference systems derived from a projected coordinate reference system.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IDerivedCRS extends IGeneralDerivedCRS {

    }

}
