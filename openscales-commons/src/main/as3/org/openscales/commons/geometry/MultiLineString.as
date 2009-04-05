package org.openscales.commons.geometry
{
	public class MultiLineString extends Collection
	{
		
		private var componentTypes:Array = ["org.openscales.commons.geometry::LineString"];
		
		public function MultiLineString(components:Object = null):void {
			super(components);
		}
		
		override public function getComponentTypes():Array {
			return componentTypes;
		}
	}
}