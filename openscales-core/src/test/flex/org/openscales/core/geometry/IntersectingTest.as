package org.openscales.core.geometry
{	
	import org.flexunit.Assert;
	import org.openscales.SampleLayers;
	import org.openscales.core.Map;
	import org.openscales.core.feature.MultiPolygonFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.layer.VectorLayer;

	public class IntersectingTest
	{
		// Useful variables for the tests
		
		/**
		 * @return a map with a base layer OpenStreetMap-Mapnik for the tests.
		 */
		private function get testMap():Map {
			var map:Map = new Map();
			map.addLayer(SampleLayers.baseLayerOSM());
			return map;
		}
		
		/**
		 * @return a vector layer with all the objects needed for the tests.
		 */
		private function get testLayer():VectorLayer {
			return SampleLayers.features();
		}
		
		/**
		 * Test all the containsPoint functions for the relevant geometries.
		 */
		[Test]
		public function testContainsPoint():void {
			// Useful variables for the tests
			var map:Map = this.testMap;
			var layer:VectorLayer = this.testLayer;
			var geom1:Geometry, geom2:Geometry;
			var testResult:Boolean;

			// LinearRing contains a Point : true
			// TODO : get child by name instead by index
			geom1 = ((layer.getChildAt(9) as PolygonFeature).geometry as Collection).componentByIndex(0);
			geom2 = (layer.getChildAt(5) as PointFeature).geometry;
			testResult = (geom1 as LinearRing).containsPoint(geom2 as org.openscales.core.geometry.Point);
			//textResult = "Does the outer LinearRing of the blue Polygon contain the red point (true) ? => "+testResult;
			Assert.assertTrue(testResult);

			// LinearRing contains a Point : false
			geom1 = ((layer.getChildAt(9) as PolygonFeature).geometry as Collection).componentByIndex(0);
			geom2 = (layer.getChildAt(0) as PointFeature).geometry;
			testResult = (geom1 as LinearRing).containsPoint(geom2 as org.openscales.core.geometry.Point);
			//textResult = "Does the outer LinearRing of the blue Polygon contain the black point below the violet multipolygon (false) ? => "+testResult;
			Assert.assertFalse(testResult);

			// LinearRing contains a Point : false
			geom1 = ((layer.getChildAt(9) as PolygonFeature).geometry as Collection).componentByIndex(0);
			geom2 = (layer.getChildAt(2) as PointFeature).geometry;
			testResult = (geom1 as LinearRing).containsPoint(geom2 as org.openscales.core.geometry.Point);
			//textResult = "Does the outer LinearRing of the blue Polygon contain the nearest black point (false) ? => "+testResult;
			Assert.assertFalse(testResult);

			// Polygon contains a Point without management of the holes : true
			geom1 = (layer.getChildAt(9) as PolygonFeature).geometry;
			geom2 = (layer.getChildAt(5) as PointFeature).geometry;
			testResult = (geom1 as Polygon).containsPoint(geom2 as org.openscales.core.geometry.Point, false);
			//textResult = "Does the blue Polygon contain the red point without managing its holes (true) ? => "+testResult;
			Assert.assertTrue(testResult);

			// Polygon contains a Point with management of the holes : false
			geom1 = (layer.getChildAt(9) as PolygonFeature).geometry;
			geom2 = (layer.getChildAt(5) as PointFeature).geometry;
			testResult = (geom1 as Polygon).containsPoint(geom2 as org.openscales.core.geometry.Point);
			//textResult = "Does the blue Polygon contain the red point without managing its holes (false) ? => "+testResult;
			Assert.assertFalse(testResult);
			
			// MultiPolygon contains a Point : true
			geom1 = ((layer.getChildAt(10) as MultiPolygonFeature).geometry as Collection).componentByIndex(0) as Collection;
			geom2 = (layer.getChildAt(0) as PointFeature).geometry;
			testResult = (geom1 as Polygon).containsPoint(geom2 as org.openscales.core.geometry.Point);
			//textResult = "Does the violet MultiPolygon contain the upper black point (true) ? => "+testResult;
			Assert.assertTrue(testResult);
			
			// MultiPolygon contains a Point : false
			geom1 = ((layer.getChildAt(10) as MultiPolygonFeature).geometry as Collection).componentByIndex(0) as Collection;
			geom2 = (layer.getChildAt(1) as PointFeature).geometry;
			testResult = (geom1 as Polygon).containsPoint(geom2 as org.openscales.core.geometry.Point);
			//textResult = "Does the violet MultiPolygon contain the lower black point (false) ? => "+testResult;
			Assert.assertFalse(testResult);
		}
		
	}
}