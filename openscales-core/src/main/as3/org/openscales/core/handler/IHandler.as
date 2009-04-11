package org.openscales.core.handler {
	import org.openscales.core.Map;
	
	public interface IHandler{
		
		function get target():Map;
		
		function set target(value:Map):void;
		
		function get active():Boolean;
		
		function set active(value:Boolean):void;
	}
}