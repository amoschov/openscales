package org.openscales.core.handler.feature.draw
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.basetypes.LonLat;
	import org.openscales.basetypes.Pixel;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.geometry.Point;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.style.Style;

	/**
	 * Handler to draw points.
	 */
	public class DrawPointHandler extends AbstractDrawHandler
	{

		/**
		 * The layer in which we'll draw
		 */
		private var _drawLayer:FeatureLayer = null;

		/**
		 * Single ID for point
		 */		
		private var id:Number = 0;

		public function DrawPointHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.FeatureLayer=null)
		{
			super(map, active, drawLayer);
		}

		override protected function registerListeners():void{
			if (this.map) {
				this.map.addEventListener(MouseEvent.CLICK, this.drawPoint);
			}
		}

		override protected function unregisterListeners():void{
			if (this.map) {
				this.map.removeEventListener(MouseEvent.CLICK, this.drawPoint);
			}
		}

		/**
		 * Create a point and draw it
		 */		
		protected function drawPoint(event:MouseEvent):void {
			//We draw the point
			if (drawLayer != null)
				Trace.log("Drawing point"); {
				var style:Style = Style.getDefaultPointStyle();
			
				var pixel:Pixel = new Pixel(drawLayer.mouseX ,drawLayer.mouseY);
				var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
				
				var point:Point = new Point(lonlat.lon,lonlat.lat);

				var pointFeature:PointFeature = new PointFeature(point, null, style);
				pointFeature.name = id.toString(); id++;
				pointFeature.geometry = new Point(lonlat.lon, lonlat.lat); 			
				drawLayer.addFeature(pointFeature);
				pointFeature.draw();
			}
		}
	}
}

