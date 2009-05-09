/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/operation/Matrix.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.operation
{
    /**
     * A two dimensional array of numbers. Row and column numbering begins with zero.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IMatrix {

        /**
         * Return the number of rows in this matrix.
         *
         * @return The number of rows in this matrix.
         */
        function get numRow ( ) : Number;

        /**
         * Return the number of columns in this matrix.
         *
         * @return The number of columns in this matrix.
         */
        function get numCol ( ) : Number;

        /**
         * Retrieve the value at the specified row and column of this matrix.
         *
         * @param row The row number to be retrieved (zero indexed).
         * @param column The column number to be retrieved (zero indexed).
         *
         * @return The value at the indexed element.
         */
        function getElement ( row:Number, column:Number ) : Number;

        /**
         * Modify the value at the specified row and column of this matrix.
         *
         * @param row The row number to be retrieved (zero indexed).
         * @param column The column number to be retrieved (zero indexed).
         * @param value The new matrix element value.
         */
        function setElement ( row:Number, column:Number, value:Number) : void;

        /**
         * Returns true if this matrix is an identity matrix using the provided tolerance. This method
         * is equivalent to computing the difference between this matrix and an identity matrix of
         * identical size, and returning true if and only if all differences are smaller than or equal
         * to tolerance.
         *
         * @param tolerance The tolerance value.
         * @return true if this matrix is close enough to the identity matrix given the tolerance value.
         */
        function isIdentity ( tolerance:Number= NaN ) : Boolean;

    }

}
