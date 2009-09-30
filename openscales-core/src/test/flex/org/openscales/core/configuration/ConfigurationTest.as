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
		public function testControlssCount( ) : void {
			var sampleMapConfOk:XML = this.sampleMapConfOkXML();
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			Assert.assertEquals(1, conf.controls.length());
		}
		
		[Test]
		public function testConfigureMap( ) : void {
			var sampleMapConfOk:XML = this.sampleMapConfOkXML();
			var conf:IConfiguration = new Configuration(this.sampleMapConfOkXML());
			var map:Map = new Map();		
			
			//Will test conf.configureMap(map) when we will have some Map unit test
		}


	}

}


