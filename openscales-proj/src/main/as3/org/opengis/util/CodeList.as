/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/util/CodeList.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.util
{
    import org.openscales.core.i18n.Lang;
    import org.openscales.core.i18n.LocalizedClassProperties;
    import flash.utils.getQualifiedClassName;

    /**
     * Identification of when a given event occurred.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class CodeList {

        /**
         * The list of codelists.
         * @private
         */
        private static var CODELISTS:Object= {};

        /**
         * The error messages translations.
         * @private
         */
        private static var _I18N:LocalizedClassProperties;
        {
            _I18N= new LocalizedClassProperties(CodeList);
            _I18N.setLocale(Lang.EN,
                {
                    "duplicated.name"     : "Duplicated name for codelist value : ${name}",
                    "list.already.exists" : "CodeList ${id} already exists",
                    "list.does.not.exist" : "CodeList ${id} does not exist"
                });
            _I18N.setLocale(Lang.FR,
                {
                    "duplicated.name"     : "Nom dupliqué de la valeur de la liste de codes : ${name}",
                    "list.already.exists" : "La liste de codes ${id} existe déjà",
                    "list.does.not.exist" : "La liste de codes ${id} n'existe pas"
                });
        }

        /**
         * The name of this codelist value.
         * @private
         */
        private var _code:String= null;

        /**
         * The ordinal of this codelist value.
         * @private
         */
        private var _ordinal:int= -1;

        /**
         * The identifier declared in the UML annotation, or an empty string if there is
         * no such annotation or if the annotation contains an empty string.
         * @private
         */
        private var _identifier:String= null;

        /**
         * Build a new codelist.
         *
         * @param values the codelist list of values.
         * @param name the codelist value.
         * @param identifier the codelist value identifier.
         *
         * @throws DefinitionError duplicated name.
         */
        public function CodeList ( values:Array, name:String, identifier:String="" ) {
            name= name.replace(/^\s*(.*)\s*$/,"$1");
            for each (var item:CodeList in values) {
                if (item._code==name) {
                    throw new DefinitionError(
                        _I18N.translate("duplicated.name", {"name":name}));
                }
            }
            // retreive class name :
            var cn:String= getQualifiedClassName(this);
            var cl:Array= CodeList.CODELISTS[cn] as Array;
            if (cl==null) {
                CodeList.CODELISTS[cn]= values;
            } else {
                var neq:Boolean= cl.length!=values.length;
                if (!neq) {
                    for (var icl:Number= 0, ncl:Number= cl.length; icl<ncl; icl++) {
                        if (cl[icl]!=values[icl]) {
                            neq= true;
                            break;
                        }
                    }
                }
                if (neq) {
                    throw new DefinitionError(
                        _I18N.translate("list.already.exists", {"id":cn}));
                }
            }

            this._code= name;
            this._ordinal= values.length;
            this._identifier= identifier;
            values.push(this);
        }

        /**
         * Return the date type that matches the given string.
         *
         * @param name the codelist value.
         * @param cn the class name having extended CodeList.
         *
         * @return the date type or null.
         *
         * @throws DefinitionError codelist does not exist.
         */
        public static function valueOf ( name:String, cn:String ) : CodeList {
            name= name.replace(/^\s*(.*)\s*$/,"$1");
            var cl:Array= CodeList.CODELISTS[cn] as Array;
            if (!cl) {
                throw new DefinitionError(
                    _I18N.translate("list.does.not.exist", {"id":cn}));
            }
            for each (var item:CodeList in cl) {
                if (item._code==name) {
                    return item;
                }
            }
            return null;
        }

        /**
         * Returns the identifier declared in the UML annotation.
         *
         * @return The ISO/OGC identifier for this code constant, or "null" if none.
         */
        public function identifier ( ) : String {
            return this._identifier;
        }

        /**
         * Return the name of this code list constant.
         *
         * @return the name.
         */
        public function name ( ) : String {
            return this._code;
        }

        /**
         * Return the ordinal of this code constant. This is its position in its elements declaration,
         * where the initial constant is assigned an ordinal of zero.
         *
         * @return The position of this code constants in elements declaration.
         */
        public function ordinal ( ) : int {
            return this._ordinal;
        }

        /**
         * Return the string representation of the specified code list constant.
         *
         * @return A string representation of the code.
         */
        public function toString ( ) : String {
            return "["+
                    "name="+this._code+
                    (this._identifier? " identifier="+this._identifier:"")+
            "]";
        }

        /**
         * Compares this code list with the specified object for equality.
         *
         * @param obj the reference system to compare with.
         *
         * @return true when equal, false otherwise.
         */
        public function equals ( obj:CodeList ) : Boolean {
            if (obj==null) {
                return false;
            }
            return this.name==obj.name && this.identifier==obj.identifier;
        }

    }

}
