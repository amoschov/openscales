/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/operation/Transformation.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.operation
{
    import org.opengis.referencing.operation.IOperation;

    /**
     * An operation on coordinates that usually includes a change of Datum. The parameters of a coordinate transformation are empirically derived from data containing the coordinates of a series of points in both coordinate reference systems. This computational process is usually "over-determined", allowing derivation of error (or accuracy) estimates for the transformation. Also, the stochastic nature of the parameters may result in multiple (different) versions of the same coordinate transformation.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface ITransformation extends IOperation {

    }

}
