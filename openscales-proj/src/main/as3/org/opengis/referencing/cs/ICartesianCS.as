/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/cs/CartesianCS.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.cs
{
    import org.opengis.referencing.cs.IAffineCS;

    /**
     * A 1-, 2-, or 3-dimensional coordinate system. Gives the position of points relative to orthogonal
     * straight axes in the 2- and 3-dimensional cases. In the 1-dimensional case, it contains a single
     * straight coordinate axis. In the multi-dimensional case, all axes shall have the same length unit
     * of measure. A ICartesianCS shall have one, two, or three axis associations.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface ICartesianCS extends IAffineCS {

    }

}
