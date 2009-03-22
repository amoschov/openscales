package org.openscales.core
{
	import flash.utils.Timer;
	import flash.events.MouseEvent;

	public class TimerOL extends Timer
	{
		
		public var mouseevent:MouseEvent;
		
		public function TimerOL(delay:Number, repeatCount:int = 0.0):void {
			super(delay, repeatCount);
		}
		
	}
}