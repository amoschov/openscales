/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/ReferenceSystem.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing {
	import org.opengis.metadata.extent.IExtent;
	import org.opengis.referencing.IIdentifiedObject;

	/**
	 * Base interface for handling description of a spatial and temporal reference system used by a
	 * dataset.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IReferenceSystem extends IIdentifiedObject {

		/**
		 * Description of domain of usage, or limitations of usage, for which this (coordinate)
		 * reference system object is valid. "name" in referencesystem.xsd.
		 *
		 * @return The domain of usage, or null if none.
		 */
		function get scope():String;

		/**
		 * Area or region or timeframe in which this (coordinate) reference system is valid.
		 *
		 * @return The reference system valid domain, or null if not available.
		 */
		function get domainOfValidity():IExtent;

	}

}
