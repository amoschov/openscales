package org.openscales.core.geometry
{	
	public class LinearRing extends LineString
	{
		
		public function LinearRing(points:Array = null) {
			this.componentTypes = ["org.openscales.core.geometry::Point"];
			super(points);
		}
		
		override public function addComponent(point:Object, index:Number=NaN):Boolean {
			var added:Boolean = false;
	        	
			var lastPoint:Point = this.components[this.components.length-1];
	        if(!isNaN(index) || !point.equals(lastPoint)) {
	            added = super.addComponent(point, index);
	        }

	        return added;
		}
		
	}
}