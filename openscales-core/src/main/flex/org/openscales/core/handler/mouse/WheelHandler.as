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

		private static var _lastPos:Pixel = null;
		
		public function WheelHandler(target:Map = null, active:Boolean = true){
			super(target,active);
		}

		override protected function registerListeners():void{
			if (this.map) {
				this.map.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			}
		}

		override protected function unregisterListeners():void{
			if (this.map) {
				this.map.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			}
		}

		private function onMouseWheel(event:MouseEvent):void{
			var mpx:Pixel = new Pixel(event.currentTarget.mouseX, event.currentTarget.mouseY);
			if(WheelHandler._lastPos!=null && mpx.equals(WheelHandler._lastPos)) {
				if(event.delta > 0) {
					this.map.zoom++;
				}else {
					this.map.zoom--;
				}
				return;
			}
			WheelHandler._lastPos = mpx;
			var cpx:Pixel = this.map.getMapPxFromLonLat(this.map.center);
			var dist:Number = Math.max(Math.pow(mpx.x-cpx.x,2),Math.pow(mpx.y-cpx.y,2));
			if(dist>150) {
				var loc:LonLat = this.map.getLonLatFromMapPx(mpx);
				if(event.delta > 0) {
					this.map.setCenter(loc,this.map.zoom+1);
				} else {
					this.map.setCenter(loc,this.map.zoom-1);
				}
			}else if(event.delta > 0) {
				this.map.zoom++;
			}else {
				this.map.zoom--;
			}

		}

	}
}

