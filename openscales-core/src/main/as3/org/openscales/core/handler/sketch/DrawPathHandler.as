package org.openscales.core.handler.sketch
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.VectorLayer;
	
	public class DrawPathHandler extends Handler
	{		
		// The layer in which we'll draw
		private var _drawLayer:org.openscales.core.layer.VectorLayer = null;				
		private var _id:Number = 0;
		private var _p:Point = null;
		private var _points:Array = null;
				
		public function DrawPathHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active);
			this.drawLayer = drawLayer;
		}
		override protected function registerListeners():void{
			 this.map.addEventListener(MouseEvent.CLICK, this.mouseClick); 
			/* this.map.addEventListener(MouseEvent.DOUBLE_CLICK, this.mouseDoubleClick); */
		}
		
		override protected function unregisterListeners():void{
        	this.map.removeEventListener(MouseEvent.CLICK, this.mouseClick);
		}
		
		public function mouseClick(event:MouseEvent):void {	 					
			
			var feature:org.openscales.core.feature.VectorFeature;
			feature = new org.openscales.core.feature.VectorFeature();
			
			var pixel:Pixel = new Pixel(drawLayer.mouseX,drawLayer.mouseY);
			var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
			var point:Point = new Point(lonlat.lon,lonlat.lat);
			
			if(points == null){				
				points = new Array();
				points[id]=point;
				id++;
				feature.geometry = point;
				drawLayer.addFeatures(feature);						
			}
			else {
				/* if (drawLayer.features.length == 2 && points.length < 3) {
						drawLayer.removeFeatures(drawLayer.features[0]);
						points[0] = null;
				} */			
				feature.id = id.toString(); 			
				points[id] = point;
				id++;
				
				var line:LineString = new LineString(points);
				feature.geometry = line;
				drawLayer.addFeatures(feature);
			}							
		}
		
		/* public function mouseDoubleClick(event:MouseEvent):void {
			var feature:org.openscales.core.feature.Vector;
			feature = new org.openscales.core.feature.Vector();
			
			var pixel:Pixel = new Pixel(drawLayer.mouseX,drawLayer.mouseY);
			var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
			var point:Point = new Point(lonlat.lon,lonlat.lat);
			
			if(points != null)
			{
				points[id]=point;
				id++;
				feature.geometry = point;
				drawLayer.addFeatures(feature);
			}
			else{
				
			}
		} */
		
		public function get drawLayer():org.openscales.core.layer.VectorLayer {
			return _drawLayer;
		}
		public function set drawLayer(drawLayer:org.openscales.core.layer.VectorLayer):void {
			_drawLayer = drawLayer;
		}
		
		public function get points():Array {
			return _points;
		}		
		public function set points(tab:Array):void {
			_points = tab;
		} 
		
		public function get id():Number {
			return _id;
		}
		public function set id(nb:Number):void {
			_id = nb;
		}
	}
}