package org.openscales.commons.geometry
{
	public class MultiPolygon extends Collection
	{
		
		private var componentTypes:Array = ["org.openscales.commons.geometry::Polygon"];
		
		public function MultiPolygon(components:Object = null):void {
			super(components);
		}
		
		override public function getComponentTypes():Array {
			return componentTypes;
		}
		
	}
}