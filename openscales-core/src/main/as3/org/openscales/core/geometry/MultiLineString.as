package org.openscales.core.geometry
{
	public class MultiLineString extends Collection
	{
		
		private var componentTypes:Array = ["org.openscales.core.geometry::LineString"];
		
		public function MultiLineString(components:Object = null):void {
			super(components);
		}
		
		override public function getComponentTypes():Array {
			return componentTypes;
		}
	}
}