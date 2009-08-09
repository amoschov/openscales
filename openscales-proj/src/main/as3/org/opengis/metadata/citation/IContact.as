/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/Contact.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation {
	import org.opengis.metadata.citation.IAddress;
	import org.opengis.metadata.citation.IOnlineResource;
	import org.opengis.metadata.citation.ITelephone;

	/**
	 * Information required to enable contact with the responsible person and/or organization.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IContact {

		/**
		 * Telephone numbers at which the organization or individual may be contacted.
		 *
		 * @return Telephone numbers at which the organization or individual may be contacted, or null.
		 */
		function get phone():ITelephone;

		/**
		 * Physical and email address at which the organization or individual may be contacted.
		 *
		 * @return Physical and email address at which the organization or individual may be contacted,
		 * or null.
		 */
		function get address():IAddress;

		/**
		 * On-line information that can be used to contact the individual or organization.
		 *
		 * @return On-line information that can be used to contact the individual or organization, or
		 *         null.
		 */
		function get onlineResource():IOnlineResource;

		/**
		 * Time period (including time zone) when individuals can contact the organization or individual.
		 *
		 * @return Time period when individuals can contact the organization or individual, or null.
		 */
		function get hoursOfService():String;

		/**
		 * Supplemental instructions on how or when to contact the individual or organization.
		 *
		 * @return Supplemental instructions on how or when to contact the individual or organization,
		 * or null.
		 */
		function get contactInstructions():String;

	}

}
