package org.opengis.geometry {
  
	import org.opengis.referencing.crs.ICoordinateReferenceSystem;
	
	public interface IDirectPosition {
    
		/**
		 * A copy of the ordinates presented as an array of Number values.
		 */
		function get coordinate():Array /* of Number */;
		
		/**
		 * The length of coordinate sequence (the number of entries).
		 */
		function get dimension():uint;
		
		/**
		 * Returns the ordinate at the specified dimension.
		 */
		function getOrdinate(dimension:uint):Number;
		
		/**
		 * Sets the ordinate value along the specified dimension
		 */
		function setOrdinate(dimension:uint, value:Number):void;
		
		/**
		 * The coordinate reference system in which the coordinate is given.
		 */
		function get coordinateReferenceSystem():ICoordinateReferenceSystem;
		
	}
}
