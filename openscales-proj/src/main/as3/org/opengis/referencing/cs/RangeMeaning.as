/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referecing/cs/RangeMeaning.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.cs {
	import flash.utils.getQualifiedClassName;
	import org.opengis.util.CodeList;

	/**
	 * Identification of when a given event occurred.
	 *
	 * UML: CS_RangeMeaning
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public final class RangeMeaning extends CodeList {

		/**
		 * Values for this code list.
		 * @private
		 */
		private static var VALUES:Array=[];

		/**
		 * Any value between and including minimum value  and maximum value is valid.
		 */
		public static const EXACT:RangeMeaning=new RangeMeaning("EXACT", "exact");

		/**
		 * The axis is continuous with values wrapping around at the minimum value and maximum value.
		 */
		public static const WRAPAROUND:RangeMeaning=new RangeMeaning("WRAPAROUND", "wrapAround");

		/**
		 * Build a new event.
		 *
		 * @param name the codelist value.
		 * @param identifier the codelist value identifier.
		 *
		 * @throws DefinitionError duplicated name.
		 */
		public function RangeMeaning(name:String, identifier:String="") {
			// FIXME : RangeMeaning.VALUES is null ... while VALUES is ok !
			super(VALUES, name, identifier);
		}

		/**
		 * Return the list of enumerations of the same kind than this enum.
		 *
		 * @return The codes of the same kind than this code.
		 */
		public function family():Array {
			return RangeMeaning.values();
		}

		/**
		 * Return the list of RangeMeaning.
		 *
		 * @return The list of codes.
		 */
		public static function values():Array {
			return RangeMeaning.VALUES;
		}

		/**
		 * Return the date type that matches the given string.
		 *
		 * @param name the codelist value.
		 *
		 * @return the date type or null.
		 */
		public static function valueOf(name:String):RangeMeaning {
			return CodeList.valueOf(name, getQualifiedClassName(RangeMeaning)) as RangeMeaning;
		}

	}

}
