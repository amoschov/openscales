package org.openscales.geometry
{
	import org.flexunit.Assert;
	import org.openscales.basetypes.Bounds;

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
			linearRing.addComponent(point,2);
			var pointTest:Point = linearRing.getPointAt(2);
			Assert.assertEquals(point.x,pointTest.x);
			Assert.assertEquals(point.y,pointTest.y);
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
			linearRing.addPoint(8.4527844237936415,80.45454545454,2);
			var pointTest:Point = linearRing.getPointAt(2);
			Assert.assertEquals(8.4527844237936415,pointTest.x);
			Assert.assertEquals(80.45454545454,pointTest.y);
			
		}
		
		/**
		 * Test addcomponent function 
		 */
		[Test] public function testGeometryReplaceComponent():void {
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
			linearRing.replaceComponent(2,point);
			var pointTest:Point = linearRing.getPointAt(2);
			Assert.assertEquals(pointTest.x,point.x);
			Assert.assertEquals(pointTest.y,point.y);

			
		}
		
		/**
		 * Test addcomponent function 
		 */
		[Test] public function testGeometryBounds():void {
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
			var bounds:Bounds = linearRing.bounds;
			Assert.assertEquals(bounds.left,4.5727844237936415);
			Assert.assertEquals(bounds.right,5.0300903319148516);
			Assert.assertEquals(bounds.top,45.713361819965364);
			Assert.assertEquals(bounds.bottom,45.659157810588724);
			
			linearRing.addPoint(80,50);
 			bounds = linearRing.bounds;
			Assert.assertEquals(bounds.left,4.5727844237936415);
			Assert.assertEquals(bounds.right,80);
			Assert.assertEquals(bounds.top,50);
			Assert.assertEquals(bounds.bottom,45.659157810588724);
			
			
		}
		
		/**
		 * Test addcomponent function 
		 */
		[Test] public function testGeometryContains():void {
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
			var containsGeometry:Boolean = linearRing.contains(new Point(5,45.68));
			Assert.assertTrue(containsGeometry);
			containsGeometry = linearRing.contains(new Point(80,90));
			Assert.assertFalse(containsGeometry);
			
		}
	}
}