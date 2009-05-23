package org.openscales.proj.projections
{
	import flexunit.framework.TestCase;
	
	import org.opengis.geometry.IDirectPosition;
	import org.openscales.proj.geometry.DirectPosition2D;
	import org.openscales.proj.projections.Identity;

	public class IdentityTest extends TestCase
	{
		public function IdentityTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testForwardEquals():void
		{
			var pos:DirectPosition2D = new DirectPosition2D();
			pos.x = 1;
			pos.y = 2;
			var transformedPos:IDirectPosition = new Identity().forward(pos);
			assertTrue("testForwardEquals", pos == transformedPos);
		}
		
		public function testInverseEquals():void
		{
			var pos:DirectPosition2D = new DirectPosition2D();
			pos.x = 1;
			pos.y = 2;
			var transformedPos:IDirectPosition = new Identity().inverse(pos);
			assertTrue("testInverseEquals", pos == transformedPos);
		}


	}
}