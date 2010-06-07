package org.openscales.core.feature {
	import flash.display.DisplayObject;
	
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.LinearRing;
	import org.openscales.geometry.MultiPolygon;
	import org.openscales.geometry.Point;
	import org.openscales.geometry.Polygon;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;

	/**
	 * Feature used to draw a MultiPolygon geometry on FeatureLayer
	 */
	public class MultiPolygonFeature extends Feature {
		public function MultiPolygonFeature(geom:MultiPolygon=null, data:Object=null, style:Style=null, isEditable:Boolean=false) {
			super(geom, data, style, isEditable);
		}

		public function get polygons():MultiPolygon {
			return this.geometry as MultiPolygon;
		}

		override protected function executeDrawing(symbolizer:Symbolizer):void {

			if (symbolizer is PointSymbolizer) {

				this.renderPointSymbolizer(symbolizer as PointSymbolizer);
			} else {
				// Variable declaration before for loop to improve performances 
				var polygon:Polygon = null;
				var linearRing:LinearRing = null;
				var p:Point = null;
				var i:int;
				var j:int;
				var k:int;
				var l:int;
				var m:int;
				var n:int= this.polygons.componentsLength;
				var count:int = 0;
				var countFeature:int = 0;
				var resolution:Number = this.layer.map.resolution
				var dX:int = -int(this.layer.map.layerContainer.x) + this.left;
				var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
				var x:Number;
				var y:Number;
				var coords:Vector.<Number>;
				var commands:Vector.<int> = new Vector.<int>();
				for (m = 0; m < n; ++m) {
					polygon = (this.polygons.componentByIndex(m) as Polygon);
					k= polygon.componentsLength;
					for (i = 0; i < k; ++i) {
						linearRing = (polygon.componentByIndex(i) as LinearRing);
						l = linearRing.componentsLength*2;
						coords =linearRing.getcomponentsClone();
						commands= new Vector.<int>(linearRing.componentsLength);
						for (j = 0; j < l; j+=2){
							
							coords[j] = dX + coords[j] / resolution; 
							coords[j+1] = dY - coords[j+1] / resolution;
							
							if (j==0) {
								commands.push(1);
							} else {
								commands.push(2); 
							}
						}
						// Draw the last line of the polygon, as Flash won't render it if there is no fill for the polygon
						if (linearRing.componentsLength > 0) {
							coords.push(coords[0]); 
							coords.push(coords[1]);
							commands.push(2);
						}
						this.graphics.drawPath(commands, coords);
					}
				}
			}
		}

		protected function renderPointSymbolizer(symbolizer:PointSymbolizer):void {

			var x:Number;
			var y:Number;
			var resolution:Number = this.layer.map.resolution
			var dX:int = -int(this.layer.map.layerContainer.x) + this.left;
			var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			x = dX + this.geometry.bounds.centerPixel.x / resolution;
			y = dY - this.geometry.bounds.centerPixel.y / resolution;

			if (symbolizer.graphic) {

				var render:DisplayObject = symbolizer.graphic.getDisplayObject(this);
				render.x += x;
				render.y += y;
				this.addChild(render);
			}
		}

		/**
		 * To obtain feature clone
		 * */
		override public function clone():Feature {
			var geometryClone:Geometry = this.geometry.clone();
			var MultiPolygonFeatureClone:MultiPolygonFeature = new MultiPolygonFeature(geometryClone as MultiPolygon, null, this.style, this.isEditable);
			return MultiPolygonFeatureClone;
		}

	}
}
