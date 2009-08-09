package flex.utils.ui.resize {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.MouseEvent;

	import mx.controls.Button;
	import mx.core.DragSource;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;

	/**
	 * Similar to the ResizeManager, this class adds support for moving a component by dragging it
	 * with the mouse.
	 *
	 * @author Chris Callendar
	 * @date March 17th, 2009
	 */
	public class MoveManager {

		private const MOVE_HANDLE_WIDTH:int=6;
		private const MOVE_HANDLE_HEIGHT:int=14;

		private var moveInitX:Number=0;
		private var moveInitY:Number=0;

		private var _moveHandle:UIComponent;

		// the component that is being moved
		private var moveComponent:UIComponent;
		// the component that when dragged causes the above component to move
		private var dragComponent:UIComponent;
		// the component that the move handle is added to
		private var moveHandleParent:UIComponent;

		public function MoveManager() {
		}

		/**
		 * Adds support for moving a component.
		 * @param moveComponent the component that will have its x and y values changed
		 * @param dragComponent the component that will have a mouse_down listener added to listen
		 *  for when the user drags it.  If null then the moveComponent is used instead.
		 * @param moveHandleParent the parent component which will have the move handle added to it.
		 *  If null then it is added to the moveComponent.
		 */
		public function addMoveSupport(moveComponent:UIComponent, dragComponent:UIComponent=null, moveHandleParent:UIComponent=null):void {
			this.moveComponent=moveComponent;
			this.dragComponent=dragComponent;
			this.moveHandleParent=moveHandleParent;

			if (moveHandleParent) {
				moveHandleParent.addChildAt(moveHandle, 0);
			} else if (moveComponent) {
				moveComponent.addChildAt(moveHandle, 0);
			}
			if (dragComponent) {
				dragComponent.addEventListener(MouseEvent.MOUSE_DOWN, dragComponentMouseDown);
			} else if (moveComponent) {
				moveComponent.addEventListener(MouseEvent.MOUSE_DOWN, dragComponentMouseDown);
			}
		}

		/**
		 * Removes move support, removes the mouse listener and the move handle.
		 */
		public function removeMoveSupport():void {
			if (dragComponent) {
				dragComponent.removeEventListener(MouseEvent.MOUSE_DOWN, dragComponentMouseDown);
			} else if (moveComponent) {
				moveComponent.removeEventListener(MouseEvent.MOUSE_DOWN, dragComponentMouseDown);
			}
			if (moveHandleParent) {
				moveHandleParent.removeChild(moveHandle);
			} else if (moveComponent) {
				moveComponent.removeChild(moveHandle);
			}
		}

		/**
		 * Returns the move handle component.
		 */
		public function get moveHandle():UIComponent {
			if (_moveHandle == null) {
				_moveHandle=new UIComponent();
				_moveHandle.width=MOVE_HANDLE_WIDTH;
				_moveHandle.height=MOVE_HANDLE_HEIGHT;
			}
			return _moveHandle;
		}

		/**
		 * Draws a 6x14 move/drag handle.
		 */
		public function drawMoveHandle(parentW:Number, parentH:Number, color:uint=0x666666, alpha:Number=1):void {
			var g:Graphics=moveHandle.graphics;
			g.clear();
			var xx:int=2;
			var yy:int=2;
			for (var i:int=0; i < 4; i++) {
				drawDot(g, color, alpha, xx, yy + (i * 4));
					//drawDot(g, color, alpha, xx + 4, yy + (i * 4));
			}
		}

		/**
		 * Draws a single (2x2) dot.
		 */
		private function drawDot(g:Graphics, color:uint, alpha:Number, xx:Number, yy:Number, w:Number=2, h:Number=2):void {
			g.lineStyle(0, 0, 0);
			g.beginFill(color, alpha);
			g.drawRect(xx, yy, w, h);
			g.endFill();
		}

		/**
		 * This function gets called when the user presses down the mouse button on the
		 * dragComponent (or if not specified then the moveComponent).
		 * It starts the drag process.
		 */
		private function dragComponentMouseDown(event:MouseEvent):void {
			// special case - ignore if the target is a button (e.g. close button)
			if (event.target is Button) {
				return;
			}

			moveInitX=event.currentTarget.mouseX;
			moveInitY=event.currentTarget.mouseY;

			moveComponent.parent.addEventListener(DragEvent.DRAG_ENTER, dragEnter);
			moveComponent.parent.addEventListener(DragEvent.DRAG_DROP, dragDrop);

			var ds:DragSource=new DragSource();
			ds.addData(moveComponent, 'MoveManager');
			DragManager.doDrag(moveComponent, ds, event);
		}

		private function dragEnter(event:DragEvent):void {
			if (event.target is IUIComponent) {
				DragManager.acceptDragDrop((event.target as IUIComponent));
			}
		}

		private function dragDrop(event:DragEvent):void {
			// Compensate for the mouse pointer's location in the title bar.
			var newX:int=event.currentTarget.mouseX - moveInitX;
			event.dragInitiator.x=newX;
			var newY:int=event.currentTarget.mouseY - moveInitY;
			event.dragInitiator.y=newY;

			(event.dragInitiator as UIComponent).setStyle("top", NaN);
			(event.dragInitiator as UIComponent).setStyle("right", NaN);
			(event.dragInitiator as UIComponent).setStyle("bottom", NaN);
			(event.dragInitiator as UIComponent).setStyle("left", NaN);
			(event.dragInitiator as UIComponent).setStyle("horizontalCenter", NaN);
			(event.dragInitiator as UIComponent).setStyle("verticalCenter", NaN);

			// Put the dragged item on top of all other components.
			moveComponent.parent.setChildIndex((event.dragInitiator as DisplayObject), moveComponent.parent.numChildren - 1);

			moveComponent.parent.removeEventListener(DragEvent.DRAG_ENTER, dragEnter);
			moveComponent.parent.removeEventListener(DragEvent.DRAG_DROP, dragDrop);
		}

	}
}