package org.openscales.core.geometry
{
	public class MultiLineString extends Collection
	{
		
		public function MultiLineString(components:Object = null):void {
			this.componentTypes = ["org.openscalescore.geometry::LineString"];
			super(components);
		}
		
	}
}