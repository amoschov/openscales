package org.openscales.geometry
{	
	import org.flexunit.Assert;

	public class ContainsPointTest
	{
		
		/**
		 * Test all the cases for a LinearRing.
		 */
		[Test] public function testLinearRingContainsPoint():void {
			// Create a LinearRing.
			var arrayVertices:Vector.<Number> = new Vector.<Number>();
			arrayVertices.push(4.5727844237936415);
			arrayVertices.push(45.713361819965364);
			arrayVertices.push(5.0300903319148516);
			arrayVertices.push(45.713361819965364);
			arrayVertices.push(5.0300903319148516);
			arrayVertices.push(45.659157810588724);
			arrayVertices.push(4.5727844237936415);
			arrayVertices.push(45.659157810588724);
			var linearRing:LinearRing = new LinearRing(arrayVertices);
			// Create a point into the LinearRing and test the inclusion
			var pointIn:Point = new Point(4.78, 45.7);
			Assert.assertTrue(linearRing.containsPoint(pointIn));

		}
		
		[Test] public function testLinearRingNotContainsPoint():void {
			// Create a LinearRing.
			var arrayVertices:Vector.<Number> = new Vector.<Number>();
			arrayVertices.push(4.5727844237936415);
			arrayVertices.push(45.713361819965364);
			arrayVertices.push(5.0300903319148516);
			arrayVertices.push(45.713361819965364);
			arrayVertices.push(5.0300903319148516);
			arrayVertices.push(45.659157810588724);
			arrayVertices.push(4.5727844237936415);
			arrayVertices.push(45.659157810588724);
			var linearRing:LinearRing = new LinearRing(arrayVertices);
			// Create a point into the LinearRing and test the inclusion

			var pointIn2:Point = new Point(80, 90);
			Assert.assertFalse(linearRing.containsPoint(pointIn2));
		}
		
		/**
		 * Test all the cases for a Polygon.
		 */
		[Test] public function testPolygonContainsPoint():void {
			// Create a Polygon.
			var rings:Vector.<Geometry> = new Vector.<Geometry>();
			var arrayVertices:Vector.<Number> = new Vector.<Number>();
			arrayVertices.push(4.5727844237936415);
			arrayVertices.push(45.713361819965364);
			arrayVertices.push(5.0300903319148516);
			arrayVertices.push(45.713361819965364);
			arrayVertices.push(5.0300903319148516);
			arrayVertices.push(45.659157810588724);
			arrayVertices.push(4.5727844237936415);
			arrayVertices.push(45.659157810588724);
			rings.push(new LinearRing(arrayVertices));
			var polygon:Polygon = new Polygon(rings);
			// Create a point out the Polygon and test the inclusion
			var pointIn:Point = new Point(4.78, 45.7);
			Assert.assertTrue(polygon.containsPoint(pointIn));
			var pointIn2:Point = new Point(80, 90);
			Assert.assertFalse(polygon.containsPoint(pointIn2));

		}
		
		/**
		 * Test all the cases for a Polygon.
		 */
		[Test] public function testPolygonNotContainsPoint():void {
			// Create a Polygon.
			var rings:Vector.<Geometry> = new Vector.<Geometry>();
			var arrayVertices:Vector.<Number> = new Vector.<Number>();
			arrayVertices.push(4.5727844237936415);
			arrayVertices.push(45.713361819965364);
			arrayVertices.push(5.0300903319148516);
			arrayVertices.push(45.713361819965364);
			arrayVertices.push(5.0300903319148516);
			arrayVertices.push(45.659157810588724);
			arrayVertices.push(4.5727844237936415);
			arrayVertices.push(45.659157810588724);
			rings.push(new LinearRing(arrayVertices));
			var polygon:Polygon = new Polygon(rings);
			// Create a point out the Polygon and test the inclusion
			var pointIn2:Point = new Point(80, 90);
			Assert.assertFalse(polygon.containsPoint(pointIn2));

		}
		
	}
}