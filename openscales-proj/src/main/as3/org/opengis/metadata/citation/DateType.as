/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/DateType.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation
{
    import flash.utils.getQualifiedClassName;
    import org.opengis.util.CodeList;

    /**
     * Identification of when a given event occurred.
     *
     * UML: CI_DateTypeCode
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public final class DateType extends CodeList {

        /**
         * Values for this code list.
         * @private
         */
        private static var VALUES:Array= [];

        /**
         * Date identifying when the resource was brought into existence.
         */
        public static const CREATION:DateType=
            new DateType("CREATION", "creation");

        /**
         * Date identifying when the resource was issued.
         */
        public static const PUBLICATION:DateType=
            new DateType("PUBLICATION", "publication");

        /**
         * Date identifying when the resource was examined or re-examined and improved or amended.
         */
        public static const REVISION:DateType=
            new DateType("REVISION", "revision");

        /**
         * Build a new type of date.
         *
         * @param name the codelist value.
         * @param identifier the codelist value identifier.
         *
         * @throws DefinitionError duplicated name.
         */
        public function DateType ( name:String, identifier:String="" ) {
            // FIXME : DateType.VALUES is null ... while VALUES is ok !
            super(VALUES, name, identifier);
        }

        /**
         * Return the list of enumerations of the same kind than this enum.
         *
         * @return The codes of the same kind than this code.
         */
        public function family ( ) : Array {
            return DateType.values();
        }

        /**
         * Return the list of DateType.
         *
         * @return The list of codes.
         */
        public static function values ( ) : Array {
            return DateType.VALUES;
        }

        /**
         * Return the date type that matches the given string.
         *
         * @param name the codelist value.
         *
         * @return the date type or null.
         */
        public static function valueOf ( name:String ) : DateType {
            return CodeList.valueOf(name, getQualifiedClassName(DateType)) as DateType;
        }

    }

}
