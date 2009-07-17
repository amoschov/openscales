package org.openscales.core.basetypes
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * DraggableSprite inherits from Sprite.
	 * It adds specific methods to be able to drag it from mouse events (Down, Move, Up).
	 * It was created to be able to drag several sprites at same time on the contrary of native
	 * dragging methods of Sprite.
	 */
	public class DraggableSprite extends Sprite
	{
		private var _dragging:Boolean = false;
		private var _prev:Point;
		
		override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void
		{
			_dragging = true;
			_prev = new Point(stage.mouseX, stage.mouseY);
			
			if (lockCenter) {
				// Untested
				this.x += this.mouseX * this.scaleX;
				this.y += this.mouseY * this.scaleY;
			}
			
			registerListeners();
		}
		
		override public function stopDrag():void
		{
			_dragging = false;
			unregisterListeners();
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			this.x += - _prev.x + (_prev.x = stage.mouseX);
			this.y += - _prev.y + (_prev.y = stage.mouseY);
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
