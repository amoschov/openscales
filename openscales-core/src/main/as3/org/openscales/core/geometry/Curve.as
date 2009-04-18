package org.openscales.core.geometry
{
	public class Curve extends MultiPoint
	{
			
		public function Curve(points:Object):void {
			this.componentTypes = ["org.openscales.core.geometry::Point"];
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