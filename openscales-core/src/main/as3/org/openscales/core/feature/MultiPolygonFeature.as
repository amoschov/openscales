package org.openscales.core.feature
{
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.MultiPolygon;

	/**
	 * Feature used to draw a MultiPolygon geometry on FeatureLayer
	 */
	public class MultiPolygonFeature extends VectorFeature
	{
		public function MultiPolygonFeature(geometry:Geometry=null, data:Object=null, style:Style=null)
		{
			super(geometry, data, style);
		}

		public function get polygons():MultiPolygon {
			return this.geometry as MultiPolygon;
		}

		override public function draw():void {
			super.draw();
			for (var k:int = 0; k < this.polygons.components.length; k++) {
				var polygon:Polygon = this.polygons.components[k];
				for (var i:int = 0; i < polygon.components.length; i++) {
					var linearRing:LinearRing = polygon.components[i];
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
}

