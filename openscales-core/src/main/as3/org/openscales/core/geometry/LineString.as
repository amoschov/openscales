package org.openscales.core.geometry
{	
	public class LineString extends Curve
	{
		
		public function LineString(points:Object = null):void {
			super(points);
		}
		
		override public function removeComponent(point:Object):void {
	        if ( this.components && (this.components.length > 2)) {
	            super.removeComponent(point);
	        }
		}
		
		public function getPointAt(index:Number):Point {
			
			if(index >= 0 && index < this.components.length) {
				return this.components[index];
			}
			else {
				return null;
			}
		}
		
		public function getLastPoint():Point {
			return this.getPointAt(this.components.length - 1);
		}
				
	}
}