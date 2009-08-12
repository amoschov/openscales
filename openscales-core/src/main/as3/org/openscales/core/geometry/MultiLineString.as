package org.openscales.core.geometry
{
	import org.openscales.proj4as.ProjProjection;

	/**
	 * A MultiLineString is a geometry with multiple LineString components.
	 */
	public class MultiLineString extends Collection
	{

		public function MultiLineString(components:Array = null) {
			this.componentTypes = ["org.openscales.core.geometry::LineString"];
			super(components);
		}

		/**
		 * AddLineSring permit to add a line in the MultiLineString.
		 * In order to not allow 2 lineString witch start at the same point, we make a test with the last component.
		 */
		public function addLineString(lineString:LineString, index:Number=NaN):void {
			this.addComponent(lineString, index);
		}

		public function removeLineString(lineString:LineString):void {
			this.removeComponent(lineString);
		}

		/**
		 * Method to convert the multilinestring (x/y) from a projection system to an other.
		 *
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		override public function transform(source:ProjProjection, dest:ProjProjection):void {
			if (this.components.length > 0) {
				for each (var lS:LineString in this.components) {
					lS.transform(source, dest);
				}
			}
		}

	}
}

