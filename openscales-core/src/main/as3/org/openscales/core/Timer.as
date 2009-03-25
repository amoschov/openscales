package org.openscales.core
{
	import flash.utils.Timer;
	import flash.events.MouseEvent;

	public class Timer extends flash.utils.Timer
	{
		
		public var mouseevent:MouseEvent;
		
		public function Timer(delay:Number, repeatCount:int = 0.0):void {
			super(delay, repeatCount);
		}
		
	}
}