package org.openscales.core.handler.sketch
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.Style;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.layer.VectorLayer;
	
	/**
	 * Handler to draw points.
	 */
	public class DrawPointHandler extends AbstractDrawHandler
	{
		
		/**
		 * The layer in which we'll draw
		 */
		private var _drawLayer:VectorLayer = null;
		
		/**
		 * Single ID for point
		 */		
		private var id:Number = 0;
		
		public function DrawPointHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active, drawLayer);
		}
		
		override protected function registerListeners():void{
			this.map.addEventListener(MouseEvent.CLICK, this.drawPoint);
		}
		
		override protected function unregisterListeners():void{
        	this.map.removeEventListener(MouseEvent.CLICK, this.drawPoint);
		}
		
		/**
		 * Create a point and draw it
		 */		
		private function drawPoint(event:MouseEvent):void {
			if (drawLayer != null) {
				var style:Style = new Style();
				style.fillColor = 0x60FFE9;
				style.strokeColor = 0x60FFE9;
				
				var pixel:Pixel = new Pixel(drawLayer.mouseX - this.map.layerContainer.x ,drawLayer.mouseY - this.map.layerContainer.y);
				var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
				var point:Point = new Point(lonlat.lon,lonlat.lat);
				
				var pointFeature:PointFeature = new PointFeature(point, null, style);
				pointFeature.name = id.toString(); id++;
				pointFeature.lonlat = lonlat; 			
				drawLayer.addFeature(pointFeature);
			}
		}
	}
}