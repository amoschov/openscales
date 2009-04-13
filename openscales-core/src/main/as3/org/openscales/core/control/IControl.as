package org.openscales.core.control {
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	
	public interface IControl{
		
		function get map():Map;
		
		function set map(value:Map):void;
		
		function get active():Boolean;
		
		function set active(value:Boolean):void;
		
		function draw():void;
		
		function set position(px:Pixel):void;
		
		function get position():Pixel;
		
		function get x():Number;
		
		function set x(value:Number):void;
		
		function get y():Number;
		
		function set y(value:Number):void;
	}
}