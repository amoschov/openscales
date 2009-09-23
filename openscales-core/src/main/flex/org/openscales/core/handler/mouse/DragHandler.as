package org.openscales.core.handler.mouse
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.Map;
	import org.openscales.core.Trace;

	/**
	 *
	 * DragHandler is use to drag the map
	 * Create a new instance of  DragHandler with the constructor
	 *
	 * To use this handler, it's  necessary to add it to the map
	 * DragHandler is a pure ActionScript class. Flex wrapper and components can be found in the
	 * openscales-fx module FxClickHandler.
	 *
	 */
	public class DragHandler extends Handler
	{
		private var _startCenter:LonLat = null;
		private var _start:Pixel = null;

		private var _firstDrag:Boolean = true;

		private var _dragging:Boolean = false;
		
		/**
		 *Callbacks function
		 */
		private var _onStart:Function=null;
		private var _oncomplete:Function=null;

		/**
		 * DragHandler constructor
		 *
		 * @param map the DragHandler map
		 * @param active to determinates if the handler is active
		 */
		public function DragHandler(map:Map=null,active:Boolean=false)
		{
			super(map,active);
		}
		
		override protected function registerListeners():void{
			this.map.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.map.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
		}

		override protected function unregisterListeners():void{
			this.map.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.map.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
		}
		
		/**
		 * The MouseDown Listener
		 */
		protected function onMouseDown(event:Event):void
		{
			if (_firstDrag) {
				this.map.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
				_firstDrag = false;
			}

			this.map.layerContainer.startDrag();
			if (this.map.bitmapTransition)
				this.map.bitmapTransition.startDrag();

			this._start = new Pixel((event as MouseEvent).stageX,(event as MouseEvent).stageY);
			this._startCenter = this.map.center;
			this.map.buttonMode=true;
			this._dragging=true;
			this.map.dispatchEvent(new MapEvent(MapEvent.DRAG_START, this.map));
			if(this.onstart!=null)
				this.onstart(event as MouseEvent);
		}

		/**
		 *The MouseUp Listener
		 */
		protected function onMouseUp(event:Event):void {
			this.map.layerContainer.stopDrag();
			if (this.map.bitmapTransition)
				this.map.bitmapTransition.stopDrag();

			this.map.buttonMode=false;
			this.done(new Pixel((event as MouseEvent).stageX, (event as MouseEvent).stageY));
			// A MapEvent.MOVE_END is emitted by the "set center" called in this.done
			this._dragging=false;
			if (this.oncomplete!=null)
				this.oncomplete(event as MouseEvent);
		}

		// Getters & setters as3
		/**
		 * To know if the map is dragging
		 */
		public function get dragging():Boolean
		{
			return this._dragging;
		}
		public function set dragging(dragging:Boolean):void
		{
			this._dragging=dragging;
		}
		/**
		 * Start's callback this function is call when the drag starts
		 */
		public function set onstart(onstart:Function):void
		{
			this._onStart=onstart;
		}
		public function get onstart():Function
		{
			return this._onStart;
		}
		/**
		 * Stop's callback this function is call when the drag ends
		 */
		public function set oncomplete(oncomplete:Function):void
		{
			this._oncomplete=oncomplete;
		}
		public function get oncomplete():Function
		{
			return this._oncomplete;
		}

		/**
		 * This function is used to recenter map after dragging
		 */
		private function done(xy:Pixel):void {
			if (this.dragging) {
				this.panMap(xy);
				this._dragging = false;
			}
		}
		private function panMap(xy:Pixel):void {
			this._dragging = true;
			var oldCenter:LonLat = this.map.center;
			var deltaX:Number = this._start.x - xy.x;
			var deltaY:Number = this._start.y - xy.y;
			var newPosition:LonLat = new LonLat(this._startCenter.lon + deltaX * this.map.resolution , this._startCenter.lat - deltaY * this.map.resolution);
			// If the new position equals the old center, stop here
			if (newPosition.equals(oldCenter)) {
				Trace.info("DragHandler.panMap INFO: new center = old center, nothing to do");
				this.map.dispatchEvent(new MapEvent(MapEvent.MOVE_END, this.map));
				return;
			}
			// Try to set the new position as the center of the map
			this.map.center = newPosition;
			// If the new position is invalid (see Map.setCenter for the
			// conditions), the center of the map is always the old one but the
			// bitmap that represents the map is centered to the new position.
			// We have to reset the bitmap position to the right center.
			if (this.map.center.equals(oldCenter)) {
				Trace.info("DragHandler.panMap INFO: invalid new center submitted, the bitmap of the map is reset");
				this.map.resetCenterLayerContainer();
				this.map.dispatchEvent(new MapEvent(MapEvent.MOVE_END, this.map));
			}
		}
	}
}

