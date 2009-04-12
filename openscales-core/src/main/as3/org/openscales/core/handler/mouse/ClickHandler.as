package org.openscales.core.handler.mouse {
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.handler.Handler;
	
	
	public class ClickHandler extends Handler {
		
		private var _timer:Timer = new Timer(250,1);
		
		private var _clickNum:Number = 0;
		
		private var _mouseEvent:MouseEvent = null;
			
		public function ClickHandler(target:Map = null, active:Boolean = false){
			super(target,active);
		}
		
		override protected function registerListeners():void{
			this.map.addEventListener(MouseEvent.CLICK, this.mouseClick);
			_timer.addEventListener(TimerEvent.TIMER, chooseClick);
		}
		
		override protected function unregisterListeners():void{
			_timer.stop();
        	_timer.removeEventListener(TimerEvent.TIMER, chooseClick);
        	this.map.removeEventListener(MouseEvent.CLICK, this.mouseClick);
		}
		
		private function mouseClick(event:MouseEvent):void{
		    _mouseEvent = event;
		    _clickNum++
		    _timer.start() 
		}
		
		private function chooseClick(event:TimerEvent):void{
			if(_clickNum == 1) {
		        if(click != null)
		        	click(_mouseEvent);
		        _timer.stop()
		        _clickNum=0
		    }    
		    else {
		        if(doubleClick != null)
		        	doubleClick(_mouseEvent);
		        _timer.stop()
		        _clickNum=0
		    }
		}
		
		public function click(evt:MouseEvent):void {
			
		}
		
		public function doubleClick(evt:MouseEvent):void {
			var newCenter:LonLat = this.map.getLonLatFromViewPortPx( new Pixel(this.map.mouseX, this.map.mouseY) ); 
        	this.map.setCenter(newCenter, this.map.zoom + 1);
		}	
	}
}