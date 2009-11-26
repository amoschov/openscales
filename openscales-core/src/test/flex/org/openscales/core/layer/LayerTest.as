package org.openscales.core.layer
{
	import flexunit.framework.Assert;
	

	public class LayerTest
	{
		
		[Test]
		public function testDefaultResolutions():void {
			var layer:Layer = new Layer("test");
			
			Assert.assertEquals(Layer.DEFAULT_NUM_ZOOM_LEVELS, layer.resolutions.length);
			Assert.assertEquals(Layer.DEFAULT_NOMINAL_RESOLUTION, layer.resolutions[0]);
		}
		
		[Test]
		public function testResolutions():void {
			var layer:Layer = new Layer("test");
			layer.resolutions = [0, 1, 2 , 3 , 4, 5, 6, 7, 8, 9];
			
			Assert.assertEquals(10, layer.resolutions.length);
			
			// Test resolutions sorting
			Assert.assertEquals(9, layer.resolutions[0]);
			Assert.assertEquals(0, layer.resolutions[9]);
		}
		
		[Test]
		public function testGeneratedResolutions():void {
			var layer:Layer = new Layer("test");
			layer.generateResolutions(5, 2);
			
			Assert.assertEquals(5, layer.resolutions.length);
			
			// Test resolutions sorting
			Assert.assertEquals(2, layer.resolutions[0]);
			Assert.assertEquals(1, layer.resolutions[1]);
			Assert.assertEquals(0.5, layer.resolutions[2]);
			Assert.assertEquals(0.25, layer.resolutions[3]);
			Assert.assertEquals(0.125, layer.resolutions[4]);
		}
		
		[Test]
		public function testMinZoomLevel():void {
			var layer:Layer = new Layer("test");
			layer.resolutions = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
			layer.minZoomLevel = 2;
			
			Assert.assertEquals(layer.minZoomLevel, 2);
			Assert.assertEquals(layer.minResolution, 0);
			Assert.assertEquals(layer.maxResolution, 7);
		}
		
		[Test]
		public function testMaxZoomLevel():void {
			var layer:Layer = new Layer("test");
			layer.resolutions = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
			layer.maxZoomLevel = 8;
			
			Assert.assertEquals(layer.maxZoomLevel, 8);
			Assert.assertEquals(layer.minResolution, 1);
			Assert.assertEquals(layer.maxResolution, 9);
		}
		
		[Test]
		public function testInvalidMaxZoomLevel():void {
			var layer:Layer = new Layer("test");
			layer.resolutions = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
			
			// Define valid maxZoomLevel
			layer.maxZoomLevel = 5;
			// Now invalid one
			layer.maxZoomLevel = 11;
						
			Assert.assertEquals(layer.maxZoomLevel, 5);
		}
		
		[Test]
		public function testInvalidMinZoomLevel():void {
			var layer:Layer = new Layer("test");
			layer.resolutions = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
			
			// Define valid maxZoomLevel
			layer.minZoomLevel = 5;
			// Now invalid one
			layer.minZoomLevel = -1;
			
			Assert.assertEquals(layer.minZoomLevel, 5);
		}
	}
}