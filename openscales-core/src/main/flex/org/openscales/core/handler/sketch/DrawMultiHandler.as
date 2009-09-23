package org.openscales.core.handler.sketch
{
	import org.openscales.core.Map;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.MultiPointFeature;
	import org.openscales.core.feature.MultiPolygonFeature;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.layer.VectorLayer;

	/**
	 * DrawMultiHandler allow you to merge several features (withe the same geometry) in one.
	 * It works ONLY with same geometries. It doesn't work with MultiGeometry.
	 * You can merge point in MultiPoint, MultiLineString in MultiLineString and MultiPolygon in Multipolygon
	 */

	public class DrawMultiHandler extends AbstractDrawHandler
	{		
		/**
		 * The single id of the multiFeature
		 */
		private var id:Number = 0;
		
		/**
		 * TEMPORARY : to determine if we show an alert or not
		 */
		private var _multiPolygonForbidden:Boolean = false;

		public function DrawMultiHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active, drawLayer);
		}

		public function buttonClicked(selectedFeatures:Array):Feature {
			var feature:Feature;
			if (drawLayer != null) {
				feature = this.draw(selectedFeatures); 
			}
			return feature;
		}
		/**
		 * draw the new feature with all features selected
		 *
		 * @param selectedFeature An array of features selected
		 *
		 * @return The feature create
		 */
		private function draw(selectedFeatures:Array):Feature {
			var f:VectorFeature;
			var array:Array = new Array();
			var multiPoint:MultiPoint = new MultiPoint();
			var multiLineString:MultiLineString = new MultiLineString();
			var multiPolygon:MultiPolygon = new MultiPolygon();
			var drawType:String = "";
			var multiPointFeature:MultiPointFeature;
			var multiLineStringFeature:MultiLineStringFeature;
			var multiPolygonFeature:MultiPolygonFeature;
			var feature:VectorFeature;
			
			
			// FixMe: the style should not be hard coded bust should be dependant
			// on the current style of the objects
			var style:Style = new Style();
			style.fillColor = 0x60FFE9;
			style.strokeColor = 0x60FFE9;
			
			// FixMe: if the selected features have differents typesn only the
			// features of the type of the last one in selectedFeatures are
			// managed
			for each(f in selectedFeatures){
				if(f != null) 
				{
					//Add all selected feature in a multigeometry
					if(f.geometry is Point)
					{
						multiPoint.addPoint(f.geometry as Point);
						drawType = "MultiPoint";
						
						_multiPolygonForbidden = false;
						drawLayer.removeFeature(f);
					}
					else if(f.geometry is LineString)
					{
						multiLineString.addLineString(f.geometry as LineString);
						drawType = "MultiLineString";
						
						_multiPolygonForbidden = false;
						drawLayer.removeFeature(f);
					}
					else if(f.geometry is Polygon)
					{
						multiPolygon.addPolygon(f.geometry as Polygon);
						drawType = "MultiPolygon";
						
						_multiPolygonForbidden = false;
						drawLayer.removeFeature(f);
					}

					else if(f.geometry is MultiPoint)
					{
						for(var i:int = 0;i<(f.geometry as MultiPoint).componentsLength;i++) {
							multiPoint.addPoint((f.geometry as MultiPoint).componentByIndex(i) as Point);
						}
						drawType = "MultiPoint";
						
						_multiPolygonForbidden = false;
						drawLayer.removeFeature(f);
					}
					else if(f.geometry is MultiLineString)
					{
						for(var k:int = 0;k<(f.geometry as MultiLineString).componentsLength;k++) {
							multiLineString.addLineString((f.geometry as MultiLineString).componentByIndex(k) as LineString);
						}
						drawType = "MultiLineString";
						
						_multiPolygonForbidden = false;
						drawLayer.removeFeature(f);
					}
					else if(f.geometry is MultiPolygon)
					{
						
						/* for(var l:int = 0;l<(f.geometry as MultiPolygon).components.length;l++)
						{
							multiPolygon.addPolygon((f.geometry as MultiPolygon).components[l] as Polygon);
						}
						drawType = "MultiPolygon"; */
						_multiPolygonForbidden = true;
						break;
					}
				}
			}
			//Display the new feature
			if(drawType == "MultiPoint")
			{
				multiPointFeature = new MultiPointFeature(multiPoint,null,style);
				drawLayer.addFeature(multiPointFeature);
				feature = multiPointFeature;
			}
			else if(drawType == "MultiLineString")
			{
				multiLineStringFeature = new MultiLineStringFeature(multiLineString,null,style);
				drawLayer.addFeature(multiLineStringFeature);
				feature = multiLineStringFeature;
			}
			else if(drawType == "MultiPolygon")
			{
				multiPolygonFeature = new MultiPolygonFeature(multiPolygon,null,style);
				drawLayer.addFeature(multiPolygonFeature);
				feature = multiPolygonFeature;
			}	
			return(feature);	 
		}
		
		public function get multiPolygonForbidden():Boolean{
			return _multiPolygonForbidden;
		}
		public function set multiPolygonForbidden(value:Boolean):void{
			_multiPolygonForbidden = value;
		}
	}
}