package org.openscales.core.geometry
{
	public class Polygon extends Collection
	{
		
		public function Polygon(components:Object = null):void {
			this.componentTypes = ["org.openscales.core.geometry::LinearRing"];
			super(components);
		}
		
		override public function get area():Number {
			var area:Number = 0.0;
	        if ( this.components && (this.components.length > 0)) {
	            area += Math.abs(this.components[0].getArea());
	            for (var i:int = 1; i < this.components.length; i++) {
	                area -= Math.abs(this.components[i].getArea());
	            }
	        }
	        return area;
		}
		
	}
}