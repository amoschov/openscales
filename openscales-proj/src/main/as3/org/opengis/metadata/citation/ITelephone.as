/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/Telephone.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation {

	/**
	 * Telephone numbers for contacting the responsible individual or organization.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface ITelephone {

		/**
		 * Telephone numbers by which individuals can speak to the responsible organization or
		 * individual.
		 *
		 * @return Telephone numbers by which individuals can speak to the responsible organization or
		 *         individual.
		 */
		function get voice():Array;

		/**
		 * Telephone numbers of a facsimile machine for the responsible organization or individual.
		 *
		 * @return Telephone numbers of a facsimile machine for the responsible organization or
		 *         individual.
		 */
		function get facsimile():Array;

	}

}
