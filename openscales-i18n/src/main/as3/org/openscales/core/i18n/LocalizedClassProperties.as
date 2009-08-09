/**
 * @see http://code.google.com/p/andromed-as/ under MPL 1.1
 * @see http://www.ekameleon.net/vegas/docs/andromeda/i18n/Localization.html
 */
package org.openscales.core.i18n {
	import flash.utils.getQualifiedClassName;

	import org.openscales.core.i18n.ClassPropertiesLoader;
	import org.openscales.core.i18n.LocalizedProperties;

	/**
	 * Handle properties localized in several languages.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class LocalizedClassProperties extends LocalizedProperties {

		/**
		 * Build a new localized class properties.
		 *
		 * @example
		 * <listing version="3.0">
		 * var lp:LocalizedClassProperties= new LocalizedClassProperties(aClass);
		 * lp.language= "fr";// load path/aClass_fr.properties
		 * var s:String= lp.translate("key");// french translation
		 * lp.language= "en";// load path/aClass_en.properties
		 * s= lp.translate("key");// english translation
		 * </listing>
		 *
		 * @param cls the Class for which the properties will be loaded.
		 */
		public function LocalizedClassProperties(cl:Class) {
			super(getQualifiedClassName(cl), new ClassPropertiesLoader(cl));
		}

		/**
		 * Set the prefix of the properties. Filter the str by keeping the substring after the "::"
		 * string if any.
		 *
		 * @param str A string to filter for setting the prefix.
		 */
		public override function set prefix(str:String):void {
			str=str || "";
			var i:Number=str.lastIndexOf("::");
			if (i == -1) {
				this._prefix=String(this._id);
			} else {
				this._prefix=this._id.substring(i + 2);
			}
		}

	}

}
