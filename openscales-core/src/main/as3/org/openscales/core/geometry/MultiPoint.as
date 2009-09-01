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
		
		public function addPoint(point:Point, index:Number=NaN):void {
			this.addComponent(point, index);
		}
		
		public function removePoint(point:Point):void {
			this.removeComponent(point);
		}
		
		override public function toShortString():String {
			var s:String = "(";
			for each (var p:Point in this.components) {
				s = s + p.toShortString();
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
			if (this.components.length > 0) {
				for each (var p:Point in this.components) {
					p.transform(source, dest);
				}
			}
		}
		
	}
}

