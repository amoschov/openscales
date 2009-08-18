package org.openscales.core.geometry
{	
	/**
 	 * Class: OpenLayers.Geometry.LineString
 	 * A LineString is a Curve which, once two points have been added to it, can 
 	 * never be less than two points long.
	 */

	public class LineString extends Curve
	{

		public function LineString(points:Array = null) {
			super(points);
		}

		override public function removeComponent(point:Geometry):void {
			if ( this.components && (this.components.length > 2)) {
				super.removeComponent(point);
			}
		}
		
		public function getPointAt(index:Number):Point {

			if(index >= 0 && index < this.components.length) {
				return this.components[index];
			}
			else {
				return null;
			}
		}

		public function getLastPoint():Point {
			return this.getPointAt(this.components.length - 1);
		}

	}
}

