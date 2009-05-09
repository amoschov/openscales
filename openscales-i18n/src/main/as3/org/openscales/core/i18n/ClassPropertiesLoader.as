/**
 * @see http://code.google.com/p/andromed-as/ under MPL 1.1
 * @see http://www.ekameleon.net/vegas/docs/andromeda/system/serializers/eden/ECMAScript.html
 */
package org.openscales.core.i18n
{
    import flash.utils.getQualifiedClassName;

    import org.openscales.core.i18n.PropertiesLoader;

    /**
     * Class Properties loader class. The properties file follow the qualified class name.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class ClassPropertiesLoader extends PropertiesLoader {

        /**
         * The regexp for the class path.
         * @private
         */
        private static var _CLASS_PATH:RegExp= /\.|([:]{2}.+$)/g;

        /**
         * The base path of the class properties.
         * @private
         */
        private var _propsPath:String;

        /**
         * Build a class properties loader. The base path of the class properties is build from the
         * qualified class name where the '.' and '::' are replaced with '/'.
         *
         * @param cl the Class for which the properties will be loaded.
         */
        public function ClassPropertiesLoader ( cl:Class ) {
            super();
            var path:String= getQualifiedClassName(cl);
            path= path.replace(_CLASS_PATH,"/");
            this._propsPath= path;
        }

        /**
         * Get the path to be applied to the source name.
         *
         * @return the base path of the class properties.
         */
        public override function getPath ( ) : String {
            return this._propsPath;
        }

    }

}
