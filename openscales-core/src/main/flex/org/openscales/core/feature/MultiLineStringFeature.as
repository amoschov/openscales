package org.openscales.core.feature
{
	import org.openscales.core.Trace;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Symbolizer;
	/**
	 * Feature used to draw a MultiLineString geometry on FeatureLayer
	 */
	public class MultiLineStringFeature extends Feature
	{
		public function MultiLineStringFeature(geom:MultiLineString=null, data:Object=null, style:Style=null,isEditable:Boolean=false) 
		{
			super(geom, data, style,isEditable);
		}

		public function get lineStrings():MultiLineString {
			return this.geometry as MultiLineString;
		}

		override protected function executeDrawing(symbolizer:Symbolizer):void {
			// Regardless to the style, a MultiLineString is never filled
			this.graphics.endFill();
			
			// Variable declaration before for loop to improve performances
			// Variable declaration before for loop to improve performances
			var p:Point = null;
			var x:Number; 
            var y:Number;
            var resolution:Number = this.layer.map.resolution 
            var dX:int = -int(this.layer.map.layerContainer.x) + this.left; 
            var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			var lineString:LineString = null;
			var j:int = 0;
			
			for (var i:int = 0; i < this.lineStrings.componentsLength; i++) {
				lineString = (this.lineStrings.componentByIndex(i) as LineString);
				for (j = 0; j < lineString.componentsLength; j++) {
					p = lineString.componentByIndex(j) as Point;
					x = dX + p.x / resolution; 
                	y = dY - p.y / resolution;
                	
					if (j==0) {
						this.graphics.moveTo(x, y);
					} else {
						this.graphics.lineTo(x, y); 
					}
				}
			}
		}
		/**
		 * To obtain feature clone 
		 * */
		override public function clone():Feature{
			var geometryClone:Geometry=this.geometry.clone();
			var MultilineStringFeatureClone:MultiLineStringFeature=new MultiLineStringFeature(geometryClone as MultiLineString,null,this.style,this.isEditable);
			return MultilineStringFeatureClone;
			
		}			
	}
}

