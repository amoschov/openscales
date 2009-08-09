/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/parameter/GeneralParameterDescriptor.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.parameter {
	import org.opengis.referencing.IIdentifiedObject;

	/**
	 * Abstract definition of a parameter or group of parameters used by an operation method.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IGeneralParameterDescriptor extends IIdentifiedObject {

		/**
		 * Create a new instance of parameter value or group  initialized with the default value(s).
		 *
		 * @return A new parameter initialized to its default value.
		 */
		function createValue():IGeneralParameterValue;

		/**
		 * The minimum number of times that values for this parameter group or parameter are required.
		 * The default value is one. A value of 0 means an optional parameter.
		 *
		 * @return The minimum occurence.
		 */
		function get minimumOccurs():Number;

		/**
		 * The maximum number of times that values for this parameter group or parameter can be
		 * included. For a single parameter, the value is always 1. For a parameter group, it may vary.
		 * The default value is one.
		 *
		 * @return The maximum occurence.
		 */
		function get maximumOccurs():Number;

	}

}
