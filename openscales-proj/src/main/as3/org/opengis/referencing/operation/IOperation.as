/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/operation/Operation.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.operation
{
    import org.opengis.parameter.IParameterValueGroup;
    import org.opengis.referencing.operation.ISingleOperation;
    import org.opengis.referencing.operation.IOperationMethod;

    /**
     * A parameterized mathematical operation on coordinates that transforms or converts coordinates to
     * another coordinate reference system. This coordinate operation thus uses an operation method,
     * usually with associated parameter values.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IOperation extends ISingleOperation {

        /**
         * Return the operation method.
         *
         * @return The operation method.
         */
        function get method ( ) : IOperationMethod;

        /**
         * Returns the parameter values
         *
         * @return The parameter values.
         */
        function getParameterValues ( ) : IParameterValueGroup;

    }

}
