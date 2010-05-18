package org.openscales.core.geometry
{
	import org.flexunit.Assert;

	public class OperationGeometryTest
	{
		/**
		 * Test all the cases for a LinearRing.
		 */
		[Test] public function testGeometryToVertices():void {
			// Create a LinearRing.
			var arrayVertices:Vector.<Geometry> = new Vector.<Geometry>();
			arrayVertices.push(new Point(4.5727844237936415, 45.713361819965364));
			arrayVertices.push(new Point(5.0300903319148516, 45.713361819965364));
			arrayVertices.push(new Point(5.0300903319148516, 45.659157810588724));
			arrayVertices.push(new Point(4.5727844237936415, 45.659157810588724));
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
	}
}