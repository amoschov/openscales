/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/extent/GeographicExtent.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.extent {

	/**
	 * Base interface for geographic area of the dataset.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IGeographicExtent {

		/**
		 * Indication of whether the bounding polygon encompasses an area covered by the data
		 * (inclusion) or an area where data is not present (exclusion).
		 *
		 * @return true for inclusion, false for exclusion, or null if unspecified.
		 */
		function get inclusion():Boolean;

	}

}
