package org.openscales.core.geometry
{
	public class MultiPolygon extends Collection
	{
				
		public function MultiPolygon(components:Object = null) {
			this.componentTypes = ["org.openscales.core.geometry::Polygon"];
			super(components);
		}
		
	}
}