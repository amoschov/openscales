package org.openscales.core.feature
{
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Geometry;
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
				var p:Pixel = this.getLayerPxFromPoint(points.components[i]);
				this.graphics.drawCircle(p.x, p.y, this.style.pointRadius);
			}

		}		
	}
}

