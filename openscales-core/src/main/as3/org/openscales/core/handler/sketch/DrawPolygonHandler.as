package org.openscales.core.handler.sketch
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.VectorLayer;

	public class DrawPolygonHandler extends Handler
	{
		
		// The layer in which we'll draw
		private var _drawLayer:org.openscales.core.layer.VectorLayer = null;

		private var _lring:LinearRing = null;
		private var _polygon:Polygon = null;
		private var _firstCall:Boolean = true;

		private var id:Number = 0;
		
		
		public function DrawPolygonHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active);
			this.drawLayer = drawLayer;
			
		}
		
		override protected function registerListeners():void{
			this.map.addEventListener(MouseEvent.CLICK, this.mouseClick);
		}
		
		override protected function unregisterListeners():void{
        	this.map.removeEventListener(MouseEvent.CLICK, this.mouseClick);
		}
		
		public function mouseClick(event:MouseEvent):void {
			
			if (drawLayer != null) {
				var feature:org.openscales.core.feature.VectorFeature;
				feature = new org.openscales.core.feature.VectorFeature();
				feature.id = "point."+id.toString(); id++;
				
				var pixel:Pixel = new Pixel(drawLayer.mouseX,drawLayer.mouseY);
				var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
				var point:Point = new Point(lonlat.lon,lonlat.lat);

				
				
				if(firstCall) {
					
					lring = new LinearRing([point]);
					polygon = new Polygon(lring);
					feature.geometry = polygon;
					
					// We create a point the first time to see were we have clicked
					var featurePoint:org.openscales.core.feature.VectorFeature = new org.openscales.core.feature.VectorFeature;
					featurePoint.id = id.toString();id++;
					featurePoint.geometry = point;
					
					drawLayer.addFeatures(featurePoint);
					drawLayer.addFeatures(feature);
					
					firstCall = false;
				}
				else {
					//When we have at least a 2 points polygon, we can remove the first point
					if (drawLayer.features.length == 2) {
						drawLayer.removeFeatures(drawLayer.features[0]);
					}
					drawLayer.renderer.clear();
					lring.addComponent(point);
					drawLayer.redraw();
				}
			}		
		}

		
		public function get drawLayer():org.openscales.core.layer.VectorLayer {
			return _drawLayer;
		}

		public function set drawLayer(drawLayer:org.openscales.core.layer.VectorLayer):void {
			_drawLayer = drawLayer;
		}
		
		public function get lring():LinearRing {
			return _lring;
		}

		public function set lring(lring:LinearRing):void {
			_lring = lring;
		}

		public function get polygon():Polygon {
			return _polygon;
		}

		public function set polygon(polygon:Polygon):void {
			_polygon = polygon;
		}

		public function get firstCall():Boolean {
			return _firstCall;
		}

		public function set firstCall(firstCall:Boolean):void {
			_firstCall = firstCall;
		}
		
	}
}