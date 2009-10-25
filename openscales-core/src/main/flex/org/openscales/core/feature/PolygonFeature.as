package org.openscales.core.feature
{
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Symbolizer;
	/**
	 * Feature used to draw a Polygon geometry on FeatureLayer
	 */
	public class PolygonFeature extends VectorFeature
	{
		public function PolygonFeature(geom:Polygon=null, data:Object=null, style:Style=null,isEditable:Boolean=false,isEditionFeature:Boolean=false,editionFeatureParentGeometry:Collection=null)
		{
			super(geom, data, style,isEditable,isEditionFeature,editionFeatureParentGeometry);
		}

		public function get polygon():Polygon {
			return this.geometry as Polygon;
		}

		override protected function executeDrawing(symbolizer:Symbolizer):void {

			trace("Drawing polygon");
			// Variable declaration before for loop to improve performances
			// Variable declaration before for loop to improve performances
			var p:Point = null;
			var x:Number; 
            var y:Number;
            var resolution:Number = this.layer.map.resolution 
            var dX:int = -int(this.layer.map.layerContainer.x) + this.left; 
            var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			var linearRing:LinearRing = null;
			var j:int = 0;
			
			for (var i:int = 0; i < this.polygon.componentsLength; i++) {
				linearRing = (this.polygon.componentByIndex(i) as LinearRing);
				
				// Draw the n-1 line of the polygon
				for (j=0; j<linearRing.componentsLength; j++) {
					p = linearRing.componentByIndex(j) as Point;
					x = dX + p.x / resolution; 
                	y = dY - p.y / resolution;
					if (j==0) {
						this.graphics.moveTo(x, y);
					} else {
						this.graphics.lineTo(x, y);
					}
				}
				
				// Draw the last line of the polygon, as Flash won't render it if there is no fill for the polygon
				if(linearRing.componentsLength > 0){
					p = linearRing.componentByIndex(0) as Point;
					x = dX + p.x / resolution; 
                    y = dY - p.y / resolution;
					this.graphics.lineTo(x,y);
				}
			}
			
			trace("End of polygon drawing");
		}
		/**
		 * To obtain feature clone 
		 * */
		override public function clone():Feature{
			var geometryClone:Geometry=this.geometry.clone();
			var PolygonFeatureClone:PolygonFeature=new PolygonFeature(geometryClone as Polygon,null,this.style,this.isEditable,this.isEditionFeature,this.editionFeatureParentGeometry);
			return PolygonFeatureClone;
			
		}	
	}
}

