/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/Role.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation {
	import flash.utils.getQualifiedClassName;
	import org.opengis.util.CodeList;

	/**
	 * Function performed by the responsible party.
	 *
	 * UML: CI_RoleCode
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public final class Role extends CodeList {

		/**
		 * Values for this code list.
		 * @private
		 */
		private static var VALUES:Array=[];

		/**
		 * Party who authored the resource.
		 */
		public static const AUTHOR:Role=new Role("AUTHOR", "author");

		/**
		 * Party that accepts accountability and responsibility for the data and ensures appropriate
		 * care and maintenance of the resource.
		 */
		public static const CUSTODIAN:Role=new Role("CUSTODIAN", "custodian");

		/**
		 * Party who distributes the resource.
		 */
		public static const DISTRIBUTOR:Role=new Role("DISTRIBUTOR", "distributor");

		/**
		 * Party who created the resource.
		 */
		public static const ORIGINATOR:Role=new Role("ORIGINATOR", "originator");

		/**
		 * Party that owns the resource.
		 */
		public static const OWNER:Role=new Role("OWNER", "owner");

		/**
		 * Party who can be contacted for acquiring knowledge about or acquisition of the resource.
		 */
		public static const POINT_OF_CONTACT:Role=new Role("POINT_OF_CONTACT", "pointOfContact");

		/**
		 * Key party responsible for gathering information and conducting research.
		 */
		public static const PRINCIPAL_INVESTIGATOR:Role=new Role("PRINCIPAL_INVESTIGATOR", "principalInvestigator");

		/**
		 * Party who has processed the data in a manner such that the resource has been modified.
		 */
		public static const PROCESSOR:Role=new Role("PROCESSOR", "processor");

		/**
		 * Party who published the resource.
		 */
		public static const PUBLISHER:Role=new Role("PUBLISHER", "publisher");

		/**
		 * Party that supplies the resource.
		 */
		public static const RESOURCE_PROVIDER:Role=new Role("RESOURCE_PROVIDER", "resourceProvider");

		/**
		 * Party who uses the resource.
		 */
		public static const USER:Role=new Role("USER", "user");

		/**
		 * Build a new role.
		 *
		 * @param name the codelist value.
		 * @param identifier the codelist value identifier.
		 *
		 * @throws DefinitionError duplicated name.
		 */
		public function Role(name:String, identifier:String="") {
			// FIXME : Role.VALUES is null ... while VALUES is ok !
			super(VALUES, name, identifier);
		}

		/**
		 * Return the list of enumerations of the same kind than this enum.
		 *
		 * @return The codes of the same kind than this code.
		 */
		public function family():Array {
			return Role.values();
		}

		/**
		 * Return the list of Role.
		 *
		 * @return The list of codes.
		 */
		public static function values():Array {
			return Role.VALUES;
		}

		/**
		 * Return the date type that matches the given string.
		 *
		 * @param name the codelist value.
		 *
		 * @return the date type or null.
		 */
		public static function valueOf(name:String):Role {
			return CodeList.valueOf(name, getQualifiedClassName(Role)) as Role;
		}

	}

}
