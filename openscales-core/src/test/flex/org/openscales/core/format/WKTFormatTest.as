package org.openscales.core.format
{
	
	import org.flexunit.Assert;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.MultiPointFeature;
	import org.openscales.core.feature.MultiPolygonFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	
	public class WKTFormatTest
	{
		public function WKTFormatTest()
		{
		}
		
		private var format:WKTFormat;
		
		[Before]
		public function setUp():void
		{
			format = new WKTFormat();
		}
		
		[After] 
		public function tearDown():void
		{
			format = null;
		}
		
		[Test]
		public function testReadPoint():void
		{
			var feature:Feature = format.read("POINT(1 2)") as Feature;
			Assert.assertNotNull(feature);
		}
		
		[Test]
		public function testReadMultiPoint():void
		{
			var feature:Feature = format.read("MULTIPOINT(11 12,21 22)") as Feature;
			Assert.assertNotNull(feature);
		}
		
		[Test]
		public function testReadLineString():void
		{
			var feature:Feature = format.read("LINESTRING(11 12,21 22,31 32)") as Feature;
			Assert.assertNotNull(feature);
		}
		
		[Test]
		public function testReadMultiLineString():void
		{
			var feature:Feature = format.read("MULTILINESTRING((111 112,121 122,131 132),(211 212,221 222,231 232))") as Feature;
			Assert.assertNotNull(feature);
		}
		
		[Test]
		public function testReadPolygon():void
		{
			var feature:Feature = format.read("POLYGON((0 0,0 3,3 3,3 0),(1 1,1 2,2 2,2 1))") as Feature;
			Assert.assertNotNull(feature);
		}
		
		[Test]
		public function testReadMultiPolygon():void
		{
			var feature:Feature = format.read("MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2, 3 2, 3 3, 2 3,2 2)),((3 3,6 2,6 4,3 3)))") as Feature;
			Assert.assertNotNull(feature);
		}
		
		[Test]
		public function testWritePoint():void
		{
			var point:Point = new Point(1, 2);
			var pointFeature:PointFeature = new PointFeature(point);
			trace(format.write(pointFeature));
			Assert.assertNotNull(format.write(pointFeature));
		}
		
		[Test]
		public function testWriteMultiPoint():void
		{
			var multiPoint:MultiPoint = new MultiPoint([new Point(11, 12), new Point(21, 22)]);
			var multiPointFeature:MultiPointFeature = new MultiPointFeature(multiPoint);
			trace(format.write(multiPointFeature));
			Assert.assertNotNull(format.write(multiPointFeature));
		}
		
		[Test]
		public function testWriteLineString():void
		{
			var line:LineString = new LineString([new Point(11, 12), new Point(21, 22), new Point(31, 32)]);
			var lineFeature:LineStringFeature = new LineStringFeature(line);
			trace(format.write(lineFeature));
			Assert.assertNotNull(format.write(lineFeature));
		}
		
		[Test]
		public function testWriteMultiLineString():void
		{
			var line1:LineString = new LineString([new Point(111, 112), new Point(121, 122), new Point(131, 132)]);
			var line2:LineString = new LineString([new Point(211, 212), new Point(221, 222), new Point(231, 232)]);
			var multiline:MultiLineString = new MultiLineString([line1, line2]);
			var multilineFeature:MultiLineStringFeature = new MultiLineStringFeature(multiline);
			trace(format.write(multilineFeature));
			Assert.assertNotNull(format.write(multilineFeature));
		}
		
		[Test]
		public function testWritePolygon():void
		{
			var ring1:LinearRing = new LinearRing([new Point(0, 0), new Point(0, 3), new Point(3, 3), new Point(3, 0)]);
			var ring2:LinearRing = new LinearRing([new Point(1, 1), new Point(1, 2), new Point(2, 2), new Point(2, 1)]);
			var polygon:Polygon = new Polygon([ring1, ring2]);
			var polygonFeature:PolygonFeature = new PolygonFeature(polygon);
			trace(format.write(polygonFeature));
			Assert.assertNotNull(format.write(polygonFeature));
		}
		
		[Test]
		public function testWriteMultiPolygon():void
		{
			var ring1:LinearRing = new LinearRing([new Point(0, 0), new Point(0, 3), new Point(3, 3), new Point(3, 0)]);
			var ring2:LinearRing = new LinearRing([new Point(1, 1), new Point(1, 2), new Point(2, 2), new Point(2, 1)]);
			var ring3:LinearRing = new LinearRing([new Point(0, 0), new Point(0, -1), new Point(-1, -1), new Point(-1, 0)]);
			var multipolygon:MultiPolygon = new MultiPolygon([new Polygon([ring1, ring2]), new Polygon([ring3])]);
			var multiPolygonFeature:MultiPolygonFeature = new MultiPolygonFeature(multipolygon);
			trace(format.write(multiPolygonFeature));
			Assert.assertNotNull(format.write(multiPolygonFeature));
		}
		
		[Test]
		public function testWriteGeometryCollection():void
		{
			// TODO: create this test
		}
		
	}
}