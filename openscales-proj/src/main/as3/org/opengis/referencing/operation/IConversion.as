/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/operation/Conversion.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.operation
{
    import org.opengis.referencing.operation.IOperation;

    /**
     * An operation on coordinates that does not include any change of Datum. The best-known example of
     * a coordinate conversion is a map projection. The parameters describing coordinate conversions are
     * defined rather than empirically derived.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IConversion extends IOperation {

    }

}
