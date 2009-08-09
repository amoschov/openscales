/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/parameter/ParameterDescriptor.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.parameter {
	import org.opengis.parameter.IGeneralParameterDescriptor;

	/**
	 * The definition of a parameter used by an operation method. Most parameter values are numeric, but
	 * other types of parameter values are possible.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IParameterDescriptor extends IGeneralParameterDescriptor {

		/**
		 * Return the default value for the parameter. The return type can be any type including a
		 * Number or a String. If there is no default value, then this method returns null.
		 *
		 * @return The default value, or null in none.
		 */
		function get defaultValue():*;

		/**
		 * Return the maximum parameter value. If there is no maximum value, or if maximum value is
		 * inappropriate for the parameter type, then this method returns null.
		 * When the getValueClass() is an array or Collection getMaximumValue may be used to constrain
		 * the contained elements.
		 *
		 * @return The minimum parameter value (often an instance of Number), or null.
		 */
		function get maximumValue():*;

		/**
		 * Return the minimum parameter value. If there is no minimum value, or if minimum value is
		 * inappropriate for the parameter type, then this method returns null.
		 * When the getValueClass() is an array or Collection getMinimumValue may be used to constrain
		 * the contained elements.
		 *
		 * @return The minimum parameter value (often an instance of Number), or null.
		 */
		function get minimumValue():*;

		/**
		 * Return the unit for default, minimum and maximum values. This attribute apply only if the
		 * values is of numeric type (usually an instance of Number).
		 *
		 * @return The unit for numeric value, or null if it doesn't apply to the value type.
		 */
		function get unit():String;

		/**
		 * Return the set of allowed values when these are restricted to some finite set or returns null
		 * otherwise. The returned set usually contains code list  or enumeration elements.
		 *
		 * @return A finite set of valid values (usually from a code list), or null if it doesn't apply.
		 */
		function getValidValues():Array;

		/**
		 * Return the class that describe the type of the parameter.
		 *
		 * @return The type of parameter values.
		 */
		function getValueClass():Class;

	}

}
