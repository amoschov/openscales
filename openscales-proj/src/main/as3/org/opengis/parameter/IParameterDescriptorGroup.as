/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/parameter/ParameterDescriptorGroup.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.parameter
{
    import org.opengis.parameter.IGeneralParameterDescriptor;
    import org.opengis.parameter.IParameterValue;

    /**
     * The definition of a group of related parameters used by an operation method.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IParameterDescriptorGroup extends IGeneralParameterDescriptor {

        /**
         * Return the parameter descriptor in this group for the specified identifier code.
         *
         * @param name The case insensitive identifier code of the parameter to search for.
         *
         * @return The parameter for the given identifier code.
         *
         * @throws ParameterNotFoundError if there is no parameter for the given identifier code.
         */
        function descriptor ( name:String ) : IGeneralParameterDescriptor;

        /**
         * Returns the parameters in this group.
         *
         * @return The descriptor of this group as an array of IGeneralParameterDescriptor.
         */
        function descriptors ( ) : Array;

    }

}
