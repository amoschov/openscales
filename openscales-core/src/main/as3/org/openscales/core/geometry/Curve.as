package org.openscales.core.geometry
{
	/**
	 * A Curve is a MultiPoint, whose points are assumed to be connected. 
	 * 
	 * To this end, we provide a length getter, which iterates through the points, summing the distances between them.
	 */
	public class Curve extends MultiPoint
	{

		public function Curve(points:Array) {
			this.componentTypes = ["org.openscales.core.geometry::Curve"];
			super(points);
		}

		override public function get length():Number {
			var length:Number = 0.0;
			if ( this.components && (this.components.length > 1)) {
				for(var i:int=1; i < this.components.length; i++) {
					length += this.components[i-1].distanceTo(this.components[i]);
				}
			}
			return length;
		}

	}
}

