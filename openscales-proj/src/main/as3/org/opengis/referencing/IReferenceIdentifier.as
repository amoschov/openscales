/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/ReferenceIdentifier.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing {
	import org.opengis.metadata.IIdentifier;

	/**
	 * Identifier used for reference systems.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IReferenceIdentifier extends IIdentifier {

		/**
		 * Name or identifier of the person or organization responsible for namespace.
		 *
		 * @return The identifier code space.
		 */
		function get codeSpace():String;

		/**
		 * Version identifier for the namespace, as specified by the code authority. When appropriate,
		 * the edition is identified by the effective date, coded using ISO 8601 date format.
		 *
		 * @return The version for the namespace (for example the version of the underlying EPSG
		 *         database).
		 */
		function get version():String;

	}

}
