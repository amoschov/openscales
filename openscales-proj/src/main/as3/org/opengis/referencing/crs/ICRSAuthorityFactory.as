/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referencing/CRSAuthorityFactory.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.crs {
	import org.opengis.referencing.IAuthorityFactory;
	import org.opengis.referencing.crs.ICoordinateReferenceSystem;
	import org.opengis.referencing.crs.IGeocentricCRS;
	import org.opengis.referencing.crs.IGeographicCRS;
	import org.opengis.referencing.crs.IProjectedCRS;

	import org.opengis.referencing.NoSuchAuthorityCodeError;
	import org.opengis.referencing.FactoryError;

	/**
	 * Creates coordinate reference systems using authority codes. External authorities are used to
	 * manage definitions of objects used in this interface. The definitions of these objects are
	 * referenced using code strings. A commonly used authority is EPSG.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public interface ICRSAuthorityFactory extends IAuthorityFactory {

		/**
		 * Return an arbitrary coordinate reference system from a code. If the coordinate reference
		 * system type is know at compile time, it is recommended to invoke the most precise method
		 * instead of this one (for example  createGeographicCRS(code) instead of
		 * createCoordinateReferenceSystem(code) if the caller knows, he is asking for a geographic
		 * coordinate reference system).
		 *
		 * @param code Value allocated by authority.
		 *
		 * @return The coordinate reference system for the given code.
		 *
		 * @throws NoSuchAuthorityCodeError if the specified code was not found.
		 * @throws FactoryError if the object creation failed for some other reason.
		 */
		function createCoordinateReferenceSystem(code:String):ICoordinateReferenceSystem;

		/**
		 * Return a derived coordinate reference system from a code.
		 *
		 * @param code Value allocated by authority.
		 *
		 * @return The coordinate reference system for the given code.
		 *
		 * @throws NoSuchAuthorityCodeError if the specified code was not found.
		 * @throws FactoryError if the object creation failed for some other reason.
		 */
		function createDerivedCRS(code:String):IDerivedCRS;

		/**
		 * Return a geographic coordinate reference system from a code.
		 *
		 * @param code Value allocated by authority.
		 *
		 * @return The coordinate reference system for the given code.
		 *
		 * @throws NoSuchAuthorityCodeError if the specified code was not found.
		 * @throws FactoryError if the object creation failed for some other reason.
		 */
		function createGeographicCRS(code:String):IGeographicCRS;

		/**
		 * Return a geocentric coordinate reference system from a code.
		 *
		 * @param code Value allocated by authority.
		 *
		 * @return The coordinate reference system for the given code.
		 *
		 * @throws NoSuchAuthorityCodeError if the specified code was not found.
		 * @throws FactoryError if the object creation failed for some other reason.
		 */
		function createGeocentricCRS(code:String):IGeocentricCRS;

		/**
		 * Return a projected coordinate reference system from a code.
		 *
		 * @param code Value allocated by authority.
		 *
		 * @return The coordinate reference system for the given code.
		 *
		 * @throws NoSuchAuthorityCodeError if the specified code was not found.
		 * @throws FactoryError if the object creation failed for some other reason.
		 */
		function createProjectedCRS(code:String):IProjectedCRS;

	}

}
