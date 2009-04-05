package org.openscales.proj4as.projections
{
	import flexunit.framework.TestCase;
	
	import org.openscales.commons.geometry.Point;

	public class IdentityTest extends TestCase
	{
		public function IdentityTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testForwardEquals():void
		{
			var point:Point = new Point();
			point.x = 1;
			point.y = 2;
			var transformedPoint:Point = new Identity().forward(point);
			assertTrue("testForwardEquals", point == transformedPoint);
		}
		
		public function testInverseEquals():void
		{
			var point:Point = new Point();
			point.x = 1;
			point.y = 2;
			var transformedPoint:Point = new Identity().inverse(point);
			assertTrue("testInverseEquals", point == transformedPoint);
		}


	}
}