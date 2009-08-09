/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/Factory.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing {
	import org.opengis.metadata.citation.ICitation;

	/**
	 * Base interface for all factories. Factories can be grouped in two categories:<ul>
	 *      <li>Authority factories creates objects from a compact string defined by an authority.</li>
	 *      <li>Object factories allows applications to make objects that cannot be created by an
	 *      authority factory. This factory is very flexible, whereas the authority factory is easier to
	 *      use.</li></ul>
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IFactory {

		/**
		 * Returns the vendor responsible for creating this factory implementation.
		 *
		 * @return The vendor for this factory implementation.
		 */
		function get vendor():ICitation;

	}

}
