package org.openscales.core.feature
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Symbolizer;

	/**
	 * Feature used to draw a LineString geometry on FeatureLayer
	 */
	public class LineStringFeature extends VectorFeature
	{
		public function LineStringFeature(geom:LineString=null, data:Object=null, style:Style=null)
		{
			super(geom, data, style);
		}

		public function get lineString():LineString {
			return this.geometry as LineString;
		}

		override protected function executeDrawing(symbolizer:Symbolizer):void {
			
			// Regardless to the style, a LineString is never filled
			this.graphics.endFill();
			
			// Variable declaration before for loop to improve performances
			var p:Pixel = null;
			
			for (var i:int = 0; i < this.lineString.componentsLength; i++) {
				p = this.getLayerPxFromPoint(this.lineString.componentByIndex(i) as Point);
				if (i==0) {
					this.graphics.moveTo(p.x, p.y);
				} else {
					this.graphics.lineTo(p.x, p.y); 
				}
			} 
		}		
	}
}

