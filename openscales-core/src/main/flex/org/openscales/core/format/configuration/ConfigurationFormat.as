package org.openscales.core.format.configuration
{
	import org.openscales.core.Map;
	import org.openscales.core.control.Control;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.Layer;

	/**
	 * Sample XML OpenScales configuration format.
	 * TODO : create an XML schema
	 * 
	 * <Map id="fxmapy" width="600" height="400" maxExtent="-180,-90,180,90"
     * zoom="6" lon="1.58313" lat="49.77813" proxy="http://openscales.org/proxy.php?url="    
     * xmlns="http://openscales.org/schema/conf" xsi:schemaLocation="http://openscales.org/schema/conf-1.0.xsd">
     *       
     *        <Layers>
     *                        
     *       </Layers>
     *       
     *       <Handlers>
     *             <DragHandler/>
     *             <WheelHandler/>   
     *       </Handlers>
     *       
     *       <Controls>
     *             <MousePosition/>  
     *       </Controls>
     *       
     *       <Catalog>
     *             <Category label="Level1" >
     *                         <Mapnik active="false" label="Mapnik" name="Mapnik" maxResolution="156543.0339" minResolution="0.5971642833709717" numZoomLevels="20" maxExtent="-20037508.34,-20037508.34,20037508.34,20037508.34" isBaseLayer="false"/>
     *                         <WMSC active="false" label="Metacarta" name="Metacarta" url="http://labs.metacarta.com/wms-c/Basic.py" layers="satellite" format="image/jpeg" isBaseLayer="false"/>
     *                         <WMSC active="false" label="OpenLayers WMS" name="OpenLayers WMS" url="http://labs.metacarta.com/wms-c/Basic.py" layers="basic" isBaseLayer="false"/>
     *             </Category>
     *             <Category label="level2" >
     *                   <Category active="false" label="Level 2.1">
     *                   <WFS active="false" label="States" name="States" isBaseLayer="false" url="http://sigma.openplans.org/geoserver/wfs" typename="topp:states" srs="EPSG:4326" version="1.0.0" minZoomLevel="21"/>
     *             </Category>
     *                   <WFS active="false" label="test" name="test" isBaseLayer="false" url="http://sigma.openplans.org/geoserver/wfs" typename="tiger:poi" srs="EPSG:4326" version="1.0.0" use110Capabilities="false" minZoomLevel="21"/>
     *             </Category>
     *       </Catalog>
     *       
     *       <Custom>
     *             <Projections>
     *                   <Projection label="WGS84G">EPSG:4326</Projection>
     *                   <Projection label="Mapnik">EPSG:900913</Projection>
     *             </Projections>
     *             <!--
     *                   ...
     *             -->
     *       </Custom>
	 *	</Map>
	 */
	public class ConfigurationFormat implements IConfigurationFormat
	{
		protected var _config:XML;
		
		public function ConfigurationFormat(config:XML)
		{
			this.config = config;
		}
		
		public function configureMap(map:Map):void {
			// Parse the XML (children of Layers, Handlers, Controls ...)
		}
				
		public function set config(value:XML):void {
			this._config = value;
		}
		
		public function get config():XML {
			return this._config;
		}
		
		public function get layersFromMap():Array {
			
			return null;
		}
		
		public function get layersFromCatalog():Array {
			
			return null;
		}
		
		public function get catalog():XMLList {
			return null;
		}
		
		public function get custom():XMLList {
			return null;
		}
		
		protected function parseLayer(xmlNode:XML):Layer {
			return null;
		}
		
		protected function parseHandler(xmlNode:XML):Handler {
			return null;
		}
		
		protected function parseControl(xmlNode:XML):Control {
			return null;
		}
		
		
	}
}