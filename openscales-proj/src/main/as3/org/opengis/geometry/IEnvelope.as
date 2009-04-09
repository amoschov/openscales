package org.opengis.geometry {
	
	/**
	 * A minimum bounding box or rectangle. Regardless of dimension, 
	 * an Envelope can be represented without ambiguity as two direct 
	 * positions (coordinate points). To encode an Envelope, it is sufficient 
	 * to encode these two points. This is consistent with all of the data types 
	 * in this specification, their state is represented by their publicly 
	 * accessible attributes. 
	 */
	public interface IEnvelope {
		
		/**  
		 * A coordinate position consisting of all the minimal ordinates for each 
		 * dimension of all the points within the Envelope.
		 */ 
		function getLowerCorner():IDirectPosition;
		
		/**
		 * A coordinate position consisting of all the maximal ordinates for each 
		 * dimension of all the points within the Envelope.
		 */
		function getUpperCorner():IDirectPosition;
		
		/**
		 * A coordinate position consisting of all the median ordinates for each 
		 * dimension of all the points within the Envelope.
		 */
		function getCenter():IDirectPosition;
		
		/** The length of coordinate sequence (the number of entries) in this envelope. */
		function get dimension():Number
		
		/** Returns the minimal ordinate along the specified dimension. */
		function getMinimum(dimension:int):Number;
		 
		/** Returns the maximal ordinate along the specified dimension. */
		function getMaximum(dimension:int):Number;
		
		/** Returns the median ordinate along the specified dimension. */
		function getMedian(dimension:int):Number;
		
		/** 
		 * Returns the envelope span (typically width or height) along 
		 * the specified dimension.
		 */
		function getSpan(dimension:int):Number;
		 
	}
}