package org.openscales.commons.geometry
{	
	public class LinearRing extends LineString
	{
		
		private var componentTypes:Array = ["org.openscales.commons.geometry::Point"];
		
		public function LinearRing(points:Array = null):void {
			super(points);
		}
		
		override public function addComponent(point:Object, index:Number=NaN):Boolean {
			var added:Boolean = false;
	        	
			var lastPoint:Point = this.components[this.components.length-1];
	        if(!isNaN(index) || !point.equals(lastPoint)) {
	            added = super.addComponent(point, index);
	        }

	        return added;
		}
		
		override public function getComponentTypes():Array {
			return componentTypes;
		}
		
	}
}