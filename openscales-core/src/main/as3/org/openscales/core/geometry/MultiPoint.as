package org.openscales.core.geometry
{
	public class MultiPoint extends Collection
	{
				
		public function MultiPoint(components:Object = null):void {
			this.componentTypes = ["org.openscales.core.geometry::Point"];
			super(components);
		}
		
		
	    public function addPoint(point:Point, index:Number):void {
	        this.addComponent(point, index);
	    }
	    
		public function removePoint(point:Point):void {
	        this.removeComponent(point);
	    }
		
	}
}