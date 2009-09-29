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
		public function testMaxResolution( ) : void {
			var map:Map = new Map();
			var maxResolution:Number = 156543.0339;
			map.maxResolution = maxResolution;	
			Assert.assertEquals(maxResolution, map.maxResolution);
		}
		
		[Test]
		public function testNumZoomLevels( ) : void {
			var map:Map = new Map();
			var numZoomLevels:Number = 20;
			map.numZoomLevels = numZoomLevels;	
			Assert.assertEquals(numZoomLevels, map.numZoomLevels);
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