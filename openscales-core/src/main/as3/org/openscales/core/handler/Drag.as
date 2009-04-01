package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.control.Control;

	public class Drag extends Handler
	{
		public var started:Boolean = false;
    
    	public var stopDown:Boolean = true;

    	public var oldOnselectstart:Function = null;

		public static var onselectstart:Function = null;

		public function Drag(control:Control, options:Object = null):void {
			super(control, options);
		}
		
		override public function activate():void {
            this.dragging = false;
           	this.map.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown);
           	this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
           	this.map.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp);
           	this.map.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut);
		}
		
		override public function deactivate():void {
            this.started = false;
	        this.dragging = false;
	        this.start = null;
	        this.last = null;
           	this.map.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown); 
           	this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
           	this.map.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUp);
           	this.map.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseOut);
		}
		
		/**
		 * function down(xy:Pixel):void
		 */
		public var down:Function = null;
		
		/**
		 * function move(xy:Pixel):void
		 */
		public var move:Function = null;
		
		/**
		 * function up(xy:Pixel):void
		 */
		public var up:Function = null;
		
		/**
		 * function out():void
		 */
		public var out:Function = null;
		
		/**
		 * function done(xy:Pixel):void 
		 */
		public var done:Function = null;
				
		
		protected function mouseDown(evt:MouseEvent):Boolean {
			var propagate:Boolean = true;
	        this.dragging = false;
	        if (this.checkModifiers(evt)) {
	            this.started = true;
	            this.start = new Pixel(map.mouseX, map.mouseY);
	            this.last = new Pixel(map.mouseX, map.mouseY);
	            this.map.buttonMode = true;
	            this.map.useHandCursor = true;
	            this.down(new Pixel(map.mouseX, map.mouseY));
	            
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
		
		protected function mouseMove(evt:MouseEvent):Boolean {
			if (this.started) {
	            if(map.mouseX != this.last.x || map.mouseY != this.last.y) {
	                
	                this.dragging = true;
	                this.move(new Pixel(map.mouseX, map.mouseY));
	                if(this.oldOnselectstart == null) {
	                    this.oldOnselectstart = Drag.onselectstart;
	                    Drag.onselectstart = function():Boolean {return false;};
	                }
	                this.last = new Pixel(map.mouseX, map.mouseY);
	            }
	        }
	        return true;
		}
		
		protected function mouseUp(evt:MouseEvent):Boolean {
			if (this.started) {
	            var dragged:Boolean = (this.start != this.last);
	            this.started = false;
	            this.dragging = false;
	            this.map.useHandCursor = false;
	            this.map.buttonMode = false;
	            if(this.up != null)
	            	this.up(new Pixel(map.mouseX, map.mouseY));
	            if(dragged) {
	                this.done(new Pixel(map.mouseX, map.mouseY));
	            }
	            Drag.onselectstart = this.oldOnselectstart;
	        }
	        return true;
		}
		
		protected function mouseOut(evt:MouseEvent):Boolean {
			if (this.started && Util.mouseLeft(evt, this.map)) {
	            var dragged:Boolean = (this.start != this.last);
	            this.started = false; 
	            this.dragging = false;
	            this.map.useHandCursor = false;
	            this.out();

	            if(dragged) {
	                this.done(new Pixel(map.mouseX, map.mouseY));
	            }
	            if(Drag.onselectstart != null) {
	                Drag.onselectstart = this.oldOnselectstart;
	            }
	        }
	        return true;
		}
		
		
	}
}