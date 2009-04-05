package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.commons.Util;
	import org.openscales.commons.basetypes.Pixel;
	import org.openscales.core.control.Control;
	import org.openscales.core.feature.Style;
	
	/**
	 * Base class to construct a higher-level handler for event sequences.  All
	 *     handlers have activate and deactivate methods.  In addition, they have
	 *     methods named like browser events.  When a handler is activated, any
	 *     additional methods named like a browser event is registered as a
	 *     listener for the corresponding event.  When a handler is deactivated,
	 *     those same methods are unregistered as event listeners.
	 *
	 * Handlers also typically have a callbacks function variables with.  The controls that 
	 *     wrap handlers define the methods that correspond to these abstract events 
	 *     so instead of listening for individual mouse events, they only listen 
	 *     for the abstract events defined by the handler.
	 * 
	 * Callbacks are identified by asDocs comments, taht sepcified also the signature 
	 * 		of the expected function.
	 *     
	 * Handlers are created by controls, which ultimately have the responsibility
	 *     of making changes to the the state of the application.  Handlers
	 *     themselves may make temporary changes, but in general are expected to
	 *     return the application in the same state that they found it.
	 */
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
		public var style:Style = null;
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