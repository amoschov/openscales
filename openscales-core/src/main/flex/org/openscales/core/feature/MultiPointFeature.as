package org.openscales.core.feature
{
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Mark;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;

	/**
	 * Feature used to draw a MultiPoint geometry on FeatureLayer
	 */
	public class MultiPointFeature extends VectorFeature
	{
		public function MultiPointFeature(geom:MultiPoint=null, data:Object=null, style:Style=null)
		{
			super(geom, data, style);
		}

		public function get points():MultiPoint {
			return this.geometry as MultiPoint;
		}

		override protected function executeDrawing(symbolizer:Symbolizer):void {
			
			if(symbolizer is PointSymbolizer){
				
				var pointSymbolizer:PointSymbolizer = (symbolizer as PointSymbolizer);
				if(pointSymbolizer.graphic){
					if(pointSymbolizer.graphic is Mark){
						
						this.drawMark(pointSymbolizer.graphic as Mark);
					}
				}
			}
			
		}
		
		protected function drawMark(mark:Mark):void{
			trace("Drawing marks");
			this.configureGraphicsFill(mark.fill);
			this.configureGraphicsStroke(mark.stroke);
			var p:Pixel = null;
			for (var i:int=0; i<points.componentsLength; i++) {
				p = this.getLayerPxFromPoint(points.componentByIndex(i) as Point);
				switch(mark.wellKnownName){
					
					case Mark.WKN_SQUARE:{
						this.graphics.drawRect(p.x-(mark.size/2), p.y-(mark.size/2),mark.size,mark.size);
						break;
					}
					case Mark.WKN_CIRCLE:{
						this.graphics.drawCircle(p.x,p.y,mark.size);
						break;
					}
					case Mark.WKN_TRIANGLE:{
						this.graphics.moveTo(p.x,p.y-(mark.size/2));
						this.graphics.lineTo(p.x+mark.size/2,p.y+mark.size/2);
						this.graphics.lineTo(p.x-mark.size/2,p.y+mark.size/2);
						this.graphics.lineTo(p.x,p.y-(mark.size/2));
						break;
					}
					// TODO : Implement other well known names and take into account opacity, rotation of the mark
				}
			}
		}
			
	}
}

