package org.openscales.core.configuration
{
	import flash.utils.ByteArray;
	
	import org.flexunit.Assert;
	import org.openscales.core.Map;

	/**
	 * Used some tips detailed on http://dispatchevent.org/roger/embed-almost-anything-in-your-swf/ to load XML
	 */
	public class ConfigurationTest {
		
		[Embed(source="/configuration/sampleMapConfOk.xml", mimeType="application/octet-stream")]
		protected const SampleMapConfOk:Class;
		
		protected function sampleMapConfOkXML():XML {
			var ba : ByteArray = (new SampleMapConfOk()) as ByteArray;
			return new XML(ba.readUTFBytes( ba.length ));
		}
		
		[Test]
		public function testLoadingConfOkByContructor( ) : void {
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			Assert.assertNotNull(conf);
			Assert.assertNotNull(conf.config);
		}
		
		[Test]
		public function testLayersFromMapCount( ) : void {
			var sampleMapConfOk:XML = this.sampleMapConfOkXML();
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			Assert.assertEquals(2, conf.layersFromMap.length);
		}
		
		[Test]
		public function testLayersFromCatalogCount( ) : void {
			var sampleMapConfOk:XML = this.sampleMapConfOkXML();
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			Assert.assertEquals(5, conf.layersFromCatalog.length);
		}
		
		[Test]
		public function testHandlersCount( ) : void {
			var sampleMapConfOk:XML = this.sampleMapConfOkXML();
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			Assert.assertEquals(2, conf.handlers.length());
		}
		
		[Test]
		public function testControlsCount( ) : void {
			var sampleMapConfOk:XML = this.sampleMapConfOkXML();
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			Assert.assertEquals(1, conf.controls.length());
		}
		
		[Test]
		public function testConfigureMap( ) : void {
			var sampleMapConfOk:XML = this.sampleMapConfOkXML();
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			var map:Map = new Map();		
			conf.configureMap(map);
		}
		
		[Test]
		public function testCenter( ) : void {
			var sampleMapConfOk:XML = this.sampleMapConfOkXML();
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			Assert.assertEquals("1.58313", conf.config.@lon);
			Assert.assertEquals("49.77813", conf.config.@lat);
		}
		
		[Test]
		public function testDefaultResolutions( ) : void {
			var sampleMapConfOk:XML = this.sampleMapConfOkXML();
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			var map:Map = new Map();		
			conf.configureMap(map);
			
			Assert.assertEquals("20", map.getLayerByName("Metacarta").resolutions.length);
			Assert.assertEquals("1.40625", map.getLayerByName("Metacarta").resolutions[0]);			
		}
		
		[Test]
		public function testGenerateResolutions( ) : void {
			var sampleMapConfOk:XML = this.sampleMapConfOkXML();
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			var map:Map = new Map();		
			conf.configureMap(map);
			
			Assert.assertEquals("20", map.baseLayer.resolutions.length);
			Assert.assertEquals("156543.0339", map.baseLayer.resolutions[0]);
			Assert.assertEquals("0.29858214168548586", map.baseLayer.resolutions[19]);
			
		}

	}

}


