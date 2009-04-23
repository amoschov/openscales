package org.openscales.core.handler.sketch
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.Vector;
	

	public class DrawPointHandler extends Handler
	{
		
		// The layer in which we'll draw
		private var _drawLayer:org.openscales.core.layer.Vector = null;
		
		
		private var id:Number = 0;
		
		public function DrawPointHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.Vector=null)
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
				var feature:org.openscales.core.feature.Vector;
				feature = new org.openscales.core.feature.Vector();
				feature.id = id.toString(); id++;
				var pixel:Pixel = new Pixel(drawLayer.mouseX,drawLayer.mouseY);
				var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
				var point:Point = new Point(lonlat.lon,lonlat.lat);
				feature.geometry = point;
				drawLayer.addFeatures(feature);
			}		
		}
		
		public function get drawLayer():org.openscales.core.layer.Vector {
			return _drawLayer;
		}

		public function set drawLayer(drawLayer:org.openscales.core.layer.Vector):void {
			_drawLayer = drawLayer;
		}
		
	}
}