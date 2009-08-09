/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/operation/OperationMethod.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.operation {
	import org.opengis.referencing.IIdentifiedObject;
	import org.opengis.parameter.IParameterDescriptorGroup;

	/**
	 * Definition of an algorithm used to perform a coordinate operation. Most operation methods use a
	 * number of operation parameters, although some coordinate conversions use none. Each coordinate
	 * operation using the method assigns values to these parameters.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IOperationMethod extends IIdentifiedObject {

		/**
		 * Formula(s) or procedure used by this operation method. This may be a reference to a
		 * publication. Note that the operation method may not be analytic, in which case this attribute
		 * references or contains the procedure, not an analytic formula.
		 *
		 * @return The formula used by this method.
		 */
		function get formula():String;

		/**
		 * Number of dimensions in the source CRS of this operation method.
		 *
		 * @return The dimension of source CRS.
		 */
		function get sourceDimensions():Number;

		/**
		 * Number of dimensions in the target CRS of this operation method.
		 *
		 * @return The dimension of target CRS.
		 */
		function get targetDimensions():Number;

		/**
		 * The set of parameters.
		 *
		 * @return The parameters, or an empty group if none.
		 */
		function get parameters():IParameterDescriptorGroup;

	}

}
