package org.openscales.core.feature
{
	import org.openscales.core.Trace;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Symbolizer;
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.LineString;
	import org.openscales.geometry.Point;

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
            var resolution:Number = this.layer.map.resolution 
            var dX:int = -int(this.layer.map.layerContainer.x) + this.left; 
            var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			var j:uint = (this.lineString.componentsLength*2);
			var coords:Vector.<Number> = this.lineString.getcomponentsClone();
			var commands:Vector.<int> = new Vector.<int>();
			for (var i:uint = 0; i < j; i+=2) {
				
				coords[i] = dX + coords[i] / resolution; 
				coords[i+1] = dY - coords[i+1] / resolution;
                 
				if (i==0) {
					commands.push(1);
				} else {
					commands.push(2); 
				}
			} 
			this.graphics.drawPath(commands, coords);
			
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

