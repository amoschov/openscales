package org.openscales.core.cursor
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.control.MousePosition;
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	
	/**
	 * Crosshair cursor that displays the coordinates of the location pointed.
	 * 
	 * Inspired from http://jessewarden.com/2009/01/making-a-cooler-cursor-in-flex.html
	 */
	[Embed(source="/org/openscales/core/img/cursorCrosshair.swf", symbol="CrosshairCursor")]
	public class CrosshairCursor extends Sprite
	{
		public var xValue:TextField; // must be public for a use by cursorCrosshair.swf
		public var yValue:TextField; // must be public for a use by cursorCrosshair.swf
		protected var mapCoordinatesNumDigits:int = 3;
		
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
        protected function updateCursor(event:MouseEvent):void {
        	// Try to get a map under the cursor
			var objects:Array = (event.currentTarget as Stage).getObjectsUnderPoint(new flash.geom.Point(stage.mouseX,stage.mouseY));
			var map:Map = null;
			for(var i:int=0; i<objects.length; i++) {
				if (objects[i] is Map) {
					map = objects[i];
					break;
				}
			}
			// Display the position of the mouse
map = null; // FixMe: the display of the coordinates is limited to 3 digits currently :-(
			if (map) {
				// Display the position in the map's coordinate system
				var lonLat:LonLat = map.center;
				var mousePosition:MousePosition = null;
				for(i=0; i<map.controls.length; i++) {
					if (map.controls[i] is MousePosition) {
						mousePosition = map.controls[i];
						break;
					}
				}
				if (mousePosition) {
					mapCoordinatesNumDigits = mousePosition.numdigits;
					if (mousePosition.displayProjection.srsCode != map.projection.srsCode) {
						lonLat.transform(map.projection, mousePosition.displayProjection);
					}
				}
				xValue.text = lonLat.lon.toFixed(mapCoordinatesNumDigits);
				yValue.text = lonLat.lat.toFixed(mapCoordinatesNumDigits);
			} else {
				// Display the position in pixels
				xValue.text = stage.mouseX.toString();
				yValue.text = stage.mouseY.toString();
			}
			// Update
			event.updateAfterEvent();
		}
		
	}
}