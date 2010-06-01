package org.openscales.geometry
{
	import org.flexunit.Assert;

	public class OperationGeometryTest
	{
		/**
		 * Test to transform gemetry in vector of point
		 */
		[Test] public function testGeometryToVertices():void {
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
			
			var testVectorPoint:Vector.<Point> = linearRing.toVertices();
			Assert.assertEquals(  Number(4.5727844237936415),testVectorPoint[0].x);
			Assert.assertEquals(  Number(45.713361819965364),testVectorPoint[0].y);
			Assert.assertEquals(  Number(5.0300903319148516),testVectorPoint[1].x);
			Assert.assertEquals(  Number(45.713361819965364),testVectorPoint[1].y);
			Assert.assertEquals(  Number(5.0300903319148516),testVectorPoint[2].x);
			Assert.assertEquals(  Number(45.659157810588724),testVectorPoint[2].y);
			Assert.assertEquals(  Number(4.5727844237936415),testVectorPoint[3].x);
			Assert.assertEquals(  Number(45.659157810588724),testVectorPoint[3].y);

			Assert.assertEquals(testVectorPoint.length,4);
			
		}
		
		/**
		 * Test addcomponent function 
		 */
		[Test] public function testGeometryAddComponent():void {
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
			var point:Point = new Point(8.4527844237936415,80.45454545454);
			var pointTest:Point = linearRing.getPointAt(2);
			linearRing.addComponent(point,2);
			Assert.assertTrue(point.x,pointTest.x);
			Assert.assertTrue(point.y,pointTest.y);
		}
		
		/**
		 * Test addcomponent function 
		 */
		[Test] public function testGeometryAddPoint():void {
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
			var pointTest:Point = linearRing.getPointAt(2);
			linearRing.addPoint(8.4527844237936415,80.45454545454,2);
			Assert.assertTrue(8.4527844237936415,pointTest.x);
			Assert.assertTrue(80.45454545454,pointTest.y);
			
		}
	}
}