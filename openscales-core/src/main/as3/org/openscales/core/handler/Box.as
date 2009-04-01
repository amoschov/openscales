package org.openscales.core.handler
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.control.Control;

	public class Box extends Drag
	{
		
		public var zoomBox:Sprite = null;
		
		public function Box(control:Control, options:Object=null):void {
			super(control, options);

		}
		
		override protected function mouseDown(evt:MouseEvent):Boolean  {
			var result:Boolean = super.mouseDown(evt);
			
			this.zoomBox = new Sprite();
			this.zoomBox.name = "zoomBox";
			this.zoomBox.x = this.start.x;
			this.zoomBox.y = this.start.y;
			
	        this.map.addChild(this.zoomBox);
	        
	        return result;
		}
		
		override protected function mouseMove(evt:MouseEvent):Boolean {
			var result:Boolean = super.mouseMove(evt);
			
			var startX:Number = this.start.x;
	        var startY:Number = this.start.y;
	        var deltaX:Number = Math.abs(startX - this.last.x);
	        var deltaY:Number = Math.abs(startY - this.last.y);
	        this.zoomBox.width = Math.max(1, deltaX);
	        this.zoomBox.height = Math.max(1, deltaY);
	        this.zoomBox.x = this.last.x < startX ? this.last.x : startX;
	        this.zoomBox.y = this.last.y < startY ? this.last.y : startY;
	        
	        return result;
		}
		
		override protected function mouseUp(evt:MouseEvent):Boolean {
			this.removeBox();
			
			return super.mouseUp(evt);
	
		}
		
		public function removeBox():void {
			this.map.removeChild(this.zoomBox);
        	this.zoomBox = null;
		}
		
		override public function activate():void {
			super.activate();
		}
		
		override public function deactivate():void {
			super.deactivate();
		}
		
	}
}