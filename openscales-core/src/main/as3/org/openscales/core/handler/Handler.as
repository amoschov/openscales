package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.control.Control;
	
	public class Handler
	{
		
		public static var MOD_NONE:int = 0;
		public static var MOD_SHIFT:int = 1;
		public static var MOD_CTRL:int = 2;
		public static var MOD_ALT:int = 4;
		
		public var control:Control = null;
		public var map:Map = null;
		public var keyMask:int;
		public var active:Boolean = false;
		public var style:Object = null;
		public var last:Pixel = null;
    	public var start:Pixel = null;
    	public var dragging:Boolean = false;
		
		public function Handler(control:Control=null, options:Object=null):void {
			Util.extend(this, options);
			this.control = control;
			if (control.map) {
				this.setMap(control.map);
			}
			
			Util.extend(this, options);
			
		}
		
		public function setMap(map:Map):void {
			this.map = map;
		}
		
		public function checkModifiers(evt:MouseEvent):Boolean {
			if(isNaN(this.keyMask)) {
	            return true;
	        }
	        var keyModifiers:int =
	            (evt.shiftKey ? Handler.MOD_SHIFT : 0) |
	            (evt.ctrlKey  ? Handler.MOD_CTRL  : 0) |
	            (evt.altKey   ? Handler.MOD_ALT   : 0);

	        return (keyModifiers == this.keyMask);
		}
		
		public function activate():void {

		}
		
		public function deactivate():void {

		}
		
		public function destroy():void {
			this.control = null;
			this.map = null;
		}
		
		
	}
}