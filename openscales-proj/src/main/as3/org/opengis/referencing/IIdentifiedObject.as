/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/IdentifiedObject.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing
{
    import org.opengis.referencing.IReferenceIdentifier;

    /**
     * Base interface for handling supplementary identification and remarks information for a CRS or
     * CRS-related object.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IIdentifiedObject {

        /**
         * The primary name by which this object is identified.
         *
         * @return the URN.
         */
        function get name ( ) : IReferenceIdentifier;

        /**
         * The list of alternates names by which this object is identified.
         *
         * @return the aliases.
         */
        function get alias ( ) : Array;

        /**
         * A list of identifiers which references elsewhere the object's defining
         * information.
         *
         * @return the identifiers.
         */
        function get identifier ( ) : Array;

        /**
         * Comments on or information about this object, including data source information.
         *
         * @return the remarks.
         */
        function get remarks ( ) : String;

    }

}
