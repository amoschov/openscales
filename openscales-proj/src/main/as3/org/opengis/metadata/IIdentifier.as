/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/Identifier.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata
{
    import org.opengis.metadata.citation.ICitation;

    /**
     * Value uniquely identifying an object within a namespace.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IIdentifier {

        /**
         * Organization or party responsible for definition and maintenance of the code.
         *
         * @return Party responsible for definition and maintenance of the code.
         */
        function get authority ( ) : ICitation;

        /**
         * Alphanumeric value identifying an instance in the namespace.
         *
         * @return Value identifying an instance in the namespace.
         */
        function get code ( ) : String;

    }

}
