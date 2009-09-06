package org.openscales.core.feature
{
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;

	/**
	 * Feature used to draw a MultiPolygon geometry on FeatureLayer
	 */
	public class MultiPolygonFeature extends VectorFeature
	{
		public function MultiPolygonFeature(geometry:MultiPolygon=null, data:Object=null, style:Style=null)
		{
			super(geometry, data, style);
		}

		public function get polygons():MultiPolygon {
			return this.geometry as MultiPolygon;
		}

		override public function draw():void {
			super.draw();
			
			// Variable declaration before for loop to improve performances
			var polygon:Polygon = null;
			var linearRing:LinearRing = null;
			var p:Pixel = null;
			var i:int = 0;
			var j:int = 0;
			
			for (var k:int = 0; k < this.polygons.componentsLength; k++) {
				polygon = (this.polygons.componentByIndex(k) as Polygon);
				for (i=0; i<polygon.componentsLength; i++) {
					linearRing = (polygon.componentByIndex(i) as LinearRing);
					for (j=0; j<linearRing.componentsLength; j++) {
						p = this.getLayerPxFromPoint(linearRing.componentByIndex(j) as Point);
						if (j==0) {
							this.graphics.moveTo(p.x, p.y);
						} else {
							this.graphics.lineTo(p.x, p.y);
						}
					}
				}
			}
		}		
	}
}

