/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/cs/CSFactory.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.cs {
	import org.opengis.referencing.IObjectFactory;
	import org.opengis.referencing.cs.ICoordinateSystemAxis;
	import org.opengis.referencing.cs.AxisDirection;
	import org.opengis.referencing.cs.IAffineCS;
	import org.opengis.referencing.cs.ICartesianCS;
	import org.opengis.referencing.cs.ICylindricalCS;
	import org.opengis.referencing.cs.IEllipsoidalCS;
	import org.opengis.referencing.cs.ISphericalCS;

	/**
	 * Build up complex coordinate systems from simpler objects or values. This factory is very
	 * flexible, whereas the authority factory is easier to use. This factory can be used to make
	 * "special" coordinate systems.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface ICSFactory extends IObjectFactory {

		/**
		 * Create a coordinate system axis from an abbreviation and a unit.
		 *
		 * @param properties Name and other properties to give to the new object.
		 * @param abbreviation The coordinate axis abbreviation.
		 * @param direction The axis direction.
		 * @param unit The coordinate axis unit.
		 *
		 * @return The axis for the given properties.
		 *
		 * @throws FactoryError if the object creation failed.
		 */
		function createCoordinateSystemAxis(properties:Object, abbreviation:String, direction:AxisDirection, unit:String):ICoordinateSystemAxis;

		/**
		 * Create a two/three dimensional cartesian coordinate system from the given set of axis.
		 *
		 * @param properties Name and other properties to give to the new object.
		 * @param axis0 The first axis.
		 * @param axis1 The second axis.
		 * @param axis2 The third optional axis.
		 *
		 * @return The coordinate system for the given properties and axis.
		 *
		 * @throws FactoryError if the object creation failed.
		 */
		function createCartesianCS(properties:Object, axis:ICoordinateSystemAxis, axis1:ICoordinateSystemAxis, axis2:ICoordinateSystemAxis=null):ICartesianCS;

		/**
		 * Create a two/three dimensional coordinate system from the given set of axis.
		 *
		 * @param properties Name and other properties to give to the new object.
		 * @param axis0 The first axis.
		 * @param axis1 The second axis.
		 * @param axis2 The third optional axis.
		 *
		 * @return The coordinate system for the given properties and axis.
		 *
		 * @throws FactoryError if the object creation failed.
		 */
		function createAffineCS(properties:Object, axis0:ICoordinateSystemAxis, axis1:ICoordinateSystemAxis, axis2:ICoordinateSystemAxis=null):IAffineCS;

		/**
		 * Create a cylindrical coordinate system from the given set of axis.
		 *
		 * @param properties Name and other properties to give to the new object.
		 * @param axis0 The first axis.
		 * @param axis1 The second axis.
		 * @param axis2 The third optional axis.
		 *
		 * @return The coordinate system for the given properties and axis.
		 *
		 * @throws FactoryError if the object creation failed.
		 */
		function createCylindricalCS(properties:Object, axis0:ICoordinateSystemAxis, axis1:ICoordinateSystemAxis, axis2:ICoordinateSystemAxis):ICylindricalCS;

		/**
		 * Create a spherical coordinate system from the given set of axis.
		 *
		 * @param properties Name and other properties to give to the new object.
		 * @param axis0 The first axis.
		 * @param axis1 The second axis.
		 * @param axis2 The third optional axis.
		 *
		 * @return The coordinate system for the given properties and axis.
		 *
		 * @throws FactoryError if the object creation failed.
		 */
		function createSphericalCS(properties:Object, axis0:ICoordinateSystemAxis, axis1:ICoordinateSystemAxis, axis2:ICoordinateSystemAxis):ISphericalCS;

		/**
		 * Create an ellipsoidal coordinate system without ellipsoidal height.
		 *
		 * @param properties Name and other properties to give to the new object.
		 * @param axis0 The first axis.
		 * @param axis1 The second axis.
		 * @param axis2 The third optional axis.
		 *
		 * @return The coordinate system for the given properties and axis.
		 *
		 * @throws FactoryError if the object creation failed.
		 */
		function createEllipsoidalCS(properties:Object, axis0:ICoordinateSystemAxis, axis1:ICoordinateSystemAxis, axis2:ICoordinateSystemAxis=null):IEllipsoidalCS;

	}

}
