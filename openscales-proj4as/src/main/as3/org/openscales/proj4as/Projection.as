package org.openscales.proj4as
{
	import org.openscales.commons.geometry.Point;
	
	
	/**
	 * Class for coordinate transforms between coordinate systems.
	 */
	public interface Projection
	{
		
		/**
		 * Return the projection main name
		 */
		function get name():String;
		
		/**
		 * Return the projection names main name and its synonyms
		 */
		function get names():Array;

		/**
		 * Return the string SRS code.
		 */
		function get code():String;
		
		
		/**
		 * Return the units string for the projection
		 * Usually degrees or m
		 */
		function get units():String;
		
		/**
		 * Transform a point coordinate from one projection to another
		 */
		function forward(point:Point):Point;
		
		/**
		 * Inverse transform a point coordinate from one projection to another
		 */
		function inverse(point:Point):Point; 
		
	}
}