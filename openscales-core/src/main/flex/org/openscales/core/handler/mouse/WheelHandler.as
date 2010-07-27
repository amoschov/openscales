package org.openscales.core.handler.mouse {
	
	import flash.events.MouseEvent;
	
	import org.openscales.basetypes.Pixel;
	import org.openscales.core.Map;
	import org.openscales.core.handler.Handler;
	
	/**
	 * Handler use to zoom in and zoom out the map thanks to the mouse wheel.
	 */
	public class WheelHandler extends Handler {
		
		
		public function WheelHandler(target:Map = null, active:Boolean = true) {
			super(target,active);
		}
		
		override protected function registerListeners():void {
			if (this.map) {
				this.map.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			}
		}
		
		override protected function unregisterListeners():void {
			if (this.map) {
				this.map.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			}
		}
		
		private function onMouseWheel(event:MouseEvent):void {
			if (this.map) {
				const px:Pixel = new Pixel(this.map.mouseX, this.map.mouseY);
				const centerPx:Pixel = new Pixel(this.map.width/2, this.map.height/2);
				var newCenterPx:Pixel;
				var zoom:Number = this.map.zoom;
				if(event.delta > 0) { 
					newCenterPx = new Pixel((px.x+centerPx.x)/2, (px.y+centerPx.y)/2);
					zoom++;
				} else {
					newCenterPx = new Pixel(2*centerPx.x-px.x, 2*centerPx.y-px.y);
					zoom--;
				}
				this.map.setZoom(zoom, this.map.getLonLatFromMapPx(newCenterPx));
			}
		}
		
	}
}
