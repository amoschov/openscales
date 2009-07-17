package org.openscales.core.geometry
{
	/**
	 * Class to represent a multi line string.
	 * It's a collection of lins strings.
	 */
	public class MultiLineString extends Collection
	{
		
		public function MultiLineString(components:Object = null) {
			this.componentTypes = ["org.openscales.core.geometry::LineString"];
			super(components);
		}
		
	}
}