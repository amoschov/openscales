/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/datum/PrimeMeridian.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.datum
{
    import org.opengis.referencing.IIdentifiedObject;

    /**
     * A prime meridian defines the origin from which longitude values are determined. The name initial
     * value is "Greenwich", and that value shall be used when the greenwich longitude value is zero.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IPrimeMeridian extends IIdentifiedObject {

        /**
         * Longitude of the prime meridian measured from the Greenwich meridian, positive eastward. The
         * greenwichLongitude initial value is zero, and that value shall be used when the meridian name
         * value is "Greenwich".
         *
         * @return The prime meridian Greenwich longitude, in angular unit.
         */
        function get greenwichLongitude ( ) : Number;

        /**
         * Return the angular unit of the Greenwich longitude.
         *
         * @return The angular unit of greenwich longitude.
         */
        function get angularUnit ( ) : String;

    }

}
