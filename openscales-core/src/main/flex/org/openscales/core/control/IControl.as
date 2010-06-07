package org.openscales.core.control {

	import org.openscales.core.Map;
	import org.openscales.basetypes.Pixel;

	/**
	 * Controls affect the display or behavior of the map.
	 * They allow everything from panning and zooming to displaying a scale indicator.
	 */
	public interface IControl{

		function get map():Map;

		function set map(value:Map):void;

		function get active():Boolean;

		function set active(value:Boolean):void;

		function draw():void;

		function destroy():void;

		function set position(px:Pixel):void;

		function get position():Pixel;

		function get x():Number;

		function set x(value:Number):void;

		function get y():Number;

		function set y(value:Number):void;
	}
}

