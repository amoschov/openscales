package org.openscales.core.handler.mouse
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.handler.Handler;
	
	/**
	 * ClickHandler detects a click-actions on the map: simple click, double
	 * click and drag&drop are managed.
	 *
	 * To use this handler, it's  necessary to add it to the map.
	 * It is a pure ActionScript class. Flex wrapper and components can be found
	 * in the openscales-fx module (same name prefixed by Fx).
	 */
	public class ClickHandler extends Handler
	{
		/**
		 * Callback function click(evt:MouseEvent):void
		 * This function is called after a MouseUp event (in the case of a
		 * simple click)
		 */
		private var _click:Function = null;
		
		/**
		 * Callback function doubleClick(evt:MouseEvent):void
		 * This function is called after a MouseUp event (in the case of a
		 * double click)
		 */
		private var _doubleClick:Function = null;
		
		/**
		 * Callback function drag(evt:MouseEvent):void
		 * This function is called during a MouseMove event (in the case of a
		 * drag&drop click) ; the function is not called at the MouseDown time.
		 */
		private var _drag:Function = null;
		
		/**
		 * Callback function drop(evt:MouseEvent):void
		 * This function is called after a MouseUp event (in the case of a
		 * drag&drop click)
		 */
		private var _drop:Function = null;
		
		/**
		 * Tolerance (in pixels) used to detect a drag or a click: distance
		 * between the two positions at mouseDown and MouseUp times.
		 */
		private var _tolerance:Number = 5;
		
		/**
		 * Pixel clicked (at the beginning of a drag)
		 */
		protected var _startPixel:Pixel = null;
		
		/**
		 * Boolean defining if the mouse is dragging or not
		 */
		private var _dragging:Boolean = false;
		
		/**
		 * Timer used to detect a double click without throwing a simple click
		 */
		private var _timer:Timer = new Timer(250,1);
		
		/**
		 * Number of click since the beginning of the timer.
		 * It is used to decide if the user has done a simple or a double click.
		 */
		private var _clickNum:Number = 0;
		
		/**
		 * Save the MouseEvent of the simple/double/drag click during the time
		 * needed to know the kind of the click.
		 */
		private var _mouseEvent:MouseEvent = null;
		
		/**
		 * Constructor of the handler.
		 * @param map the map associated to the handler
		 * @param active boolean defining if the handler is active or not
		 */
		public function ClickHandler(map:Map=null, active:Boolean=false) {
			super(map, active);
		}
		
		/**
		 * Click function getter and setter
		 */
		public function get click():Function {
			return this._click;
		}
		public function set click(value:Function):void {
			this._click = value;
		}
		
		/**
		 * Double click function getter and setter
		 */
		public function get doubleClick():Function {
			return this._doubleClick;
		}
		public function set doubleClick(value:Function):void {
			this._doubleClick = value;
		}
		
		/**
		 * Drag function getter and setter
		 */
		public function get drag():Function {
			return this._drag;
		}
		public function set drag(value:Function):void {
			this._drag = value;
		}
		
		/**
		 * Drop function getter and setter
		 */
		public function get drop():Function {
			return this._drop;
		}
		public function set drop(value:Function):void {
			this._drop = value;
		}
		
		/**
		 * Tolerance (in pixels) used to detect a drag or a click.
		 * The default value is 5 pixels.
		 */
		public function get tolerance():Number {
			return this._tolerance;
		}
		public function set tolerance(value:Number):void {
			this._tolerance = value;
		}
		
		/**
		 * Map coordinates (in its baselayer's SRS) of the point clicked (at the
		 * beginning of the drag)
		 */
		protected function startCoordinates():LonLat {
			return (this.map && this._startPixel) ? this.map.getLonLatFromMapPx(this._startPixel) : null;
		}
		
		/**
		 * The select box, in pixels, defining by the pixel clicked at the
		 * beginning of the drag (mouseDown) and the pixel where the mouseUp
		 * event occurs.
		 * 
		 * @param evt the MouseEvent that defines the second point of the box
		 * @param buffer the buffer, in pixels, to use to enlarge the selection
		 * box (useful to improve the ergonomy)
		 */
		protected function selectionBoxPixels(evt:MouseEvent, buffer:Number=0):Rectangle {
			if (! this._startPixel) {
				return null;
			}
			var left:Number = Math.min(this._startPixel.x,evt.currentTarget.mouseX) - buffer;
			var top:Number = Math.min(this._startPixel.y,evt.currentTarget.mouseY) - buffer;
			var w:Number = Math.abs(this._startPixel.x-evt.currentTarget.mouseX) + 2*buffer;
			var h:Number = Math.abs(this._startPixel.y-evt.currentTarget.mouseY) + 2*buffer;
			return new Rectangle(left, top, w, h);
		}
		
		/**
		 * The select box, in map's coordinates, defining by the point clicked
		 * at the beginning of the drag (mouseDown) and the point where the
		 * mouseUp event occurs.
		 * This function calls selectBoxPixels and convert the Rectangle of
		 * pixels in a  Bounds of map's coordinates.
		 * 
		 * @param evt the MouseEvent that defines the second point of the box
		 * @param buffer the buffer, in pixels (not in coordinates), to use to
		 * enlarge the selection box (useful to improve the ergonomy)
		 * */
		protected function selectionBoxCoordinates(evt:MouseEvent, buffer:Number=0):Bounds {
			var rect:Rectangle = this.selectionBoxPixels(evt);
			if ((! rect) || (! this.map)) {
				return null;
			}
			var bottomLeft:LonLat = this.map.getLonLatFromMapPx(new Pixel(rect.left, rect.bottom));
			var topRight:LonLat = this.map.getLonLatFromMapPx(new Pixel(rect.right, rect.top));
			return new Bounds(bottomLeft.lon, bottomLeft.lat, topRight.lon, topRight.lat);
		}
		
		/**
		 * Add the listeners to the associated map
		 */
		override protected function registerListeners():void {
			// Listeners of the super class
			super.registerListeners();
			// Listeners of the internal timer
			this._timer.addEventListener(TimerEvent.TIMER, useRightCallback);
			// Listeners of the associated map
			if (this.map) {
				this.map.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
				this.map.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
				this.map.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
			}
		}
		
		/**
		 * Remove the listeners to the associated map
		 */
		override protected function unregisterListeners():void {
			// Listeners of the associated map
			if (this.map) {
				this.map.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
				this.map.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
				this.map.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
			}
			this._startPixel = null;
			this._dragging = false;
			// Listeners of the internal timer
			this._timer.removeEventListener(TimerEvent.TIMER, useRightCallback);
			this._timer.stop();
			this._clickNum = 0;
			this._mouseEvent = null;
			// Listeners of the super class
			super.unregisterListeners();
		}
		
		/**
		 * The MouseDown Listener
		 * @param evt the MouseEvent
		 */
		protected function mouseDown(evt:MouseEvent):void {
			if (evt) {
				this._startPixel = new Pixel(evt.currentTarget.mouseX, evt.currentTarget.mouseY);
				this._dragging = false;
			}
		}
		
		/**
		 * The MouseMove Listener
		 * @param evt the MouseEvent
		 */
		protected function mouseMove(evt:MouseEvent):void {
			if (evt) {
				if ((! this._dragging) && (this._startPixel != null)) {
					// Compute the distance to the _startPixel at the MouseDown time
					var dx:Number = Math.abs(this._startPixel.x-evt.currentTarget.mouseX);
					var dy:Number = Math.abs(this._startPixel.y-evt.currentTarget.mouseY);
					if ((dx>this.tolerance) || (dy>this.tolerance)) {
						this._dragging = true;
					}
				}
				// Event if the distance to the _startPixel is currently lower
				// than the tolerance, if the _dragging mode is active we have
				// to call the _drag function if it is defined.
				if (this._dragging && (this.drag != null)) {
					// Use the callback function for a drag click
					this.drag(evt);
				}
			}
		}
		
		/**
		 * MouseUp Listener
		 * @param evt the MouseEvent
 		 */
		protected function mouseUp(evt:MouseEvent):void {
			if (evt) {
				if (this._dragging) {
					if (this.drop != null) {
						// Use the callback function for a drop click
						this.drop(evt);
					}
				}
				else if (this._startPixel != null) {
					// It was not a drag, but was it a simple or a double click ?
					// Just wait for a timer duration to know and call the right function.
					this._mouseEvent = evt;
					this._clickNum++;
					this._timer.start();
				}
			}
			this._startPixel = null;
			this._dragging = false;
		}
		
		/**
		 * Define if there was a double click or a simple click (drag&drop is
		 * managed before if needed).
		 * @param evt the TimerEvent (not used)
		 */
		private function useRightCallback(evt:TimerEvent):void {
			if (this._clickNum == 1) {
				if (this.click != null) {
					// Use the callback function for a simple click
					this.click(this._mouseEvent);
				}
			} else {
				if (this.doubleClick != null) {
					// Use the callback function for a double click
					this.doubleClick(this._mouseEvent);
				}
			}
			this._timer.stop();
			this._clickNum = 0;
			this._mouseEvent = null;
		}
		
	}
}
