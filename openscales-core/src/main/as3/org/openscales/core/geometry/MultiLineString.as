package org.openscales.core.geometry
{
	public class MultiLineString extends Collection
	{
		
		public function MultiLineString(components:Object = null):void {
			this.componentTypes = ["org.openscales.core.geometry::LineString"];
			super(components);
		}
		
	}
}