/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/extent/Extent.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.extent
{
    /**
     * Information about spatial, vertical, and temporal extent. This interface has three optional
     * attributes (geographic elements, temporal elements, and vertical elements) and an element called
     * description. At least one of the four shall be used.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IExtent {

        /**
         * Return the spatial and temporal extent for the referring object.
         *
         * @return The spatial and temporal extent, or null in none.
         */
        function get description ( ) : String;

        /**
         * Provide geographic component of the extent of the referring object.
         *
         * @return The geographic extent, or an empty array if none.
         */
        function get geographicElement ( ) : Array;

        /**
         * Provide temporal component of the extent of the referring object.
         *
         * @return The temporal extent, or an empty array if none.
         */
        function get temporalElement ( ) : Array;

        /**
         * Provide vertical component of the extent of the referring object.
         *
         * @return The vertical extent, or an empty array if none.
         */
        function get verticalElement ( ) : Array;

    }

}
