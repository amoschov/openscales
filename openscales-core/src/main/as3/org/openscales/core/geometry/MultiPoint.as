package org.openscales.core.geometry
{
	import org.openscales.proj4as.ProjProjection;

	/**
	 * MultiPoint is a collection of Points.
	 */
	public class MultiPoint extends Collection
	{
		public function MultiPoint(components:Array = null) {
			super(components);
			this.componentTypes = ["org.openscales.core.geometry::Point"];
		}
		
		/**
		 * Component of the specified index, casted to the Point type
		 */
// TODO: how to do that in AS3 ?
		/*override public function componentByIndex(i:int):Point {
			return (super.componentByIndex(i) as Point);
		}*/
		
		public function addPoint(point:Point, index:Number=NaN):void {
			this.addComponent(point, index);
		}
		
		public function removePoint(point:Point):void {
			this.removeComponent(point);
		}
		
		override public function toShortString():String {
			var s:String = "(";
			for(var i:int=0; i<this.componentsLength; i++) {
				s = s + this.componentByIndex(i).toShortString();
			}
			return s + ")";
		}
		
		/**
		 * Method to convert the multipoint (x/y) from a projection system to an other.
		 *
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		override public function transform(source:ProjProjection, dest:ProjProjection):void {
			for(var i:int=0; i<this.componentsLength; i++) {
				this.componentByIndex(i).transform(source, dest);
			}
		}
		
		/**
		 * Calculate the approximate area of this geometry (the projection and
		 * the geodesic are not managed).
		 */
		override public function get area():Number {
			return 0.0;
		}
		
	}
}

