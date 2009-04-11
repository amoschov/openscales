package org.openscales.core.control.mouse{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.control.AbstractControl;
	
	
	public class WheelZoomMouseControl extends AbstractControl {
			
		public function WheelZoomMouseControl(target:Map = null, active:Boolean = false){
			super(target,active);
		}
		
		override protected function registerListeners():void{
			this.target.addEventListener(MouseEvent.MOUSE_WHEEL,this._onMouseWheel);
		}
		
		override protected function unregisterListeners():void{
			this.target.removeEventListener(MouseEvent.MOUSE_WHEEL,this._onMouseWheel);
		}
		
		private function _onMouseWheel(event:MouseEvent):void{
			
			if(event.delta>0){
				this.target.zoomIn();
			}
			else{
				this.target.zoomOut();
			}
		}
	}
}