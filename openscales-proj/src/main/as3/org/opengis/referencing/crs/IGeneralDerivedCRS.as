/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/crs/GeneralDerivedCRS.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.crs
{
    import org.opengis.referencing.crs.ICoordinateReferenceSystem;
    import org.opengis.referencing.operation.IConversion;

    /**
     * A coordinate reference system associated with a geodetic datum.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IGeneralDerivedCRS extends ISingleCRS {

        /**
         * Return the base coordinate reference system.
         *
         * @return The base coordinate reference system.
         */
        function get baseCRS ( ) : ICoordinateReferenceSystem;

        /**
         * Return the map projection from the base CRS to this CRS.
         *
         * @return The conversion from the base CRS.
         */
        function get conversionFromBase ( ) : IConversion;

    }

}
