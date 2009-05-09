/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/AuthorityFactory.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing
{
    import org.opengis.metadata.citation.ICitation;
    import org.opengis.referencing.IIdentifiedObject;
    import org.opengis.referencing.IFactory;
    import org.opengis.referencing.NoSuchAuthorityCodeError;
    import org.opengis.referencing.FactoryError;

    /**
     * Base interface for all authority factories. An authority is an organization that maintains
     * definitions of authority codes. An authority code is a compact string defined by an authority to
     * reference a particular spatial reference object. For example the European Petroleum Survey Group
     * (EPSG) maintains a database of coordinate systems, and other spatial referencing objects, where
     * each object has a code number ID. For example, the EPSG code for a WGS84 Lat/Lon coordinate system
     * is '4326'.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IAuthorityFactory extends IFactory {

        /**
         * Return an arbitrary object from a code.
         *
         * @return The object for the given code.
         *
         * @throws NoSuchAuthorityCodeError if the specified code was not found.
         * @throws FactoryError if the object creation failed for some other reason.
         */
        function createObject ( ) : IIdentifiedObject;

        /**
         * Return the organization or party responsible for definition and maintenance of the database.
         *
         * @return The organization reponsible for definition of the database.
         */
        function get authority ( ) : ICitation;

        /**
         * Return the set of authority codes of the given type.
         *
         * @param type The spatial reference objects type.
         *
         * @return The array of authority codes for spatial reference objects of the given type. If this
         *         factory doesn't contains any object of the given type, then this method returns an
         *         empty array.
         */
        function getAuthorityCodes ( type:IIdentifiedObject ) : Array;

        /**
         * Gets a description of the object corresponding to a code.
         *
         * @return A description of the object, or null if the object corresponding to the specified
         *         code has no description.
         *
         * @throws NoSuchAuthorityCodeError if the specified code was not found.
         * @throws FactoryError if the query failed for some other reason.
         */
        function get descriptionText ( ) : String;
    }

}
