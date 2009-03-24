package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.control.Control;
	import org.openscales.core.event.OpenScalesEvent;
	import org.openscales.core.basetypes.Pixel;

	public class MouseWheel extends Handler
	{
		
		public var wheelListener:Function = null;

    	public var mousePosition:Pixel = null;
    	
    	public function MouseWheel(control:Control, callbacks:Object, options:Object = null):void {
    		super(control, callbacks, options);
    		this.wheelListener = this.onWheelEvent;
    	}
    	
    	override public function destroy():void {
    		super.destroy();
    		this.wheelListener = null;
    	}
    	
    	public function onWheelEvent(evt:MouseEvent):void {
	        if (!this.checkModifiers(evt)) {
	            return;
	        }

	        var inMap:Boolean = false;
	        var elem:Object = evt.currentTarget;
	        while(elem != null) {
	            if (this.map && elem == this.map) {
	                inMap = true;
	                break;
	            }
	            elem = elem.parent;
	        }
	        
	        if (inMap) {
	            var delta:Number = 0;
	            if (evt.delta) {
	                delta = evt.delta/120; 
	            }
	            if (delta) {
	                if (delta < 0) {
	                   this.callback("down", [evt]);
	                } else {
	                   this.callback("up", [evt]);
	                }
	            }

	            OpenScalesEvent.stop(evt);
	        }

    	}
		
		public function mouseMove(evt:MouseEvent):void {
			this.mousePosition = new Pixel(evt.stageX, evt.stageY);
		}
		
		override public function activate(evt:MouseEvent = null):Boolean {
			if (super.activate()){
				var wheelListener:Function = this.wheelListener;
				new OpenScalesEvent().observe(this.map, MouseEvent.MOUSE_WHEEL, wheelListener);
				return true;
			} else {
				return false;
			}
		}
		
		override public function deactivate(evt:MouseEvent = null):Boolean {
			if (super.deactivate()) {
				var wheelListener:Function = this.wheelListener;
				new OpenScalesEvent().stopObserving(this.map, MouseEvent.MOUSE_WHEEL, wheelListener);
				return true;
			} else {
				return false;
			}
		}
		
		public function mouseDown(evt:MouseEvent):void {
			
		}
		
		public function mouseOut(evt:MouseEvent):void {
			
		}
		
		public function click(evt:MouseEvent):void {
			
		}
		
		public function mouseUp(evt:MouseEvent):void {
		}
		
		public function rollOver(evt:MouseEvent):Boolean {
			return true;
		}
		
		public function rollOut(evt:MouseEvent):Boolean {
			return true;
		}
	}
}