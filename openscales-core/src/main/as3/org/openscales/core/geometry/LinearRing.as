package org.openscales.core.geometry
{	
	/**
	 * A Linear Ring is a special LineString which is closed. 
	 * It closes itself automatically on every addPoint/removePoint by adding a copy of the first point as the last point.
	 * Also, as it is the first in the line family to close itself, an area getter is 
	 * defined to calculate the enclosed area of the linearRing
	 */
	public class LinearRing extends LineString
	{

		public function LinearRing(points:Array = null) {
			super(points);
		}

		override public function addComponent(point:Geometry, index:Number=NaN):Boolean {
			var added:Boolean = false;

			var lastPoint:Point = this.components[this.components.length-1];
			if(!isNaN(index) || !(point as Point).equals(lastPoint)) {
				added = super.addComponent(point, index);
			}

			return added;
		}

	}
}

