package org.openscales.core.feature
{
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;

	/**
	 * Feature used to draw a Point geometry on FeatureLayer 
	 */
	public class PointFeature extends VectorFeature
	{
		public function PointFeature(geometry:Geometry=null, data:Object=null, style:Style=null)
		{
			super(geometry, data, style);
		}
		
		public function get point():Point {
			return this.geometry as Point;
		}
		
		override public function draw():void {
			super.draw();
	        var x:Number = (point.x / this.layer.resolution + this.left);
	        var y:Number = (this.top - point.y / this.layer.resolution);
            this.graphics.drawCircle(x, y, this.style.pointRadius);
		}		
	}
}