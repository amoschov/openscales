package org.openscales.core.feature
{
	import org.openscales.core.Trace;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Symbolizer;

	/**
	 * Feature used to draw a LineString geometry on FeatureLayer
	 */
	public class LineStringFeature extends Feature
	{
		public function LineStringFeature(geom:LineString=null, data:Object=null, style:Style=null,isEditable:Boolean=false) 
		{
			super(geom, data, style,isEditable);
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
			var j:uint = this.lineString.componentsLength;
			for (var i:uint = 0; i < j; ++i) {
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
		/**
		 * To obtain feature clone 
		 * */
		override public function clone():Feature{
			var geometryClone:Geometry=this.geometry.clone();
			var lineStringFeatureClone:LineStringFeature=new LineStringFeature(geometryClone as LineString,null,this.style,this.isEditable);
			return lineStringFeatureClone;
			
		}		
	}
}

