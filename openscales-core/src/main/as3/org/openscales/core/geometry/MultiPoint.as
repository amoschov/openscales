package org.openscales.core.geometry
{
	public class MultiPoint extends Collection
	{
		
		private var componentTypes:Array = ["org.openscales.core.geometry::Point"];
		
		public function MultiPoint(components:Object = null):void {
			super(components);
		}
		
		
	    public function addPoint(point:Point, index:Number):void {
	        this.addComponent(point, index);
	    }
	    
		public function removePoint(point:Point):void {
	        this.removeComponent(point);
	    }
		
		override public function getComponentTypes():Array {
			return componentTypes;
		}
	}
}