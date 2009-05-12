package org.openscales.core.handler.mouse
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.handler.Handler;

	public class ClickHandler extends Handler
	{
		private var _StartPixel:Pixel;
		private var _tolerance:Number=0;
		
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
		public function ClickHandler(map:Map=null, active:Boolean=false,options:Object=null)
		{
			super(map, active);
			if(options!=null)
			{
			this.click=(options.click is Function)?options.click:null;
			this.doubleclick=(options.doubleclick is Function)?options.doubleclick:null;
			this._tolerance=(!isNaN(options.tolerance)&&options.tolerance is Number)?options.tolerance:0;
			}
			this._tolerance=0;
		}
		override protected function registerListeners():void{
			this.map.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
			this.map.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
			_timer.addEventListener(TimerEvent.TIMER, chooseClick);
		}
		override protected function unregisterListeners():void{
			_timer.stop();
        	_timer.removeEventListener(TimerEvent.TIMER, chooseClick);
			this.map.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
			this.map.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
		}
		 
		 public function mouseDown(evt:MouseEvent):void
		 {
		 	this._StartPixel=new Pixel(evt.stageX,evt.stageY);
		 }
		 
		 public function mouseUp(evt:MouseEvent):void
		 {
		 	var dx :Number = Math.abs(this._StartPixel.x-evt.stageX);
		 	var dy :Number = Math.abs(this._StartPixel.y-evt.stageY);
		 	if(dx<=this._tolerance && dy<=this._tolerance)
		 	{
		 		this.mouseClick(evt);
		 	}
		 }
		 
		 private function mouseClick(evt:MouseEvent):void
		 {
		 	 _mouseEvent = evt;
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
		 //Properties
		 
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

		public function set tolerance(toleranceY:Number):void
		{
			this._tolerance=tolerance;
		}
		public function get tolerance():Number
		{
			return this._tolerance;
		}
		
	}
}