package org.openscales.component.control.spinner {
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.control.Control;
	import org.openscales.core.events.MapEvent;
	
	public class Spinner extends Control {		
		private var timer:Timer;
		private var slices:int;
		private var radius:int;
		private var rotationspeed:int;

		public function Spinner(slices:int = 12, radius:int = 6, rotationspeed:int = 65, position:Pixel=null) {
			super(position);
			this.slices = slices;
			this.radius = radius;
			this.rotationspeed = rotationspeed;	
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			timer = new Timer(rotationspeed);
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			this.visible = false;
			draw();		
		}
		
		private function onRemovedFromStage(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			timer.reset();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
		}
		
		public function start():void {			
			timer.reset();
			timer.start();
			this.visible = true;
		}
		
		public function stop():void 	{
			timer.stop();
			this.visible = false;
		}
		
		private function onTimer(event:TimerEvent):void	{
			rotation = (rotation + (360 / slices)) % 360;
		}
		
		override public function draw():void {
			var i:int = slices;
			var degrees:int = 360 / slices;
			while (i--)	{
				var slice:Shape = getSlice();
				slice.alpha = Math.max(0.2, 1 - (0.1 * i));
				var radianAngle:Number = (degrees * i) * Math.PI / 180;
				slice.rotation = -degrees * i;
				slice.x = Math.sin(radianAngle) * radius;
				slice.y = Math.cos(radianAngle) * radius;
				addChild(slice);
			}
		}
		
		private function getSlice():Shape {
			var slice:Shape = new Shape();
			slice.graphics.beginFill(0x666666);
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