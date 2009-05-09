/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/geometry/MismatchedDimensionException.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.geometry
{

    /**
     * Indicate that an operation cannot be completed properly because of a mismatch in the dimensions
     * of object attributes.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class MismatchedDimensionError extends Error {

        /**
         * Creates an error.
         *
         * @param message the error message.
         * @param int the error number.
         */
        public function MismatchedDimensionError ( message:String= "", id:int= 0 ) {
            super(message, id);
        }

    }

}
