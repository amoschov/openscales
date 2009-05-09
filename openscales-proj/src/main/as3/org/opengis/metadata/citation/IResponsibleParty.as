/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/ResponsibleParty.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation
{
    import org.opengis.metadata.citation.IContact;
    import org.opengis.metadata.citation.Role;

    /**
     * Identification of, and means of communication with, person(s) and organizations associated with
     * the dataset.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IResponsibleParty {

        /**
         * Name of the responsible person- surname, given name, title separated by a delimiter. Only one
         * of individualName, organisationName  and positionName should be provided.
         *
         * @return Name, surname, given name and title of the responsible person, or null.
         */
        function get individualName ( ) : String;

        /**
         * Name of the responsible organization. Only one of individualName, organisationName  and
         * positionName should be provided.
         *
         * @return Name of the responsible organization or null.
         */
        function get organisationName ( ) : String;

        /**
         * Role or position of the responsible person. Only one of individualName, organisationName and
         * positionName should be provided.
         *
         * @return Role or position of the responsible person or null
         */
        function get positionName ( ) : String;

        /**
         * Address of the responsible party.
         *
         * @return Address of the responsible party or null.
         */
        function get contactInfo ( ) : IContact;

        /**
         * Function performed by the responsible party.
         *
         * @return Function performed by the responsible party.
         */
        function get role ( ) : Role;

    }

}
