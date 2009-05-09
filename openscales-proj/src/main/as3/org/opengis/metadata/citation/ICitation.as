/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/Citation.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation
{
    import org.opengis.metadata.citation.ISeries;

    /**
     * Standardized resource reference.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface ICitation {

        /**
         * Name by which the cited resource is known.
         *
         * @return The cited resource name.
         */
        function get title ( ) : String;

        /**
         * Short name or other language name by which the cited information is known.
         *
         * @return Other names for the resource, or an empty array if none.
         */
        function get alternateTitle ( ) : Array;

        /**
         * Reference dates for the cited resource.
         *
         * @return The reference dates (ICitationDate).
         */
        function get date ( ) : Array;

        /**
         * Version of the cited resource.
         *
         * @return The version, or null if none.
         */
        function get edition ( ) : String;

        /**
         * Date of the edition.
         *
         * @return The edition date, or null if none.
         */
        function get editionDate ( ) : Date;

        /**
         * Unique identifier for the resource. Example: Universal Product Code (UPC), National Stock
         * Number (NSN).
         *
         * @return The identifiers, or an empty array if none.
         */
        function get identifier ( ) : Array;

        /**
         * Name and position information for an individual or organization that is responsible for the
         * resource.
         *
         * @return The individual or organization that is responsible, or an empty array if none.
         */
        function get citedResponsibleParty ( ) : Array;

        /**
         * Mode in which the resource is represented.
         *
         * @return The presentation mode, or an empty array if none.
         */
        function get presentationForm ( ) : Array;

        /**
         * Information about the series, or aggregate dataset, of which the dataset is a part.
         *
         * @return The series of which the dataset is a part, or null if none.
         */
        function get series ( ) : ISeries;

        /**
         * Other information required to complete the citation that is not recorded elsewhere.
         *
         * @return Other details, or null if none.
         */
        function get otherCitationDetails ( ) : String;

        /**
         * Common title with holdings note. Note: title identifies elements of a series collectively,
         * combined with information about what volumes are available at the source cited.
         *
         * @return The common title, or null if none.
         */
        function get collectiveTitle ( ) : String;

        /**
         * International Standard Book Number, or null if none.
         *
         * @return The ISBN, or null if none.
         */
        function get ISBN ( ) : String;

        /**
         * International Standard Standard Number, or null if none.
         *
         * @return The ISSN, or null if none.
         */
        function get ISSN ( ) : String;

    }

}
