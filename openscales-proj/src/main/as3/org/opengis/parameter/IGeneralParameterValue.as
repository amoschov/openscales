/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/parameter/GeneralParameterValue.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.parameter {
	import org.opengis.parameter.IGeneralParameterDescriptor;

	/**
	 * Abstract parameter value or group of parameter values.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IGeneralParameterValue {

		/**
		 * Return the abstract definition of this parameter or group of parameters.
		 *
		 * @return The abstract definition of this parameter or group of parameters.
		 */
		function get descriptor():IGeneralParameterDescriptor;

	}

}
