package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.control.Control;

	public class Click extends Handler {
	
		private var _timer:Timer = new Timer(250,1);
		
		private var _clickNum:Number = 0;

		private var _mouseEvent:MouseEvent = null;
		
		/**
		 * callback function doubleClick(evt:MouseEvent):void
		 */
		public var doubleClick:Function = null;
		
		/**
		 * callback function down(evt:MouseEvent):void
		 */
		public var click:Function = null;
		
		public function Click(control:Control, options:Object=null):void {
			super(control, options);
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
		
		private function mouseClick(event:MouseEvent):void{
		    _mouseEvent = event;
		    _clickNum++
		    _timer.start() 
		}
		
		override public function activate():void {
			this.map.addEventListener(MouseEvent.CLICK, this.mouseClick);
			_timer.addEventListener(TimerEvent.TIMER, chooseClick);
		}
		
		override public function deactivate():void {
        	_timer.stop();
        	_timer.removeEventListener(TimerEvent.TIMER, chooseClick);
        	this.map.removeEventListener(MouseEvent.CLICK, this.mouseClick);
			
		}		
		
	}
}