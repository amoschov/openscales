package org.openscales.core.feature
{
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Mark;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;

	/**
	 * Feature used to draw a Point geometry on FeatureLayer
	 */
	public class PointFeature extends VectorFeature
	{
		/**
		 * To know if if the point is a temporary vertice
		 * */
		private var _isTmpVertice:Boolean=false;
		
		public function PointFeature(geom:Point=null, data:Object=null, style:Style=null,isTmpVertice:Boolean=false)
		{
			super(geom, data, style);
			if (geom!=null) {
				this.lonlat = new LonLat(this.point.x,this.point.y);
			}
			this._isTmpVertice=isTmpVertice;
		}

		public function get point():Point {
			return this.geometry as Point;
		}
		
		override protected function executeDrawing(symbolizer:Symbolizer):void {
			var p:Pixel = this.getLayerPxFromPoint(point);
			
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
			
			trace("Drawing mark");
			this.configureGraphicsFill(mark.fill);
			this.configureGraphicsStroke(mark.stroke);
			var p:Pixel = this.getLayerPxFromPoint(point);
			switch(mark.wellKnownName){
				
				case Mark.WKN_SQUARE:{
					this.graphics.drawRect(p.x-(mark.size/2), p.y-(mark.size/2),mark.size,mark.size);
					break;
				}
				case Mark.WKN_CIRCLE:{
					this.graphics.drawCircle(p.x,p.y,mark.size/2);
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
		
		public function get isTmpVertice():Boolean{
			return this._isTmpVertice;
		}	
	}
}

