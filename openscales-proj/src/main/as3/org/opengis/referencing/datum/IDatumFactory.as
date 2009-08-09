/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/datum/DatumFactory.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.datum {
	import org.opengis.referencing.IObjectFactory;
	import org.opengis.referencing.datum.IEllipsoid;
	import org.opengis.referencing.datum.IGeodeticDatum;
	import org.opengis.referencing.datum.IPrimeMeridian;

	/**
	 * Build up complex datums from simpler objects or values. This factory is very flexible, whereas
	 * the authority factory is easier to use. This factory can be used to make "special" datums.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface IDatumFactory extends IObjectFactory {

		/**
		 * Create geodetic datum from ellipsoid and (optionaly) Bursa-Wolf parameters.
		 *
		 * @param properties Name and other properties to give to the new object.
		 * @param ellipsoid Ellipsoid to use in new geodetic datum.
		 * @param primeMeridian Prime meridian to use in new geodetic datum.
		 *
		 * @return The datum for the given properties.
		 *
		 * @throws FactoryError if the object creation failed.
		 */
		function createGeodeticDatum(properties:Object, ellipsoid:IEllipsoid, primeMeridian:IPrimeMeridian):IGeodeticDatum;

		/**
		 * Create an ellipsoid from radius values.
		 *
		 * @param properties Name and other properties to give to the new object.
		 * @param semiMajorAxis Equatorial radius in supplied linear units.
		 * @param semiMinorAxis Polar radius in supplied linear units.
		 * @param unit Linear units of ellipsoid axis.
		 *
		 * @return The ellipsoid for the given properties.
		 *
		 * @throws FactoryError if the object creation failed.
		 */
		function createEllipsoid(properties:Object, semiMajorAxis:Number, semiMinorAxis:Number, unit:String):IEllipsoid;

		/**
		 * Create an ellipsoid from an major radius, and inverse flattening.
		 *
		 * @param properties Name and other properties to give to the new object.
		 * @param semiMajorAxis Equatorial radius in supplied linear units.
		 * @param inverseFlattening Eccentricity of ellipsoid.
		 * @param unit Linear units of major axis.
		 *
		 * @return The ellipsoid for the given properties.
		 *
		 * @throws FactoryError if the object creation failed.
		 */
		function createFlattenedSphere(properties:Object, semiMajorAxis:Number, inverseFlattening:Number, unit:String):IEllipsoid;

		/**
		 * Create a prime meridian, relative to Greenwich.
		 *
		 * @param properties Name and other properties to give to the new object.
		 * @param longitude Longitude of prime meridian in supplied angular units East of Greenwich.
		 * @param unit Angular units of longitude.
		 *
		 * @return The prime meridian for the given properties.
		 *
		 * @throws FactoryError if the object creation failed.
		 */
		function createPrimeMeridian(properties:Object, longitude:Number, unit:String):IPrimeMeridian;

	}

}
