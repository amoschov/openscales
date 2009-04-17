package org.openscales.core.layer.capabilities
{
	import org.openscales.core.basetypes.Bounds;
	
	internal class WFS110 extends CapabilitiesParser
	{
		import org.openscales.core.basetypes.maps.HashMap;
		private namespace _wfsns = "http://www.opengis.net/wfs";
		private namespace _owsns = "http://www.opengis.net/ows";
		
		/**
	 	* WFS 1.1.0 capabilities parser
	 	*/
		public function WFS110()
		{
			super();
			
			this._version = "1.1.0";
			
			this._layerListNode = "FeatureTypeList";
			this._layerNode = "FeatureType";
			this._name = "Name";
			this._title = "Title";
			this._srs = "DefaultSRS";
			this._abstract = "Abstract";
			this._latLonBoundingBox = "WGS84BoundingBox";
		}
		
		/**
		 * Method which parses the XML capabilities file returned by the WFS server
		 * 
		 * @param doc Is the XML document to parse.
		 * @return An HashMap containing the capabilities of layers available on the server.
		 */
		public override function read(doc:XML):HashMap {
			
			use namespace _wfsns;
			use namespace _owsns;
			
			var featureCapabilities:HashMap = new HashMap();
			var value:String = null;
			var name:String = null;
			var latLon:Bounds = null;
			var lowerCorner:String; var upperCorner:String; var bounds:String;
			
			var featureNodes:XMLList = doc..*::FeatureType;
			this.removeNamespaces(doc);

			for each (var feature:XML in featureNodes){

				name = feature.Name;
				featureCapabilities.put("Name", name);
				
				value = feature.Title;
				featureCapabilities.put("Title", value);
				
				value = feature.DefaultSRS;
				value = value.substr(value.indexOf("EPSG"));
				featureCapabilities.put("SRS", value);
				
				value = feature.Abstract;
				featureCapabilities.put("Abstract", value);
				
				
				var boundingBoxes:XMLList = feature..*::WGS84BoundingBox;
				lowerCorner = feature.WGS84BoundingBox.LowerCorner;
				upperCorner = feature.WGS84BoundingBox.UpperCorner;
				bounds = lowerCorner.replace(" ",",");
				bounds += upperCorner.replace(" ",",");
				latLon = new Bounds().fromString(bounds);
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
		}
		
	}
}