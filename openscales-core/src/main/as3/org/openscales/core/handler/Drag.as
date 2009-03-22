package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.event.OpenScalesEvent;
	import org.openscales.core.Handler;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Pixel;

	public class Drag extends Handler
	{
		public var started:Boolean = false;
    
    	public var stopDown:Boolean = true;

    	public var oldOnselectstart:Function = null;

		public static var onselectstart:Function = null;

		public function Drag(control:*, callbacks:Object, options:Object = null):void {
			super(control, callbacks, options);
		}
		
		public function down(evt:MouseEvent):void {
			
		}
		
		public function move(evt:MouseEvent):void {
			
		}
		
		public function up(evt:MouseEvent):void {
			
		}
		
		public function out(evt:MouseEvent):void {
			
		}
		
		public function mouseDown(evt:MouseEvent):Boolean {
			var propagate:Boolean = true;
	        this.dragging = false;
	        if (this.checkModifiers(evt) && OpenScalesEvent.isLeftClick(evt)) {
	            this.started = true;
	            this.start = new Pixel(evt.stageX, evt.stageY);
	            this.last = new Pixel(evt.stageX, evt.stageY);
	            this.map.buttonMode = true;
	            this.map.useHandCursor = true;
	            this.down(evt);
	            this.callback("down", [new Pixel(evt.stageX, evt.stageY)]);
	            
	            if(this.oldOnselectstart == null) {
	                this.oldOnselectstart = (Drag.onselectstart != null) ? Drag.onselectstart : function():Boolean { return true; };
                	Drag.onselectstart = function():Boolean {return false;};
	            }
	            
	            propagate = !this.stopDown;
	        } else {
	            this.started = false;
	            this.start = null;
	            this.last = null;
	        }
	        return propagate;
		}
		
		public function mouseMove(evt:MouseEvent):Boolean {
			if (this.started) {
	            if(evt.stageX != this.last.x || evt.stageY != this.last.y) {
	                
	                this.dragging = true;
	                this.move(evt);
	                
	                this.callback("move", [new Pixel(evt.stageX, evt.stageY)]);
	                if(this.oldOnselectstart == null) {
	                    this.oldOnselectstart = Drag.onselectstart;
	                    Drag.onselectstart = function():Boolean {return false;};
	                }
	                this.last = new Pixel(evt.stageX, evt.stageY);
	            }
	        }
	        return true;
		}
		
		public function mouseUp(evt:MouseEvent):Boolean {
			if (this.started) {
	            var dragged:Boolean = (this.start != this.last);
	            this.started = false;
	            this.dragging = false;
	            this.map.useHandCursor = false;
	            this.map.buttonMode = false;
	            this.up(evt);
	            this.callback("up", [new Pixel(evt.stageX, evt.stageY)]);
	            if(dragged) {
	                this.callback("done", [new Pixel(evt.stageX, evt.stageY)]);
	            }
	            Drag.onselectstart = this.oldOnselectstart;
	        }
	        return true;
		}
		
		public function mouseOut(evt:MouseEvent):Boolean {
			if (this.started && Util.mouseLeft(evt, this.map)) {
	            var dragged:Boolean = (this.start != this.last);
	            this.started = false; 
	            this.dragging = false;
	            this.map.useHandCursor = false;
	            this.out(evt);
	            this.callback("out", []);
	            if(dragged) {
	                this.callback("done", [new Pixel(evt.stageX, evt.stageY)]);
	            }
	            if(Drag.onselectstart != null) {
	                Drag.onselectstart = this.oldOnselectstart;
	            }
	        }
	        return true;
		}
		
		public function rollOver(evt:MouseEvent):Boolean {
			return true;
		}
		
		public function rollOut(evt:MouseEvent):Boolean {
			return true;
		}
		
		public function click(evt:MouseEvent):Boolean {
			return (this.start == this.last);
		}
		
		override public function activate(evt:MouseEvent=null):Boolean {
			var activated:Boolean = false;
	        if(super.activate(evt)) {
	            this.dragging = false;
	            activated = true;
	        }
	        return activated;
		}
		
		override public function deactivate(evt:MouseEvent=null):Boolean {
			var deactivated:Boolean = false;
	        if(super.deactivate(evt)) {
	            this.started = false;
	            this.dragging = false;
	            this.start = null;
	            this.last = null;
	            deactivated = true;
	        }
	        return deactivated;
		}
		
	}
}