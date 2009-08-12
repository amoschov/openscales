package org.openscales.core.feature
{
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;

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
			
			// Regardless to the style, a LineString is never filled
			this.graphics.endFill();
			
			for (var i:int = 0; i < this.lineString.components.length; i++) {
				var p:Pixel = this.getLayerPxFromPoint(this.lineString.components[i]);
				if (i==0) {
					this.graphics.moveTo(p.x, p.y);
				} else {
					this.graphics.lineTo(p.x, p.y); 
				}
			} 
		}		
	}
}

