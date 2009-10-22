package org.openscales.core.feature
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Symbolizer;

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

		override protected function executeDrawing(symbolizer:Symbolizer):void {

			trace("Drawing polygon");
			// Variable declaration before for loop to improve performances
			var p:Pixel = null;
			var linearRing:LinearRing = null;
			var j:int = 0;
			
			for (var i:int = 0; i < this.polygon.componentsLength; i++) {
				linearRing = (this.polygon.componentByIndex(i) as LinearRing);
				
				// Draw the n-1 line of the polygon
				for (j=0; j<linearRing.componentsLength; j++) {
					p = this.getLayerPxFromPoint(linearRing.componentByIndex(j) as Point);
					if (j==0) {
						this.graphics.moveTo(p.x, p.y);
					} else {
						this.graphics.lineTo(p.x, p.y);
					}
				}
				
				// Draw the last line of the polygon, as Flash won't render it if there is no fill for the polygon
				if(linearRing.componentsLength > 0){
					
					p = this.getLayerPxFromPoint(linearRing.componentByIndex(0) as Point);
					this.graphics.lineTo(p.x,p.y);
				}
			}
			
			trace("End of polygon drawing");
		}	
	}
}

