/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/OnLineFunction.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation
{
    import flash.utils.getQualifiedClassName;
    import org.opengis.util.CodeList;

    /**
     * Class of information to which the referencing entity applies.
     *
     * UML: CI_OnLineFunctionCode
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public final class OnLineFunction extends CodeList {

        /**
         * Values for this code list.
         * @private
         */
        private static var VALUES:Array= [];

        /**
         * Online instructions for transferring data from one storage device or system to another.
         */
        public static const DOWNLOAD:OnLineFunction=
            new OnLineFunction("DOWNLOAD", "download");

        /**
         * Online information about the resource.
         */
        public static const INFORMATION:OnLineFunction=
            new OnLineFunction("INFORMATION", "information");

        /**
         * Online instructions for requesting the resource from the provider.
         */
        public static const OFFLINE_ACCESS:OnLineFunction=
            new OnLineFunction("OFFLINE_ACCESS", "offlineAccess");

        /**
         * Online order process for obtaining the resource.
         */
        public static const ORDER:OnLineFunction=
            new OnLineFunction("ORDER", "order");

        /**
         * Online search interface for seeking out information about the resource.
         */
        public static const SEARCH:OnLineFunction=
            new OnLineFunction("SEARCH", "search");

        /**
         * Build a new type of class of information.
         *
         * @param name the codelist value.
         * @param identifier the codelist value identifier.
         *
         * @throws DefinitionError duplicated name.
         */
        public function OnLineFunction ( name:String, identifier:String="" ) {
            // FIXME : OnLineFunction.VALUES is null ... while VALUES is ok !
            super(VALUES, name, identifier);
        }

        /**
         * Return the list of enumerations of the same kind than this enum.
         *
         * @return The codes of the same kind than this code.
         */
        public function family ( ) : Array {
            return OnLineFunction.values();
        }

        /**
         * Return the list of DateType.
         *
         * @return The list of codes.
         */
        public static function values ( ) : Array {
            return OnLineFunction.VALUES;
        }

        /**
         * Return the date type that matches the given string.
         *
         * @param name the codelist value.
         *
         * @return the date type or null.
         */
        public static function valueOf ( name:String ) : OnLineFunction {
            return CodeList.valueOf(name, getQualifiedClassName(OnLineFunction)) as OnLineFunction;
        }

    }

}
