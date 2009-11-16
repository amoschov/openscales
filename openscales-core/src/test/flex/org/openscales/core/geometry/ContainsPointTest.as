package org.openscales.core.geometry
{	
	import org.flexunit.Assert;

	public class ContainsPointTest
	{
		
		/**
		 * Test all the cases for a LinearRing.
		 */
		[Test] public function testLinearRingContainsPoint():void {
			// Create a LinearRing.
			var arrayVertices:Array = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.5727844237936415, 45.713361819965364));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.0300903319148516, 45.713361819965364));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.0300903319148516, 45.659157810588724));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.5727844237936415, 45.659157810588724));
			var linearRing:LinearRing = new LinearRing(arrayVertices);
			// Create a point into the LinearRing and test the inclusion
			var pointIn:org.openscales.core.geometry.Point = new org.openscales.core.geometry.Point(4.78, 45.7);
			Assert.assertTrue(linearRing.containsPoint(pointIn));
			// Create a point onto the LinearRing and test the inclusion
			//var pointOn:org.openscales.core.geometry.Point = new org.openscales.core.geometry.Point();
			//Assert.assertTrue(linearRing.containsPoint(pointOn));
			// Create a point out of the LinearRing and test the inclusion
			//var pointOut:org.openscales.core.geometry.Point = new org.openscales.core.geometry.Point();
			//Assert.assertTrue(linearRing.containsPoint(pointOut));
		}
		
		/**
		 * Test all the cases for a Polygon.
		 */
		[Test] public function testPolygonContainsPoint():void {
			// Create a Polygon.
			var rings:Array = new Array();
			var arrayVertices:Array = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.5727844237936415, 45.713361819965364));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.0300903319148516, 45.713361819965364));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.0300903319148516, 45.659157810588724));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.5727844237936415, 45.659157810588724));
			rings.push(new LinearRing(arrayVertices));
			var polygon:Polygon = new Polygon(rings);
			// Create a point into the Polygon and test the inclusion
			var pointIn:org.openscales.core.geometry.Point = new org.openscales.core.geometry.Point(4.78, 45.7);
			Assert.assertTrue(polygon.containsPoint(pointIn));
			// Create a point onto the Polygon and test the inclusion
			//var pointOn:org.openscales.core.geometry.Point = new org.openscales.core.geometry.Point();
			//Assert.assertTrue(polygon.containsPoint(pointOn));
			// Create a point out of the Polygon and test the inclusion
			//var pointOut:org.openscales.core.geometry.Point = new org.openscales.core.geometry.Point();
			//Assert.assertTrue(polygon.containsPoint(pointOut));
		}
		
	}
}