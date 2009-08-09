/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/CitationDate.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation {
	import org.opengis.metadata.citation.DateType;

	/**
	 * Reference date and event used to describe it.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface ICitationDate {

		/**
		 * Reference date for the cited resource.
		 *
		 * @return Reference date for the cited resource.
		 */
		function get date():Date;

		/**
		 * Event used for reference date.
		 *
		 * @return Event used for reference date.
		 */
		function get dateType():DateType;

	}

}
