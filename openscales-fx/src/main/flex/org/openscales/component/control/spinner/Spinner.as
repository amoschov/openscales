package org.openscales.component.control.spinner {
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.basetypes.Pixel;
	import org.openscales.core.control.Control;
	import org.openscales.core.events.MapEvent;
	
	public class Spinner extends Control {		
		private var _timer:Timer;
		private var _slices:int;
		private var _radius:int;
		private var _rotationspeed:int;
		private var _color:uint;

		public function Spinner(slices:int = 12, radius:int = 6, rotationspeed:int = 65, color:uint = 0x666666, position:Pixel=null) {
			super(position);
			this._slices = slices;
			this._radius = radius;
			this._rotationspeed = rotationspeed;
			this._color = color;	
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_timer = new Timer(rotationspeed);
		}
		
		private function onAddedToStage(event:Event):void {			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_timer = new Timer(_rotationspeed);
			_timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			this.visible = false;
			draw();		
		}
		
		private function onRemovedFromStage(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
		}
		
		public function start():void {			
			
			// timer could be null when the spinner (or the map component as a whole) has previously been removed from the stage
			if(_timer != null)
			{
				_timer.reset();
				_timer.start();
				this.visible = true;
			}
		}
		
		public function stop():void 	{
			
			if(_timer != null)
			{
				_timer.stop();
				this.visible = false;
			}
		}
		
		private function onTimer(event:TimerEvent):void	{
			rotation = (rotation + (360 / _slices)) % 360;
		}
		
		override public function draw():void {
			
			// reset before drawing, or the child slices will just be added on top of the others 
			super.draw();
			
			var i:int = _slices;
			var degrees:int = 360 / _slices;
			while (i--)	{
				var slice:Shape = getSlice();
				slice.alpha = Math.max(0.07, 1 - (0.1 * i));
				var radianAngle:Number = (degrees * i) * Math.PI / 180;
				slice.rotation = -degrees * i;
				slice.x = Math.sin(radianAngle) * _radius;
				slice.y = Math.cos(radianAngle) * _radius;
				addChild(slice);
			}
		}
		
		private function getSlice():Shape {
			var slice:Shape = new Shape();
			slice.graphics.beginFill(this._color);
			slice.graphics.drawRoundRect(-1, 0, 4, 8, 12, 12);
			slice.graphics.endFill();
			return slice;
		}
								
		override public function set map(value:Map):void{
			super.map = value;
			
			this.map.addEventListener(MapEvent.LOAD_START,mapEventHandler);
			this.map.addEventListener(MapEvent.LOAD_END,mapEventHandler);
			
			// check if map is already loading.
			if (!this.map.loadComplete)			 
				this.start();
		}
		
		private function mapEventHandler(event:MapEvent):void
		{
			switch (event.type) 	{
				case MapEvent.LOAD_START:
					this.start();
				break;
				case MapEvent.LOAD_END:
				this.visible = false;
					this.stop();
				break;
			}
		}
	}
}