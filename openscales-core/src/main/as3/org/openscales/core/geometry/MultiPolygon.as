package org.openscales.core.geometry
{
	import org.openscales.proj4as.ProjProjection;

	/**
	 * MultiPolygon is a geometry with multiple Polygon components
	 */
	public class MultiPolygon extends Collection
	{

		public function MultiPolygon(components:Array = null) {
			super(components);
			this.componentTypes = ["org.openscales.core.geometry::Polygon"];
		}

		public function addPolygon(polygon:Polygon, index:Number=NaN):void {
			this.addComponent(polygon, index);
		}

		public function removePolygon(polygon:Polygon):void {
			this.removeComponent(polygon);
		}

		override public function toShortString():String {
			var s:String = "(";
			for each (var p:Polygon in this.components) {
				s = s + p.toShortString();
			}
			return s + ")";
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

