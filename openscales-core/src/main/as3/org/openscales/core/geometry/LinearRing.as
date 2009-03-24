package org.openscales.core.geometry
{	
	public class LinearRing extends LineString
	{
		
		private var componentTypes:Array = ["org.openscales.core.geometry::Point"];
		
		public function LinearRing(points:Array = null):void {
			super(points);
		}
		
		override public function addComponent(point:Object, index:Number=NaN):Boolean {
			var added:Boolean = false;

	        var lastPoint:Point = this.components[this.components.length-1];
	        super.removeComponent([lastPoint]);
	
	        if(!isNaN(index) || !point.equals(lastPoint)) {
	            added = super.addComponent(point, index);
	        }

	        var firstPoint:Point = this.components[0];
	        super.addComponent([firstPoint.clone()]);
	
	        return added;
		}
		
		override public function getComponentTypes():Array {
			return componentTypes;
		}
		
	}
}