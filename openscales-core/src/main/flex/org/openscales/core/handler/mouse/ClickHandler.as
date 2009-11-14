package org.openscales.core.handler.mouse
{
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Rectangle;
	
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
		 * Pixel under the cursor when the mouse is down
		 */
		protected var _downPixel:Pixel = null;
		
		/**
		 *  Pixel under the cursor when the mouse is up
		 */
		protected var _upPixel:Pixel = null;
		
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
		 * CTRL is pressed ?
		 */
		protected var _ctrlKey:Boolean = false;
		
		/**
		 * SHIFT is pressed ?
		 */
		protected var _shiftKey:Boolean = false;
		
		protected var _dragging:Boolean = false;
				
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
		 * Map coordinates (in its baselayer's SRS) of the point clicked (at the
		 * beginning of the drag)
		 */
		protected function startCoordinates():LonLat {
			return (this.map && this._downPixel) ? this.map.getLonLatFromMapPx(this._downPixel) : null;
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
		protected function selectionBoxPixels(p:Pixel, buffer:Number=0):Rectangle {
			if (! this._downPixel) {
				return null;
			}
			var left:Number = Math.min(this._downPixel.x,p.x) - buffer;
			var top:Number = Math.min(this._downPixel.y,p.y) - buffer;
			var w:Number = Math.abs(this._downPixel.x-p.x) + 2*buffer;
			var h:Number = Math.abs(this._downPixel.y-p.y) + 2*buffer;
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
		protected function selectionBoxCoordinates(p:Pixel, buffer:Number=0):Bounds {
			var rect:Rectangle = this.selectionBoxPixels(p, buffer);
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
			this._downPixel = null;
			this._upPixel = null;
			this._ctrlKey = false;
			this._shiftKey = false;
			this._dragging = false;
			// Listeners of the internal timer
			this._timer.removeEventListener(TimerEvent.TIMER, useRightCallback);
			this._timer.stop();
			this._clickNum = 0;
			// Listeners of the super class
			super.unregisterListeners();
		}
		
		/**
		 * The MouseDown Listener
		 * @param evt the MouseEvent
		 */
		protected function mouseDown(evt:MouseEvent):void {
			if (evt) {
				this._downPixel = new Pixel(evt.currentTarget.mouseX, evt.currentTarget.mouseY);
				this.map.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
			}
		}
		
		/**
		 * The MouseMove Listener
		 * @param evt the MouseEvent
		 */
		protected function mouseMove(evt:MouseEvent):void {
			if (evt) {
				this._dragging = true;
				if (this.drag != null) {
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
				
				this.map.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
				
				if (this._downPixel != null) {
					// It was not a drag, but was it a simple or a double click ?
					// Just wait for a timer duration to know and call the right function.
					this._upPixel = new Pixel(evt.currentTarget.mouseX, evt.currentTarget.mouseY);
					this._ctrlKey = evt.ctrlKey;
					this._shiftKey = evt.shiftKey;
					this._clickNum++;
					this._timer.start();
				}
			}
		}
		
		/**
		 * Define if there was a double click or a simple click (drag&drop is
		 * managed before if needed).
		 * @param evt the TimerEvent (not used)
		 */
		private function useRightCallback(evt:TimerEvent):void {
			if(this._dragging) {
				this._dragging = false;
				if (this.drop != null) {
					// Use the callback function for a drop click
					this.drop(this._upPixel);
				}	
			} else if (this._clickNum == 1) {
				if (this.click != null) {
					// Use the callback function for a simple click
					this.click(this._upPixel);
				}
			} else if (this.doubleClick != null) {
					// Use the callback function for a double click
					this.doubleClick(this._upPixel);
			}
			
			this._timer.stop();
			this._clickNum = 0;
			this._downPixel = null;
			this._upPixel = null;
			this._ctrlKey = false;
			this._shiftKey = false;
		}
		
	}
}
