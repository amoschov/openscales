package org.openscales.core.feature
{
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;

	/**
	 * Feature used to draw a Polygon geometry on FeatureLayer
	 */
	public class PolygonFeature extends VectorFeature
	{
		public function PolygonFeature(geom:Polygon=null, data:Object=null, style:Style=null)
		{
			super(geom, data, style);
		}

		public function get polygon():Polygon {
			return this.geometry as Polygon;
		}

		override public function draw():void {
			super.draw();
			
			// Variable declaration before for loop to improve performances
			var p:Pixel = null;
			var linearRing:LinearRing = null;
			var j:int = 0;
			
			for (var i:int = 0; i < this.polygon.componentsLength; i++) {
				linearRing = (this.polygon.componentByIndex(i) as LinearRing);
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

