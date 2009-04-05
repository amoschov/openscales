package org.openscales.commons.geometry
{
	public class Curve extends MultiPoint
	{
		
		private var componentTypes:Array = ["org.openscales.commons.geometry::Point"];
		
		public function Curve(points:Object):void {
			super(points);
		}
		
		override public function getLength():Number {
			var length:Number = 0.0;
	        if ( this.components && (this.components.length > 1)) {
	            for(var i:int=1; i < this.components.length; i++) {
	                length += this.components[i-1].distanceTo(this.components[i]);
	            }
	        }
	        return length;
		}
		
		override public function getComponentTypes():Array {
			return componentTypes;
		}
	}
}