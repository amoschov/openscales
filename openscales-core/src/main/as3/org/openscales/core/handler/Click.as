package org.openscales.core.handler
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import org.openscales.core.Control;
	import org.openscales.core.Handler;
	import org.openscales.core.TimerOL;
	import org.openscales.core.basetypes.Pixel;

	public class Click extends Handler
	{
	
		public var delay:int = 300;

    	public var single:Boolean = true;

    	public var double:Boolean = false;
    	
    	public var pixelTolerance:Number = NaN;

    	public var stopSingle:Boolean = false;

    	public var stopDouble:Boolean = false;

    	public var down:Pixel = null;
    	
    	public var timer:TimerOL = null;
		
		public function Click(control:Control, callbacks:Object, options:Object):void {
			super(control, callbacks, options);
			
			if(!isNaN(this.pixelTolerance)) {
	            this.mouseDown = function(evt:MouseEvent):Boolean {
	                this.down = new Pixel(evt.stageX, evt.stageY);
	                return true;
	            };
	        }
		}
		
		public var mouseDown:Function = null;
		
		override public function doubleClick(evt:MouseEvent):void {
			if(this.passesTolerance(evt)) {
	            if(this["double"]) {
	                this.callback('doubleClick', [evt]);
	            }
	            this.clearTimer();
	        }
		}
		
		public function click(evt:MouseEvent):void {
			if(this.passesTolerance(evt)) {
	            if(this.timer) {
	                this.clearTimer();
	            } else {
	                var clickEvent : Event = this.single ? evt : null;
	                this.timer = new TimerOL(this.delay);
	                this.timer.mouseevent = evt;
	                //new EventOL().observe(this.timer, TimerEvent.TIMER, this.delayedCall);
	                //this.timer.start();
	            }
	        }
		}
		
		public function passesTolerance(evt:MouseEvent):Boolean {
			var passes:Boolean = true;
	        if(this.pixelTolerance && this.down) {
	            var dpx:Number = Math.sqrt(
	                Math.pow(this.down.x - evt.stageX, 2) +
	                Math.pow(this.down.y - evt.stageY, 2)
	            );
	            if(dpx > this.pixelTolerance) {
	                passes = false;
	            }
	        }
	        return passes;
		}
		
		public function clearTimer():void {
			if(this.timer) {
				this.timer.stop();
	            this.timer = null;
	        }
		}
		
		public function delayedCall(evt:TimerEvent):void {
			var e:MouseEvent = evt.currentTarget.mouseevent;
	        if(e) {
	            this.callback('click', [e]);
	        }
		}
		
		override public function activate(evt:MouseEvent=null):Boolean {
			this.map.doubleClickEnabled = true;
			return super.activate(evt);
		}
		
		override public function deactivate(evt:MouseEvent=null):Boolean {
			var deactivated:Boolean = false;
	        if(super.deactivate()) {
	            this.clearTimer();
	            this.down = null;
	            deactivated = true;
	            this.map.doubleClickEnabled = false;
	        }
	        return deactivated;
		}
		
		public function mouseOut(evt:MouseEvent):void {
			
		}
		
		public function mouseUp(evt:MouseEvent):void {
			
		}
		
		public function mouseMove(evt:MouseEvent):void {
			
		}
		
		public function rollOver(evt:MouseEvent):Boolean {
			return true;
		}
		
		public function rollOut(evt:MouseEvent):Boolean {
			return true;
		}
	}
}