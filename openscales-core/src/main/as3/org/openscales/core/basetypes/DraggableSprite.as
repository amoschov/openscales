package org.openscales.core.basetypes
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DraggableSprite extends Sprite
	{
		private var _dragging:Boolean = false;
		private var _start:Point;
		
		override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void
		{
			_dragging = true;
			_start = new Point(mouseX, mouseY);
			registerListeners();
		}
		
		override public function stopDrag():void
		{
			_dragging = false;
			unregisterListeners();
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			this.x += mouseX - _start.x;
			this.y += mouseY - _start.y;
		}
		
		private function registerListeners():void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function unregisterListeners():void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function get dragging():Boolean
		{
			return this._dragging;
		}
	}
}
