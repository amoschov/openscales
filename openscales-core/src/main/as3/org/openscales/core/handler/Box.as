package org.openscales.core.handler
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.control.Control;

	public class Box extends Handler
	{
		
		public var dragHandler:Drag = null;
		
		public var zoomBox:Sprite = null;
		
		public function Box(control:Control, callbacks:Object, options:Object):void {
			super(control, callbacks, options);
			var callbacks:Object = {
	            "down": this.startBox, 
	            "move": this.moveBox, 
	            "out":  this.removeBox,
	            "up":   this.endBox
	        };
	        this.dragHandler = new Drag(
	                                this, callbacks, {keyMask: this.keyMask});
		}
		
		override public function setMap(map:Map):void {
			super.setMap(map);
			if (this.dragHandler) {
            	this.dragHandler.setMap(map);
        	}
		}
		
		public function startBox(xy:Pixel):void {
			this.zoomBox = new Sprite();
			this.zoomBox.name = "zoomBox";
			this.zoomBox.x = this.dragHandler.start.x;
			this.zoomBox.y = this.dragHandler.start.y;
			
	        this.map.addChild(this.zoomBox);
		}
		
		public function moveBox(xy:Pixel):void {
			var startX:Number = this.dragHandler.start.x;
	        var startY:Number = this.dragHandler.start.y;
	        var deltaX:Number = Math.abs(startX - xy.x);
	        var deltaY:Number = Math.abs(startY - xy.y);
	        this.zoomBox.width = Math.max(1, deltaX);
	        this.zoomBox.height = Math.max(1, deltaY);
	        this.zoomBox.x = xy.x < startX ? xy.x : startX;
	        this.zoomBox.y = xy.y < startY ? xy.y : startY;
		}
		
		public function endBox(end:Pixel):void {
			var result:Object;
	        if (Math.abs(this.dragHandler.start.x - end.x) > 5 ||    
	            Math.abs(this.dragHandler.start.y - end.y) > 5) {   
	            var start:Pixel = this.dragHandler.start;
	            var top:Number = Math.min(start.y, end.y);
	            var bottom:Number = Math.max(start.y, end.y);
	            var left:Number = Math.min(start.x, end.x);
	            var right:Number = Math.max(start.x, end.x);
	            result = new Bounds(left, bottom, right, top);
	        } else {
	            result = this.dragHandler.start.clone(); // i.e. OL.Pixel
	        } 
	        this.removeBox();
	
	        this.callback("done", [result]);
		}
		
		public function removeBox():void {
			this.map.removeChild(this.zoomBox);
        	this.zoomBox = null;
		}
		
		override public function activate(evt:MouseEvent=null):Boolean {
			if (super.activate(evt)) {
				this.dragHandler.activate();
				return true;
			} else {
				return false;
			}
		}
		
		override public function deactivate(evt:MouseEvent=null):Boolean {
			if (super.deactivate(evt)) {
				this.dragHandler.deactivate();
				return true;
			} else {
				return false;
			}
		}
		
	}
}