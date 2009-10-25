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
		
		/**
		 * Component of the specified index, casted to the Polygon type
		 */
// TODO: how to do that in AS3 ?
		/*override public function componentByIndex(i:int):Polygon {
			return (super.componentByIndex(i) as Polygon);
		}*/
		
		public function addPolygon(polygon:Polygon, index:Number=NaN):void {
			this.addComponent(polygon, index);
		}

		public function removePolygon(polygon:Polygon):void {
			this.removeComponent(polygon);
		}

		override public function toShortString():String {
			var s:String = "(";
			for (var i:int=0; i<this.componentsLength; i++) {
				s = s + this.componentByIndex(i).toShortString();
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
			for (var i:int=0; i<this.componentsLength; i++) {
				this.componentByIndex(i).transform(source, dest);
			}
		}
		/**
		 * To get this geometry clone
		 * */
		override public function clone():Geometry{
			var MultiPolygonClone:MultiPolygon=new MultiPolygon();
			var component:Array=this.getcomponentsClone();
			MultiPolygonClone.addComponents(component);
			return MultiPolygonClone;
		}
	}
}

