package org.openscales.core
{
	import org.flexunit.Assert;
	import org.openscales.basetypes.Bounds;
	import org.openscales.basetypes.LonLat;
	import org.openscales.basetypes.Size;
	
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
		
		[Test]
		public function testDefaultMaxExtent( ) : void {
			var map:Map = new Map();
			var defaultMaxExtent:Bounds = map.maxExtent;
			
			// Default max extent shoudl be worldlide
			Assert.assertEquals(-180, defaultMaxExtent.left);
			Assert.assertEquals(-90, defaultMaxExtent.bottom);
			Assert.assertEquals(180, defaultMaxExtent.right);
			Assert.assertEquals(90, defaultMaxExtent.top);
		}
		
		[Test]
		public function testMaxExtent( ) : void {
			var map:Map = new Map();
			map.maxExtent = new Bounds(1, 2, 3, 4);
			var defaultMaxExtent:Bounds = map.maxExtent;
			
			Assert.assertEquals(1, defaultMaxExtent.left);
			Assert.assertEquals(2, defaultMaxExtent.bottom);
			Assert.assertEquals(3, defaultMaxExtent.right);
			Assert.assertEquals(4, defaultMaxExtent.top);
		}
		
		[Test]
		public function testDefaultCenter( ) : void {
			var map:Map = new Map();
			Assert.assertNull(map.center);			
		}
		
		[Test]
		public function testCenter( ) : void {
			var map:Map = new Map();
			map.center = new LonLat(1,2);
			Assert.assertEquals(1, map.center.lon);
			Assert.assertEquals(2, map.center.lat);
		}

	}
}