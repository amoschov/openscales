package org.openscales.core.feature
{
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.layer.Layer;
	
	/**
	 * WFS handling class, for use as a featureClass on the WFS layer for handling ‘point’
	 * WFS types.  Good for subclassing when creating a custom WFS like XML application.
	 */
	public class WFS extends Feature
	{
		
		public function WFS(layer:Layer, xmlNode:XML):void {
	        var data:Object = this.processXMLNode(xmlNode);
	        super(layer, data.lonlat, data);
		}
		
		override public function destroy():void {
	        super.destroy();
		}
		
		public function processXMLNode(xmlNode:XML):Object {
	        var point:XMLList = xmlNode.elements("gml::Point");
	        var text:String  = Util.getXmlNodeValue(point[0].elements("gml::coordinates")[0]);
	        var floats:Array = text.split(",");
	        return {lonlat: new LonLat(Number(floats[0]),
	                                              Number(floats[1])),
	                id: null};
		}
		
		private var CLASS_NAME:String = "OpenScales.Feature.WFS";
		
	}
}