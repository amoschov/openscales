package org.openscales.core
{
	import org.flexunit.Assert;
	import org.openscales.core.basetypes.Size;
	
	public class MapTest
	{
		[Test]
		public function testEmptyNewMap( ) : void {
			var map:Map = new Map();
			Assert.assertNotNull(map);
		}
		
		[Test]
		public function testSize( ) : void {
			var map:Map = new Map();
			var size:Size = new Size(100, 200);
			map.size = size;	
			Assert.assertEquals(size.h, map.size.h);
			Assert.assertEquals(size.w, map.size.w);
		}

	}
}