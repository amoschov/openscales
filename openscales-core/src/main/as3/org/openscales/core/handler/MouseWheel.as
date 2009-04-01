package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.control.Control;

	public class MouseWheel extends Handler
	{
    	
    	public function MouseWheel(control:Control, options:Object = null):void {
    		super(control, options);
    	}
    	
    	override public function activate():void {
			this.map.addEventListener(MouseEvent.MOUSE_WHEEL, this.onWheelEvent);
		}
		
		override public function deactivate():void {
			this.map.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onWheelEvent);
		}
		
		/**
		 * function down(evt:MouseEvent):void
		 */
		public var down:Function = null;
    	
    	/**
		 * function up(evt:MouseEvent):void
		 */
		public var up:Function = null;
    	
    	
    	private function onWheelEvent(evt:MouseEvent):void {
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
	                   this.down(evt);
	                } else {
	                   this.up(evt);
	                }
	            }

	        }

    	}
		
	}
}