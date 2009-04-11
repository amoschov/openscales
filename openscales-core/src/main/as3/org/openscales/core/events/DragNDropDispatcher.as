package org.openscales.core.events{
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	
	/**
	 * A class listening to mouse events (mouseUp, mouseDown, mouseMove, mouseOut)
	 * on a given IEventDispatcher target and making it dispatch DragNDropEvents
	 */
	public class DragNDropDispatcher{
		
		private var _target:IEventDispatcher;
		
		private var _abscissa:Number;
		
		private var _ordinate:Number;
		
		public function DragNDropDispatcher(target:IEventDispatcher = null){
			
			this.target=target;
		}
		
		public function get target():IEventDispatcher{
			
			return this._target;
		}
		
		public function set target(value:IEventDispatcher):void{
			
			this._target=value;
		}
		
		private function _registerListeners():void{
			
			this._target.addEventListener(MouseEvent.MOUSE_DOWN, this._mouseDownHandler);
		}
		
		private function _unregisterListeners():void{
			
			this._target.removeEventListener(MouseEvent.MOUSE_DOWN,this._mouseDownHandler);
		}
		
		private function _registerMovementListeners():void{
			
			this._target.addEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);
			this._target.addEventListener(MouseEvent.MOUSE_UP,this._mouseUpHandler);
			this._target.addEventListener(MouseEvent.MOUSE_OUT,this._mouseOutHandler);
		}
		
		private function _unregisterMovementListeners():void{
			
			this._target.removeEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);
			this._target.removeEventListener(MouseEvent.MOUSE_UP,this._mouseUpHandler);
			this._target.removeEventListener(MouseEvent.MOUSE_OUT,this._mouseOutHandler);
		}
		
		private function _mouseDownHandler(event:MouseEvent):void{
			
			// Registers listeners for movement handling
			this._registerMovementListeners();
			
			// Stores the position of the clic
			this._abscissa=event.stageX;
			this._ordinate=event.stageY;
		}
		
		private function _mouseMoveHandler(event:MouseEvent):void{
			
			//
		}
		
		private function _mouseUpHandler(event:MouseEvent):void{
			
			this._unregisterMovementListeners();
		}
		
		private function _mouseOutHandler(event:MouseEvent):void{
			
			this._unregisterMovementListeners();
		}
	}
}