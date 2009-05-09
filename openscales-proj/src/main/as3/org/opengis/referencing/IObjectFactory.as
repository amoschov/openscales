/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/ObjectFactory.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing
{
    import org.opengis.referencing.IFactory;

    /**
     * Base interface for all factories of identified objects. Factories build up complex objects from
     * simpler objects or values. This factory allows applications to make coordinate systems, datum or
     * coordinate reference systems  that cannot be created by an authority factory. This factory is
     * very flexible, whereas the authority factory is easier to use.
     *
     * <b>Object properties</b>
     * <p>Most factory methods expect an Object argument that is a properties instance.</p>
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface IObjectFactory extends IFactory {

    }

}
