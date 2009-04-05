package org.openscales.commons.geometry
{
	public class Polygon extends Collection
	{
		
		private var componentTypes:Array = ["org.openscales.commons.geometry::LinearRing"];
		
		public function Polygon(components:Object = null):void {
			super(components);
		}
		
		override public function getArea():Number {
			var area:Number = 0.0;
	        if ( this.components && (this.components.length > 0)) {
	            area += Math.abs(this.components[0].getArea());
	            for (var i:int = 1; i < this.components.length; i++) {
	                area -= Math.abs(this.components[i].getArea());
	            }
	        }
	        return area;
		}
		
		override public function getComponentTypes():Array {
			return componentTypes;
		}
		
	}
}