package org.openscales.core.cursor
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * Crosshair cursor that displays the coordinates of the location pointed.
	 * 
	 * Inspired from http://jessewarden.com/2009/01/making-a-cooler-cursor-in-flex.html
	 */
	[Embed(source="/org/openscales/core/img/cursorCrosshair.swf", symbol="CrosshairCursor")]
	public class CrosshairCursor extends Sprite
	{
		public var xValue:TextField;
		public var yValue:TextField;

		/**
		 * Cursor constructor
		 */		
		public function CrosshairCursor() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		/**
		 * Link the cursor with the stage for MOUSE_MOVE event
		 */
        private function onAddedToStage(event:Event):void {
        	stage.addEventListener(MouseEvent.MOUSE_MOVE, updateCursor);
        }
		
		/**
		 * Unlink the cursor with the stage for MOUSE_MOVE event
		 */
        private function onRemovedFromStage(event:Event):void {
        	stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateCursor);
        }
		
		/**
		 * Update the cursor depending on the mouse position on the stage.
		 */
        private function updateCursor(event:MouseEvent):void {
        	// FixMe: replace the stage coordinates (pixels) by the map coordinates
        	// in the current coordinate system used by MousePosition
			xValue.text = stage.mouseX.toString();
			yValue.text = stage.mouseY.toString();
			event.updateAfterEvent();
		}
		
	}
}