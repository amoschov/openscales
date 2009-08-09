package org.openscales.core.feature
{
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.LineString;

	/**
	 * Feature used to draw a LineString geometry on FeatureLayer
	 */
	public class LineStringFeature extends VectorFeature
	{
		public function LineStringFeature(geometry:Geometry=null, data:Object=null, style:Style=null)
		{
			super(geometry, data, style);
		}

		public function get lineString():LineString {
			return this.geometry as LineString;
		}

		override public function draw():void {
			super.draw();
			for (var i:int = 0; i < this.lineString.components.length; i++) {
				var point:Point = this.lineString.components[i];
				var x:Number = (point.x / this.layer.resolution + this.left);
				var y:Number = (this.top - point.y / this.layer.resolution);
				if (i==0) {
					this.graphics.moveTo(x, y);
				} else {
					this.graphics.lineTo(x, y); 
				}
			} 
		}		
	}
}

