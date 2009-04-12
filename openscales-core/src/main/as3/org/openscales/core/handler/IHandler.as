package org.openscales.core.handler {
	import org.openscales.core.Map;
	
	public interface IHandler{
		
		function get map():Map;
		
		function set map(value:Map):void;
		
		function get active():Boolean;
		
		function set active(value:Boolean):void;
	}
}