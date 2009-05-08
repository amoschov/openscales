package org.openscales.core.handler.mouse {
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.core.handler.Handler;
	
	/**
	 * Used to handle click and double click. By default, double click zoom the map.
	 */
	public class ClickHandler extends Handler {
		
		/**
		 * We use a timer to detect double click, without throwing a click before.
		 */
		private var _timer:Timer = new Timer(250,1);
		
		private var _clickNum:Number = 0;
		
		private var _mouseEvent:MouseEvent = null;
		
		/**
		 * callback function oneclick(evt:MouseEvent):void
		 */
		private var _click:Function = null;
		/**
		 * callback function doubleClick(evt:MouseEvent):void
		 */
		private var _doubleClick:Function = null;
			
		public function ClickHandler(target:Map = null, active:Boolean = false,options:Object=null){
			super(target,active);
			if(options!=null)
			{
			if(options.click is Function) this.click=options.click;
			if(options.doubleclick is Function) this.doubleclick=options.doubleclick;
			}
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
		    _clickNum++;
		    _timer.start() 
		}
		
		private function chooseClick(event:TimerEvent):void{
			if(_clickNum == 1) {
		        if(_click != null)
		        	_click(_mouseEvent);
		        _timer.stop()
		        _clickNum=0
		    }    
		    else {
		        if(_doubleClick != null)
		        	_doubleClick(_mouseEvent);
		        _timer.stop()
		        _clickNum=0
		    }
		}
		public function set click(Click:Function):void
		{
			this._click=Click;
		}
		public function set doubleclick(doubleclick:Function):void
		{
			this._doubleClick=doubleclick;
		}
		
		public function get click():Function
		{
			return this._click;
		}
		public function get doubleclick():Function
		{
			return this._doubleClick;
		}
		
		
	/*	public function doubleClick(evt:MouseEvent):void {
			var newCenter:LonLat = this.map.getLonLatFromMapPx( new Pixel(this.map.mouseX, this.map.mouseY) ); 
        	this.map.setCenter(newCenter, this.map.zoom + 1);
		}	*/
	}
}