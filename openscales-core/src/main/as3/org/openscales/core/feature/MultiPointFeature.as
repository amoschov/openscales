package org.openscales.core.feature
{
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.MultiPoint;

	/**
	 * Feature used to draw a MultiPoint geometry on FeatureLayer 
	 */
	public class MultiPointFeature extends VectorFeature
	{
		public function MultiPointFeature(geometry:Geometry=null, data:Object=null, style:Style=null)
		{
			super(geometry, data, style);
		}
		
		public function get points():MultiPoint {
			return this.geometry as MultiPoint;
		}
		
		override public function draw():void {
			super.draw();
	        for (var i:int = 0; i < points.components.length; i++) {
	        	var x:Number = (points.components[i].x / this.layer.resolution + this.left);
	        	var y:Number = (this.top - points.components[i].y / this.layer.resolution);
            	this.graphics.drawCircle(x, y, this.style.pointRadius);
	        }
	        
		}		
	}
}