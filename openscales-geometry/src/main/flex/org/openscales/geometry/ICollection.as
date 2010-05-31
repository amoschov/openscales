package org.openscales.geometry
{
	public interface ICollection
	{
		function addPoints(components:Vector.<Number>):void;
		function addComponents(components:Vector.<Geometry>):void;
		function addComponent(component:Geometry, index:Number = NaN):Boolean;
		function get componentsLength():int;
		function componentByIndex(i:int):Geometry;
		function replaceComponent(index:int, component:Geometry):Boolean;
		function removeComponents(components:Array):void;
		function removeComponent(component:Geometry):void;
	}
}