package org.openscales.core.feature
{
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.geometry.LinearRing;

	/**
	 * Feature used to draw a Polygon geometry on FeatureLayer
	 */
	public class PolygonFeature extends VectorFeature
	{
		public function PolygonFeature(geometry:Geometry=null, data:Object=null, style:Style=null)
		{
			super(geometry, data, style);
		}

		public function get polygon():Polygon {
			return this.geometry as Polygon;
		}

		override public function draw():void {
			super.draw();
			for (var i:int = 0; i < this.polygon.components.length; i++) {
				var linearRing:LinearRing = this.polygon.components[i];
				for (var j:int = 0; j < linearRing.components.length; j++) {
					var point:Point = linearRing.components[j];
					var x:Number = (point.x / this.layer.resolution + this.left);
					var y:Number = (this.top - point.y / this.layer.resolution);
					if (j==0) {
						this.graphics.moveTo(x, y);
					} else {
						this.graphics.lineTo(x, y);
					}
				}
			}
		}		
	}
}

