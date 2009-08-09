/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/parameter/ParameterValue.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.parameter {
	import org.opengis.parameter.IGeneralParameterValue;

	/**
	 * A parameter value used by an operation method. Most parameter values are numeric, but other types
	 * of parameter values are possible. The getValue() and setValue(Object) methods can be invoked at
	 * any time.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IParameterValue extends IGeneralParameterValue {

		/**
		 * Return the unit of measure of the parameter value. If the parameter value has no unit (for
		 * example because it is a String type), then this method returns null. Note that "no unit"
		 * doesn't means "dimensionless".
		 *
		 * @return The unit of measure of the parameter value.
		 */
		function get unit():String;

		/**
		 * Return the parameter value as an object.
		 *
		 * @return The parameter value as an object.
		 */
		function get value():*;

		/**
		 * Set the parameter value as an object. The argument is not restricted to the parameterized
		 * type because the type is typically unknown (as in group.parameter("name").setValue(value))
		 * and because some implementations may choose to convert a wider range of types.
		 *
		 * @param value The parameter value.
		 *
		 * @throws InvalidParameterValueError if the type of value is inappropriate for this parameter,
		 *                                    or if the value is illegal for some other reason (for
		 *                                    example the value is numeric and out of range).
		 */
		function set value(value:*):void;

	}

}
