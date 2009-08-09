/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/Address.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation {

	/**
	 * Location of the responsible individual or organization.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IAddress {

		/**
		 * Address line for the location (as described in ISO 11180, Annex A).
		 *
		 * @return Address line for the location, an empty array if none.
		 */
		function get deliveryPoint():Array;

		/**
		 * The city of the location.
		 *
		 * @return The city of the location, or null.
		 */
		function get city():String;

		/**
		 * State, province of the location.
		 *
		 * @return State, province of the location, or null.
		 */
		function get administrativeArea():String;

		/**
		 * ZIP or other postal code.
		 *
		 * @return ZIP or other postal code, or null.
		 */
		function get postalCode():String;

		/**
		 * Country of the physical address.
		 *
		 * @return Country of the physical address, or null.
		 */
		function get country():String;

		/**
		 * Address of the electronic mailbox of the responsible organization or individual.
		 *
		 * @return Address of the electronic mailbox of the responsible organization or individual, or
		 * an empty array if none.
		 */
		function get electronicMailAddress():Array;

	}

}
