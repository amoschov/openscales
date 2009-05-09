/**
 * @see http://code.google.com/p/andromed-as/ under MPL 1.1
 * @see http://www.ekameleon.net/vegas/docs/andromeda/i18n/Lang.html
 */
package org.openscales.core.i18n
{
    /**
     * This static enumeration class defines the language code of the system on which the player is
     * running. The language is specified as a lowercase two-letter language code from ISO 639-1.
     * For Chinese, an additional uppercase two-letter country code from ISO 3166 distinguishes
     * between Simplified and Traditional Chinese.
     * The languages labels are based on the mother languages names of the language: for example,
     * 'hu' specifies Magyar (Hungarian in english).
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     * @see Capabilities.language
     */
    public final class Lang {

        /**
         * List of all supported languages.
         * @private
         */
        private static var _LANGUAGES:Object= {};

        /**
         * Cardinality of the supported languages' list.
         * @private
         */
        private static var _CARD:Number= 0;

        /**
         * The ISO 639-1 (with the exception for Chinese) of the instance.
         * @private
         */
        private var _code:String= null;

        /**
         * The label of the instance.
         * @private
         */
        private var _label:String= null;

        /**
         * the 'Czech' language reference.
         */
        public static const CS:Lang= new Lang("cs", "Čech");

        /**
         * the 'Dasnish' language reference.
         */
        public static const DA:Lang= new Lang("da", "Dansk");

        /**
         * the 'German' language reference.
         */
        public static const DE:Lang= new Lang("de", "Deutsch");

        /**
         * the 'English' language reference.
         */
        public static const EN:Lang= new Lang("en", "English");

        /**
         * the 'Spanish' language reference.
         */
        public static const ES:Lang= new Lang("es", "Español");

        /**
         * the 'Finnish' language reference.
         */
        public static const FI:Lang= new Lang("fi", "Suomi");

        /**
         * the 'French' language reference.
         */
        public static const FR:Lang= new Lang("fr", "Français");

        /**
         * the 'Hungarian' language reference.
         */
        public static const HU:Lang= new Lang("hu", "Magyar");

        /**
         * the 'Italian' language reference.
         */
        public static const IT:Lang= new Lang("it", "Italiano");

        /**
         * the 'Japanese' language reference.
         */
        public static const JA:Lang= new Lang("ja", "日本人");

        /**
         * the 'Korean' language reference.
         */
        public static const KO:Lang= new Lang("ko", "한국어");

        /**
         * the 'Dutch' language reference.
         */
        public static const NL:Lang= new Lang("nl", "Nederlands");

        /**
         * the 'Norwegian' language reference.
         */
        public static const NO:Lang= new Lang("no", "Norsk");

        /**
         * the 'Polish' language reference.
         */
        public static const PL:Lang= new Lang("pl", "Polski");

        /**
         * the 'Portuguese' language reference.
         */
        public static const PT:Lang= new Lang("pt", "Português");

        /**
         * the 'Russian' language reference.
         */
        public static const RU:Lang= new Lang("ru", "Русский");

        /**
         * the 'Swedish' language reference.
         */
        public static const SV:Lang= new Lang("sv", "Svenska");

        /**
         * the 'Turkish' language reference.
         */
        public static const TR:Lang= new Lang("tr", "Türkçe");

        /**
         * the 'Other/unknown' language reference.
         */
        public static const XU:Lang= new Lang("xu", "Other/unknown") ;

        /**
         * the 'Simplified Chinese' language reference.
         */
        public static const ZH_CN:Lang= new Lang("zh-CN", "简体中文");

        /**
         * the 'Traditional Chinese' language reference.
         */
        public static const ZH_TW:Lang= new Lang("zh-TW", "繁體中文");

        /**
         * Creates a new Lang instance.
         * @param id The lang language specified as a lowercase two-letter language code from ISO
         *           639-1. For Chinese, an additional uppercase two-letter country code from ISO
         *           3166 distinguishes between Simplified and Traditional Chinese.
         * @param name The name of the language in its mother language.
         */
        public function Lang( id:String, name:String ) {
            this._setCode(id);
            this._setLabel(name);
            _LANGUAGES[this.code]= this;
            _CARD++;
        }

        /**
         * Return the language's code.
         *
         * @return the language's code.
         */
        public function get code ( ) : String {
            return this._code;
        }

        /**
         * Set the language's code.
         *
         * @param id the language code.
         *
         * @private
         */
        private function _setCode ( id:String ) : void {
            this._code= id;
        }

        /**
         * Return the language's label.
         *
         * @return the language's label.
         */
        public function get label ( ) : String {
            return this._label;
        }

        /**
         * Set the language's label.
         *
         * @param name the language name.
         *
         * @private
         */
        private function _setLabel ( name:String ) : void {
            this._label= name;
        }

        /**
         * Returns the string representation of this instance.
         * @return the string representation of this instance : "id".
         */
        public function toString ( ) : String {
            return this.code;
        }

        /**
         * Return a language instance with the specified 'id' value.
         *
         * @return a Language instance with the specified 'id' value, null if no language is mapped
         *         with the given 'id'.
         */
        public static function getInstance ( id:String ) : Lang {
            return (Lang._LANGUAGES[id] as Lang);
        }

        /**
         * Return the number of supported languages.
         *
         * @return the supported languages's list cardinality.
         */
        public static function size ( ) : Number {
            return Lang._CARD;
        }

        /**
         * Return true if the passed value is a valid language reference.
         *
         * @return true if the passed value is a valid language reference.
         */
        public static function validate ( lang:* ) : Boolean {
            var s:String;
            if (lang is Lang) {
                s= (lang as Lang).toString() ;
            } else if (lang is String) {
                s= lang ;
            } else {
                return false ;
            }
            for (var l:String in Lang._LANGUAGES) {
                if (l==s) {
                    return true;
                }
            }
            return false;
        }

    }

}
