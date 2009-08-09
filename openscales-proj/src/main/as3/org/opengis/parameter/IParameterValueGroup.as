/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/parameter/ParameterValueGroup.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.parameter {
	import org.opengis.parameter.IGeneralParameterValue;
	import org.opengis.parameter.IParameterValueGroup;
	import org.opengis.parameter.IParameterValue;

	/**
	 * A group of related parameter values. The same group can be repeated more than once in an
	 * operation or higher level ParameterValueGroup, if those instances contain different values of one
	 * or more IParameterValue which suitably distinquish among those groups.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IParameterValueGroup extends IGeneralParameterValue {

		/**
		 * Create a new group of the specified name. The specified name must be the identifier code of a
		 * descriptor group.
		 *
		 * @param name The case insensitive identifier code of the parameter group to create.
		 *
		 * @return A newly created parameter group for the given identifier code.
		 *
		 * @throws ParameterNotFoundError if no descriptor was found for the given name.
		 * @throws Error if this parameter group already contains the maximum number of occurences of
		 *               subgroups of the given name.
		 */
		function addGroup(name:String):IParameterValueGroup;

		/**
		 * Return all subgroups with the specified name. This method do not create new groups. If the
		 * requested group is optional (i.e. minimumOccurs == 0) and no value were defined previously,
		 * then this method returns an empty set.
		 *
		 * @param name The case insensitive identifier code of the parameter group to search for.
		 *
		 * @return The set of all parameter group for the given identifier code.
		 *
		 * @throws ParameterNotFoundError if no descriptor was found for the given name.
		 */
		function groups(name:String):IParameterValueGroup;

		/**
		 * Return the value in this group for the specified identifier code. If no parameter value is
		 * found but a parameter descriptor is found (which may occurs if the parameter is optional,
		 * i.e. minimumOccurs == 0), then a parameter value is automatically created and initialized to
		 * its default value (if any).
		 *
		 * This convenience method provides a way to get and set parameter values by name. For example
		 * the following idiom fetches a floating point value for the "false_easting" parameter:
		 *
		 * <listing version="3.0">
		 *      var value:number= parameter("false_easting").numberValue();
		 * </listing>
		 *
		 * This method do not search recursively in subgroups. This is because more than one subgroup
		 * may exist for the same descriptor. The user must query all subgroups and select explicitly
		 * the appropriate one to use.
		 * @param name The case insensitive identifier code of the parameter to search for.
		 *
		 * @return A newly created parameter group for the given identifier code.
		 *
		 * @throws ParameterNotFoundError if there is no parameter value for the given identifier code.
		 */
		function parameter(name:String):IParameterValue;

		/**
		 * Return the values in this group. The returned list may or may not be unmodifiable; this is
		 * implementation-dependent. However, if some aspects of this list are modifiable, then any
		 * modification shall be reflected back into this IParameterValueGroup. More
		 * specifically:<ul>
		 * <li>if the list supports the add operation, then it should ensure that the added general
		 *     parameter value is valid and can be added to this group. An
		 *     InvalidParameterCardinalityError (or any other appropriate error) shall be thrown if it is
		 *     not the case.</li>
		 * <li>The list may also supports the remove operation as a way to remove parameter created by
		 *     the parameter() method.</li>
		 *
		 * @return The values in this group (array of IGeneralParameterValue).
		 */
		function values():Array;

	}

}
