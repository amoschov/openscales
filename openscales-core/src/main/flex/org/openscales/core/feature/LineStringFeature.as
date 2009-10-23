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
			var p:Point = null;
			var x:Number; 
            var y:Number;
            var resolution:Number = this.layer.map.resolution 
            var dX:int = -int(this.layer.map.layerContainer.x) + this.left; 
            var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			
			for (var i:int = 0; i < this.lineString.componentsLength; i++) {
				p = this.lineString.componentByIndex(i) as Point;
				x = dX + p.x / resolution; 
                y = dY - p.y / resolution;
                 
				if (i==0) {
					this.graphics.moveTo(x, y);
				} else {
					this.graphics.lineTo(x, y); 
				}
			} 
		}		
	}
}

