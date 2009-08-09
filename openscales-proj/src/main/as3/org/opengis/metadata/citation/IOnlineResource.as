/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/OnLineResource.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation {
	import org.opengis.metadata.citation.OnLineFunction;

	/**
	 * Information about on-line sources from which the dataset, specification, or community profile
	 * name and extended metadata elements can be obtained.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IOnlineResource {

		/**
		 * Location (address) for on-line access using a Uniform Resource Locator address or similar
		 * addressing scheme such as http://www.statkart.no/isotc211.
		 *
		 * @return Location for on-line access using a Uniform Resource Locator address or similar
		 *         scheme.
		 */
		function get linkage():String;

		/**
		 * Connection protocol to be used.
		 *
		 * @return Connection protocol to be used, or null.
		 */
		function get protocol():String;

		/**
		 * Name of the online resource.
		 *
		 * @return Name of the online resource, or null.
		 */
		function get name():String;

		/**
		 * Name of an application profile that can be used with the online resource.
		 *
		 * @return Application profile that can be used with the online resource, or null.
		 */
		function get applicationProfile():String;

		/**
		 * Detailed text description of what the online resource is/does.
		 *
		 * @return Text description of what the online resource is/does, or null.
		 */
		function get description():String;

		/**
		 * Code for function performed by the online resource.
		 *
		 * @return Function performed by the online resource, or null.
		 */
		function get onlineFunction():OnLineFunction;

	}

}
