package org.openscales.proj4as.projections
{
	import org.flexunit.Assert;
	
	import org.openscales.proj4as.ProjProjection;
	import org.openscales.proj4as.Proj4as;
	import org.openscales.proj4as.ProjPoint;

	/**
	 * Test org.openscales.proj4as.Proj4as static functions.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class ProjectionTest {
        private var xyEPSLN:Number= 1.0e+0;//metric precision
        private var llEPSLN:Number= 1.0e-6;

		/**
		 * Initial state.
		 * Sets up the fixture, this method is called before a test is executed.
		 */
		[Before]
		public function setUp ( ) : void {
		}

		/**
		 * Clean up.
		 * Tears down the fixture, this method is called after a test is executed.
		 */
		[After]
		public function tearDown ( ) : void {
		}

        public function ProjectionTest () {
        }

		/**
		 * Test 1 : IGNF:GEOPORTALFXX <-> IGNF:RGF93G
		 */
		[Test]
		public function testGEOPORTALFXX_RGF93G():void {
            trace("Proj4as - test IGNF:GEOPORTALFXX <-> IGNF:RGF93G :");
            var rgf93g:ProjProjection= new ProjProjection("IGNF:RGF93G");
            var geoportalfxx:ProjProjection= new ProjProjection("IGNF:GEOPORTALFXX");
			var ll:ProjPoint = new ProjPoint(2.336507, 50.399937);
            var xy:ProjPoint = new ProjPoint(179040.15, 5610495.28);
			var ll2xy:ProjPoint = ll.clone();
            ll2xy= Proj4as.transform(rgf93g,geoportalfxx,ll2xy);
            trace("IGNF:RGF93G["+ll+"]("+xy+") IGNF:GEOPORTALFXX["+ll2xy+"]");
			Assert.assertEquals("RGF93G->GEOPORTALFXX", true, (Math.abs(ll2xy.x - xy.x)<=xyEPSLN) && (Math.abs(ll2xy.y - xy.y)<=xyEPSLN));
            var xy2ll:ProjPoint = xy.clone();
            xy2ll= Proj4as.transform(geoportalfxx,rgf93g,xy2ll);
            trace("IGNF:GEOPORTALFXX["+xy+"]("+ll+") IGNF:RGF93G["+xy2ll+"]");
            Assert.assertEquals("GEOPORTALFXX->RGF93G", true, (Math.abs(xy2ll.x - ll.x)<=llEPSLN) && (Math.abs(xy2ll.y - ll.y)<=llEPSLN));
		}
		
		/**
		 * Test 2 : EPSG:4326 <-> IGNF:GEOPORTALKER
		 */
		[Test]
		public function testGEOPORTALKER_WGS84G():void {
            trace("Proj4as - test EPSG:4326 <-> IGNF:GEOPORTALKER :");
            var wgs84g:ProjProjection= new ProjProjection("EPSG:4326");
            var geoportalker:ProjProjection= new ProjProjection("IGNF:GEOPORTALKER");
            var ll:ProjPoint = new ProjPoint(70.215278, -49.354167);
            var xy:ProjPoint = new ProjPoint(5076299.6095, -5494080.7389);
			var ll2xy:ProjPoint = ll.clone();
            ll2xy= Proj4as.transform(wgs84g,geoportalker,ll2xy);
            trace("EPSG:4326["+ll+"]("+xy+") IGNF:GEOPORTALKER["+ll2xy+"]");
            Assert.assertEquals("4326->GEOPORTALKER", true, (Math.abs(ll2xy.x - xy.x)<=xyEPSLN) && (Math.abs(ll2xy.y - xy.y)<=xyEPSLN));
            var xy2ll:ProjPoint = xy.clone();
            xy2ll= Proj4as.transform(geoportalker,wgs84g,xy2ll);
            trace("IGNF:GEOPORTALKER["+xy+"]("+ll+") EPSG:4326["+xy2ll+"]");
            Assert.assertEquals("GEOPORTALKER->4326", true, (Math.abs(xy2ll.x - ll.x)<=llEPSLN) && (Math.abs(xy2ll.y - ll.y)<=llEPSLN));
		}

        /**
         * Test 3 : EPSG:4326 -> IGNF:GEOPORTALFXX -> EPSG:4326
         */
        [Test]
        public function test4326_GEOPORTALFXX_4326():void {
            trace("Proj4as - test EPSG:4326 -> IGNF:GEOPORTALFXX -> EPSG:4326");
            var wgs84g:ProjProjection= new ProjProjection("EPSG:4326");
            var geoportalfxx:ProjProjection= new ProjProjection("IGNF:GEOPORTALFXX");
			var ll:ProjPoint = new ProjPoint(2.336507, 50.399937);
			var ll2xy:ProjPoint = ll.clone();
            ll2xy= Proj4as.transform(wgs84g,geoportalfxx,ll2xy);
            trace("EPSG:4326["+ll+"] IGNF:GEOPORTALFXX["+ll2xy+"]");
            var xy2ll:ProjPoint = ll2xy.clone();
            xy2ll= Proj4as.transform(geoportalfxx,wgs84g,xy2ll);
            trace("IGNF:GEOPORTALFXX["+ll2xy+"] EPSG:4326["+xy2ll+"]");
            Assert.assertEquals("EPSG:4326 cycle", true, (Math.abs(xy2ll.x - ll.x)<=llEPSLN) && (Math.abs(xy2ll.y - ll.y)<=llEPSLN));
        }

	}
}
