package org.openscales.geometry
{
	import org.flexunit.Assert;

	public class OperationGeometryTest
	{
		/**
		 * Test all the cases for a LinearRing.
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
			Assert.assertEquals(  Number(4.5727844237936415),testVectorPoint[0]);
			Assert.assertEquals(  Number(45.713361819965364),testVectorPoint[1]);
			Assert.assertEquals(  Number(5.0300903319148516),testVectorPoint[2]);
			Assert.assertEquals(  Number(45.713361819965364),testVectorPoint[3]);
			Assert.assertEquals(  Number(5.0300903319148516),testVectorPoint[4]);
			Assert.assertEquals(  Number(45.659157810588724),testVectorPoint[5]);
			Assert.assertEquals(  Number(4.5727844237936415),testVectorPoint[6]);
			Assert.assertEquals(  Number(45.659157810588724),testVectorPoint[7]);

			Assert.assertEquals(testVectorPoint.length,4);
			
		}
	}
}