package org.openscales.core.handler.mouse {
	
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.handler.Handler;
	
	/**
	 * Handler use to zoom in and zoom out the map thanks to the mouse wheel.
	 */
	public class WheelHandler extends Handler {
			
		public function WheelHandler(target:Map = null, active:Boolean = false){
			super(target,active);
		}
		
		override protected function registerListeners():void{
			this.map.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
		}
		
		override protected function unregisterListeners():void{
			this.map.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
		}
		
		private function onMouseWheel(event:MouseEvent):void{
			
			var deltaZ:int;
			
			if(event.delta > 0) {
				deltaZ = 1;
			} else {
				deltaZ = -1;
			}
			
			var newZoom:int = this.map.zoom + deltaZ;
	       
	        var size:Size    = this.map.size;
	        var deltaX:Number  = size.w/2 - this.map.mouseX;
	        var deltaY:Number  = size.h/2 - this.map.mouseY;
	        var newRes:Number  = this.map.baseLayer.resolutions[newZoom];
	        var zoomPoint:LonLat = this.map.getLonLatFromMapPx(new Pixel(this.map.mouseX, this.map.mouseY));
	        var newCenter:LonLat = new LonLat(
	                            zoomPoint.lon + deltaX * newRes,
	                            zoomPoint.lat - deltaY * newRes );
	        this.map.center = newCenter;
	        this.map.zoom = newZoom;
		}
		
	}
}