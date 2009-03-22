package org.openscales.core.geometry
{
	public class MultiPolygon extends Collection
	{
		
		private var componentTypes:Array = ["org.openscales.core.geometry::Polygon"];
		
		public function MultiPolygon(components:Object = null):void {
			super(components);
		}
		
		override public function getComponentTypes():Array {
			return componentTypes;
		}
		
	}
}