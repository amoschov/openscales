package org.openscales.core.feature
{
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.Point;

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
			
			// Variable declaration before for loop to improve performances
			var p:Pixel = null;
			for (var i:int=0; i<points.componentsLength; i++) {
				p = this.getLayerPxFromPoint(points.componentByIndex(i) as Point);
				this.graphics.drawCircle(p.x, p.y, this.style.pointRadius);
			}
		}
			
	}
}

