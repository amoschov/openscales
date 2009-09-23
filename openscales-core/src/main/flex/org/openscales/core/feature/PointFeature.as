package org.openscales.core.feature
{
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;

	/**
	 * Feature used to draw a Point geometry on FeatureLayer
	 */
	public class PointFeature extends VectorFeature
	{
		public function PointFeature(geom:Point=null, data:Object=null, style:Style=null)
		{
			super(geom, data, style);
			if (geom!=null) {
				this.lonlat = new LonLat(this.point.x,this.point.y);
			}
		}

		public function get point():Point {
			return this.geometry as Point;
		}

		override public function draw():void {
			super.draw();
			if(getQualifiedClassName(this)!="org.openscales.core.feature::Marker"){
			var p:Pixel = this.getLayerPxFromPoint(point);
			this.graphics.drawCircle(p.x, p.y, this.style.pointRadius);
			}
		}		
	}
}

