/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/parameter/InvalidParameterValueException.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.parameter
{

    /**
     * Thrown when an invalid value was given to a parameter.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class InvalidParameterValueError extends Error {

        /**
         * Creates an exception.
         *
         * @param message the error message.
         * @param int the error number.
         */
        public function InvalidParameterValueError ( message:String= "", id:int= 0 ) {
            super(message, id);
        }

    }

}
