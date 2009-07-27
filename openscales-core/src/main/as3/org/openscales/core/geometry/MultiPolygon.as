package org.openscales.core.geometry
{
	import org.openscales.proj4as.ProjProjection;
		
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
		
		public function addPolygon(polygon:Polygon, index:Number=NaN):void {
	        this.addComponent(polygon, index);
	    }
	    
		public function removePolygon(polygon:Polygon):void {
	        this.removeComponent(polygon);
	    }
	    
	    /**
		 * Method to convert the multipolygon (x/y) from a projection system to an other.
		 * 
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		override public function transform(source:ProjProjection, dest:ProjProjection):void {
			if (this.components.length > 0) {
				for each (var p:Polygon in this.components) {
					p.transform(source, dest);
				}
			}
		}
		
	}
}