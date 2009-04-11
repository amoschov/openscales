package org.openscales.core.control {
	import org.openscales.core.Map;
	
	public interface IControl{
		
		function get target():Map;
		
		function set target(value:Map):void;
		
		function get active():Boolean;
		
		function set active(value:Boolean):void;
	}
}