package org.openscales.core.handler.sketch
{
	import org.openscales.core.Map;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.VectorLayer;

	public class DrawMultiHandler extends Handler
	{
		
		// The layer in which we'll draw
		private var _drawLayer:org.openscales.core.layer.VectorLayer = null;
		
		
		private var id:Number = 0;
		
		public function DrawMultiHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active);
			this.drawLayer = drawLayer;
		}
		
		public function buttonClicked(selectedFeatures:Array):VectorFeature {
			var feature:VectorFeature;
			if (drawLayer != null) {
				feature = this.draw(selectedFeatures); 
			}
			return feature;
		}
		
		private function draw(selectedFeatures:Array):VectorFeature {
			var f:org.openscales.core.feature.VectorFeature;
			var array:Array = new Array();
			var multiPoint:MultiPoint = new MultiPoint();
			var multiLineString:MultiLineString = new MultiLineString();
			var multiPolygon:MultiPolygon = new MultiPolygon();
			var drawType:String = "";
			var feature:VectorFeature;
			
			var style:Style = new Style();
			style.fillColor = 0x60FFE9;
			style.strokeColor = 0x60FFE9;
			
			for each(f in selectedFeatures){
					if(f != null) 
					{
						if(f.geometry is Point)
						{
							multiPoint.addPoint(f.geometry as Point);
							drawType = "MultiPoint";
						}
						if(f.geometry is LineString)
						{
							multiLineString.addLineString(f.geometry as LineString);
							drawType = "MultiLineString";
						}
						if(f.geometry is Polygon)
						{
							multiPolygon.addPolygon(f.geometry as Polygon);
							drawType = "MultiPolygon";
						}
						
						if(f.geometry is MultiPoint)
						{
							for(var i:int = 0;i<(f.geometry as MultiPoint).components.length;i++)
							{
								multiPoint.addPoint((f.geometry as MultiPoint).components[i] as Point);
							}
							drawType = "MultiPoint";
						}
						if(f.geometry is MultiLineString)
						{
							for(var k:int = 0;k<(f.geometry as MultiLineString).components.length;k++)
							{
								multiLineString.addLineString((f.geometry as MultiLineString).components[k] as LineString);
							}
							drawType = "MultiLineString";
						}
						if(f.geometry is MultiPolygon)
						{
							for(var l:int = 0;l<(f.geometry as MultiPoint).components.length;l++)
							{
								multiPolygon.addPolygon((f.geometry as MultiPolygon).components[l] as Polygon);
							}
							drawType = "MultiPoint";
						}
						drawLayer.removeFeatures(f);
					}
				}
				if(drawType == "MultiPoint")
				{
					feature = new VectorFeature(multiPoint,null,style);
				}
				if(drawType == "MultiLineString")
				{
					feature = new VectorFeature(multiLineString,null,style);
				}
				if(drawType == "MultiPolygon")
				{
					feature = new VectorFeature(multiPolygon,null,style);
				}		 
			drawLayer.addFeatures(feature);
			return(feature);
			
		}
		
		public function get drawLayer():org.openscales.core.layer.VectorLayer {
			return _drawLayer;
		}

		public function set drawLayer(drawLayer:org.openscales.core.layer.VectorLayer):void {
			_drawLayer = drawLayer;
		}
		
	}
}