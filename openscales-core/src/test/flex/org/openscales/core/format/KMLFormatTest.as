package org.openscales.core.format
{
	
	import org.flexunit.Assert;
	import flash.utils.ByteArray;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.LineStringFeature;

	/**
	 * Used some tips detailed on http://dispatchevent.org/roger/embed-almost-anything-in-your-swf/ to load XML
	 */
	public class KMLFormatTest {
		
		[Embed(source="/assets/kml/sample1.kml", mimeType="application/octet-stream")]
		protected const Sample1KML:Class;
		
		[Embed(source="/assets/kml/sample2.kml", mimeType="application/octet-stream")]
		protected const Sample2KML:Class;

		// sample with linestring
		[Embed(source="/assets/kml/sample3.kml", mimeType="application/octet-stream")]
		protected const Sample3KML:Class;
		
		protected function sample1KML():XML {
			var ba : ByteArray = (new Sample1KML()) as ByteArray;
			return new XML(ba.readUTFBytes( ba.length ));
		}
		
		protected function sample2KML():XML {
			var ba : ByteArray = (new Sample2KML()) as ByteArray;
			return new XML(ba.readUTFBytes( ba.length ));
		}
		
		protected function sample3KML():XML {
			var ba : ByteArray = (new Sample3KML()) as ByteArray;
			return new XML(ba.readUTFBytes( ba.length ));
		}
		
		[Test]
		public function testReadSample1KML( ) : void {
			var kmlFormat:KMLFormat = new KMLFormat();
			var features:Array = kmlFormat.read(this.sample1KML()) as Array;
			
			Assert.assertEquals(1, features.length);
			var firstFeature:PointFeature = features[0];
			Assert.assertNotNull(firstFeature);
			Assert.assertEquals(0.5777064, firstFeature.point.x);
			Assert.assertEquals(44.83799619999999, firstFeature.point.y);
			
			Assert.assertEquals("Bordeaux", firstFeature.attributes["name"]);
			Assert.assertEquals("Where I was born", firstFeature.attributes["description"]);
			Assert.assertEquals("15/06/1981", firstFeature.attributes["Date"]);
			
		}
		
		[Test]
		public function testReadSample2KML( ) : void {
			var kmlFormat:KMLFormat = new KMLFormat();
			var features:Array = kmlFormat.read(this.sample2KML()) as Array;
			
			Assert.assertEquals(1, features.length);
			var firstFeature:PointFeature = features[0];
			Assert.assertNotNull(firstFeature);
			Assert.assertEquals(-122.0822035425683, firstFeature.point.x);
			Assert.assertEquals(37.42228990140251, firstFeature.point.y);
			
			Assert.assertEquals("Simple placemark", firstFeature.attributes["name"]);
		}
		
		[Test]
		public function testReadSample3KML( ) : void {
			var kmlFormat:KMLFormat = new KMLFormat();
			var features:Array = kmlFormat.read(this.sample3KML()) as Array;

			Assert.assertEquals(1, features.length);
			var firstFeature:LineStringFeature = features[0];
			Assert.assertNotNull(firstFeature);
			Assert.assertEquals(46,firstFeature.lineString.componentsLength);
			
			Assert.assertEquals("LineStringTests", firstFeature.attributes["name"]);
		}
		
	}

}


