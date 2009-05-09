/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/operation/CoordinateOperation.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.operation
{
    import org.opengis.metadata.extent.IExtent;
    import org.opengis.referencing.IIdentifiedObject;
    import org.opengis.referencing.crs.ICoordinateReferenceSystem;
    import org.opengis.referencing.operation.IMathTransform;

    /**
     * A mathematical operation on coordinates that transforms or converts coordinates to another
     * coordinate reference system. Many but not all coordinate operations (from coordinate reference
     * system A to coordinate reference system B) also uniquely define the inverse operation (from
     * coordinate reference system B to coordinate reference system A). In some cases, the operation
     * method algorithm for the inverse operation is the same as for the forward algorithm, but the
     * signs of some operation parameter values must be reversed. In other cases, different algorithms
     * are required for the forward and inverse operations, but the same operation parameter values are
     * used. If (some) entirely different parameter values are needed, a different coordinate operation
     * shall be defined.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface ICoordinateOperation extends IIdentifiedObject {

        /**
         * Return the source CRS. The source CRS is mandatory for transformations only. Conversions may
         * have a source CRS that is not specified here, but through IGeneralDerivedCRS.getBaseCRS()
         * instead.
         *
         * @return The source CRS, or null if not available.
         */
        function get sourceCRS ( ) : ICoordinateReferenceSystem;

        /**
         * Return the target CRS. The target CRS is mandatory for transformations only. Conversions may
         * have a target CRS that is not specified here, but through IGeneralDerivedCRS instead.
         *
         * @return The target CRS, or null if not available.
         */
        function get targetCRS ( ) : ICoordinateReferenceSystem;

        /**
         * Version of the coordinate transformation (i.e., instantiation due to the stochastic nature of
         * the parameters). Mandatory when describing a transformation, and should not be supplied for a
         * conversion.
         *
         * @return The coordinate operation version, or null in none.
         */
        function get operationVersion ( ) : String;

        /**
         * Estimate(s) of the impact of this operation on point accuracy. Gives position error estimates
         * for target coordinates of this coordinate operation, assuming no errors in source coordinates.
         *
         * @return The position error estimates, or an empty collection of IPositionalAccuracy if not
         *         available.
         */
        function get coordinateOperationAccuracy ( ) : Array;

        /**
         * Area or region or timeframe in which this coordinate operation is valid.
         *
         * @return The coordinate operation valid domain, or null if not available.
         */
        function get domainOfValidity ( ) : IExtent;

        /**
         * Description of domain of usage, or limitations of usage, for which this operation is valid.
         *
         * @return A description of domain of usage, or null if none.
         */
        function get scope ( ) : String;

        /**
         * Gets the math transform. The math transform will transform positions in the source coordinate
         * reference system into positions in the target coordinate reference system. It may be null in
         * the case of defining conversions.
         *
         * @return The transform from source to target CRS, or null if not applicable.
         */
        function get mathTransform ( ) : IMathTransform;

    }

}
