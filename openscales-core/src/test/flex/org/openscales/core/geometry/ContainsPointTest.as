package org.openscales.core.geometry
{	
	import org.flexunit.Assert;
	import org.openscales.core.Map;
	import org.openscales.core.layer.VectorLayer;

	public class ContainsPointTest
	{
		
		/**
		 * Test all the cases for a LinearRing.
		 */
		[Test]
		public function testLinearRingContainsPoint():void {
						
			// Add a LineString.
			var arrayVertices:Array = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.5727844237936415, 45.713361819965364));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.0300903319148516, 45.713361819965364));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.0300903319148516, 45.659157810588724));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.5727844237936415, 45.659157810588724));
			var linearRing:LinearRing = new LinearRing(arrayVertices);
			
			// Add a point into the LineString
			var point:org.openscales.core.geometry.Point = new org.openscales.core.geometry.Point(4.78, 45.7);
			
			// Test inclusion = "Does the outer LinearRing of the blue Polygon contain the red point (true) ? => "+testResult;
			Assert.assertTrue(linearRing.containsPoint(point));

		}
		
	}
}