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

			if(event.delta > 0) {
				this.map.zoom++;
			} else {
				this.map.zoom--;
			}

		}

	}
}

