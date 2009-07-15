package org.openscales.core.geometry
{
	import org.openscales.proj4as.ProjProjection;
	
	public class MultiPoint extends Collection
	{				
		public function MultiPoint(components:Object = null) {
			this.componentTypes = ["org.openscales.core.geometry::Point"];
			super(components);
		}
		
		
	    public function addPoint(point:Point, index:Number):void {
	        this.addComponent(point, index);
	    }
	    
		public function removePoint(point:Point):void {
	        this.removeComponent(point);
	    }
	    
	    /**
		 * Method to convert the multipoint (x/y) from a projection system to an other.
		 * 
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		override public function transform(source:ProjProjection, dest:ProjProjection):void {
			if (this.components.length > 0) {
				for each (var p:Point in this.components) {
					p.transform(source, dest);
				}
			}
		}
		
	}
}