package org.openscales.core.geometry
{	
	/**
	 * Class to represent a multi polygon geometry.
	 * It's a collection of polygons.
	 */
	public class MultiPolygon extends Collection
	{
				
		public function MultiPolygon(components:Object = null) {
			this.componentTypes = ["org.openscales.core.geometry::Polygon"];
			super(components);
		}
		
	}
}