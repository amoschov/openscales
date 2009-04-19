package org.openscales.proj
{
	import org.opengis.geometry.IDirectPosition;
	
	
	/**
	 * Class for coordinate transforms between coordinate systems.
	 */
	public interface IProjection
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
		 * Transform a direct position from one projection to another
		 */
		function forward(pos:IDirectPosition):IDirectPosition;
		
		/**
		 * Inverse transform a point coordinate from one projection to another
		 */
		function inverse(pos:IDirectPosition):IDirectPosition; 
		
	}
}