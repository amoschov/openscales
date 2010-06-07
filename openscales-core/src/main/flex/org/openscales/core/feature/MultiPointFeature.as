package org.openscales.core.feature {
	import flash.display.DisplayObject;
	
	import org.openscales.core.Trace;
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.MultiPoint;
	import org.openscales.geometry.Point;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;

	/**
	 * Feature used to draw a MultiPoint geometry on FeatureLayer
	 */
	public class MultiPointFeature extends Feature {
		public function MultiPointFeature(geom:MultiPoint=null, data:Object=null, style:Style=null, isEditable:Boolean=false) {
			super(geom, data, style, isEditable);
		}

		public function get points():MultiPoint {
			return this.geometry as MultiPoint;
		}

		override protected function executeDrawing(symbolizer:Symbolizer):void {
			
			// Variable declaration before for loop to improve performances
			var p:Point = null;
			var x:Number; 
			var y:Number;
			var resolution:Number = this.layer.map.resolution 
			var dX:int = -int(this.layer.map.layerContainer.x) + this.left; 
			var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			
			var point:Point = null;
			var i:int;
			var j:int = this.points.componentsLength;
			for(i=0;i<j;++i){
			
				point = this.points.componentByIndex(i) as Point;
				
				if (symbolizer is PointSymbolizer) {
					
					x = dX + point.x / resolution;
					y = dY - point.y / resolution;
					this.graphics.drawRect(x, y, 5, 5);
					
					var pointSymbolizer:PointSymbolizer = (symbolizer as PointSymbolizer);
					if (pointSymbolizer.graphic) {
	
						var render:DisplayObject = pointSymbolizer.graphic.getDisplayObject(this);
						render.x += x;
						render.y += y;
	
						this.addChild(render);
					}
				}
			}

		}

		/**
		 * To obtain feature clone
		 * */
		override public function clone():Feature {
			var geometryClone:Geometry = this.geometry.clone();
			var MultiPointFeatureClone:MultiPointFeature = new MultiPointFeature(geometryClone as MultiPoint, null, this.style, this.isEditable);
			return MultiPointFeatureClone;

		}
	}
}

