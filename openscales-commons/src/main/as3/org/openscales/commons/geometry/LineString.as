package org.openscales.commons.geometry
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
				
	}
}