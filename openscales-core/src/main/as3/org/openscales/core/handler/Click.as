package org.openscales.core.handler
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import org.openscales.core.control.Control;
	import org.openscales.core.Timer;
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
    	
    	public var timer:Timer = null;
		
		public function Click(control:Control, callbacks:Object, options:Object):void {
			super(control, callbacks, options);
			
			/*if(!isNaN(this.pixelTolerance)) {
	            this.mouseDown = function(evt:MouseEvent):Boolean {
	                this.down = new Pixel(map.mouseX, map.mouseY);
	                return true;
	            };
	        }*/
		}
		
		//public var mouseDown:Function = null;
		
		override public function doubleClick(evt:MouseEvent):Boolean {
			if(this.passesTolerance(evt)) {
	            if(this["double"]) {
	                this.callback('doubleClick', [evt]);
	            }
	            this.clearTimer();
	        }
	        return true;
		}
		
		public override function click(evt:MouseEvent):Boolean {
			if(this.passesTolerance(evt)) {
	            if(this.timer) {
	                this.clearTimer();
	            } else {
	                var clickEvent : Event = this.single ? evt : null;
	                this.timer = new Timer(this.delay);
	                this.timer.mouseevent = evt;
	                //new OpenScalesEvent().observe(this.timer, TimerEvent.TIMER, this.delayedCall);
	                //this.timer.start();
	            }
	        }
	        return true;
		}
		
		public function passesTolerance(evt:MouseEvent):Boolean {
			var passes:Boolean = true;
	        if(this.pixelTolerance && this.down) {
	            var dpx:Number = Math.sqrt(
	                Math.pow(this.down.x - map.mouseX, 2) +
	                Math.pow(this.down.y - map.mouseY, 2)
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
		
		public override function mouseDown(evt:MouseEvent):Boolean {
            this.down = new Pixel(evt.stageX, evt.stageY);
            return true;
        }		
	}
}