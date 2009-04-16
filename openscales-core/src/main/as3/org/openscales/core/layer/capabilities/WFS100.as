package org.openscales.core.layer.capabilities
{
	import org.openscales.core.basetypes.Bounds;
	
	/**
	 * WFS 1.0.0 capabilities parser
	 */
	internal class WFS100 extends CapabilitiesParser
	{
		import org.openscales.core.basetypes.maps.HashMap
		
		private namespace _wfsns = "http://www.opengis.net/wfs";
		
		/**
		 * Class constructor
		 */
		public function WFS100()
		{
			super();
			
			this._version = "1.0.0";
			
			this._layerListNode = "FeatureTypeList";
			this._layerNode = "FeatureType";
			this._name = "Name";
			this._title = "Title";
			this._srs = "SRS";
			this._abstract = "Abstract";
			this._latLonBoundingBox = "LatLongBoundingBox";
		}
		
		/**
		 * Method which parses the XML capabilities file returned by the WFS server
		 * 
		 * @param doc Is the XML document to parse.
		 * @return An HashMap containing the capabilities of layers available on the server.
		 */
		public override function read(doc:XML):HashMap {
			
			use namespace _wfsns;
			var featureCapabilities:HashMap = new HashMap();
			var value:String = null;
			var name:String = null;
			var latLon:Bounds = null;
			var minx:Number; var miny:Number; var maxx:Number; var maxy:Number;
			
			var featureNodes:XMLList = doc..*::FeatureType;
			this.removeNamespaces(doc);

			for each (var feature:XML in featureNodes){

				name = feature.Name;
				featureCapabilities.put("Name", name);
				
				value = feature.Title;
				featureCapabilities.put("Title", value);
				
				value = feature.SRS;
				featureCapabilities.put("SRS", value);
				
				value = feature.Abstract;
				featureCapabilities.put("Abstract", value);
				
				minx = feature.LatLongBoundingBox.@minx;
				miny = feature.LatLongBoundingBox.@miny;
				maxx = feature.LatLongBoundingBox.@maxx;
				maxy = feature.LatLongBoundingBox.@maxy;
				latLon = new Bounds(minx, miny, maxx, maxy);
				featureCapabilities.put("LatLon", latLon);
				
				this._capabilities.put(name, featureCapabilities);
				
				//We cannot use clear() or reset() or we'll loose the datas
				featureCapabilities = new HashMap();
			}

			return this._capabilities;
		}
		
		/**
		 * Method to remove the additional namespaces of the XML capabilities file.
		 */
		private function removeNamespaces(doc:XML):void {
			var namespaces:Array = doc.inScopeNamespaces();
			for each (var ns:String in namespaces) {
				doc.removeNamespace(new Namespace(ns));
			}
			doc.removeNamespace(new Namespace("http://www.opengis.net/wfs"));
		}

	}
}