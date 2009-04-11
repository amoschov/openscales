package org.openscales.core.events{
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	public class DragNDropEvent extends MouseEvent {
		
		public static const DRAG_START:String="DragNDropEvent.dragStart";
		
		public static const DRAG:String="DragNDropEvent.drag";
		
		public static const DRAG_END:String="DragNDropEvent.dragEnd";
		
		private var _amountX:Number;
		
		private var _amountY:Number;
		
		public function DragNDropEvent(type:String, amountX:Number, amountY:Number, bubbles:Boolean=true, cancelable:Boolean=false, localX:Number=undefined, localY:Number=undefined, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
			this._amountX=amountX;
			this._amountY=amountY;
		}
		
		public function get amountX():Number{
			
			return this._amountX;
		}
		
		public function get amountY():Number{
			
			return this._amountY;
		}
		
	}
}