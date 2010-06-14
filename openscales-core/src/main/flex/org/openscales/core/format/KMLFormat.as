package org.openscales.core.format
{
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Style;
	import org.openscales.proj4as.ProjProjection;
	

	/**
	 * Read KML xml files
	 * 
	 * alpha support
	 */
	public class KMLFormat extends Format
	{
		private namespace opengis="http://www.opengis.net/kml/2.2";
		private namespace google="http://earth.google.com/kml/2.0";
		
		public function KMLFormat() {
			
		}

		/**
		 * Read data
		 *
		 * @param data data to read/parse.
		 *
		 * @return array of features.
		 */
		override public function read(data:Object):Object {
			var features:Array = new Array();
			var dataXML:XML = data as XML;
			
			use namespace google;
			use namespace opengis;
			
			var placemarks:XMLList = dataXML..Placemark;
			
			for each(var placemark:XML in placemarks) {
				if(placemark.Point == undefined)
					continue;
				
				var htmlContent:String = "";
				var coordinates:Array = placemark.Point.coordinates.text().split(",");
				var point:Point = new Point(coordinates[0], coordinates[1]);
				if (this._internalProj != null, this._externalProj != null) {
						point.transform(this.externalProj, this.internalProj);
				}
						
				var attributes:Object = {};
				
				if(placemark.name != undefined) {
					attributes["name"] = placemark.name.text();
					htmlContent = htmlContent + "<b>" + placemark.name.text() + "</b><br />";   
				}
				if(placemark.description != undefined) {
					attributes["description"] = placemark.description.text();
					htmlContent = htmlContent + placemark.description.text() + "<br />";
				}
				
				for each(var extendedData:XML in placemark.ExtendedData.Data) {
					if(extendedData.value)
						attributes[extendedData.@name] = extendedData.value.text();
						htmlContent = htmlContent + "<b>" + extendedData.@name + "</b> : " + extendedData.value.text() + "<br />";
				}		
				
				attributes["popupContentHTML"] = htmlContent;
				var feature:PointFeature = new PointFeature(point, attributes, null);
				
				features.push(feature);				
			} 
			
			return features;
		}
		
		public function get internalProj():ProjProjection {
			return this._internalProj;
		}

		public function set internalProj(value:ProjProjection):void {
			this._internalProj = value;
		}

		public function get externalProj():ProjProjection {
			return this._externalProj;
		}

		public function set externalProj(value:ProjProjection):void {
			this._externalProj = value;
		}


	}
}

