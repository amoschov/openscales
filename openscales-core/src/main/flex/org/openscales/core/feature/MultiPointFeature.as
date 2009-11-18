package org.openscales.core.feature {
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Mark;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;

	/**
	 * Feature used to draw a MultiPoint geometry on FeatureLayer
	 */
	public class MultiPointFeature extends VectorFeature {
		public function MultiPointFeature(geom:MultiPoint=null, data:Object=null, style:Style=null, isEditable:Boolean=false, isEditionFeature:Boolean=false, editionFeatureParentGeometry:Collection=null) {
			super(geom, data, style, isEditable, isEditionFeature);
		}

		public function get points():MultiPoint {
			return this.geometry as MultiPoint;
		}

		override protected function executeDrawing(symbolizer:Symbolizer):void {

			if (symbolizer is PointSymbolizer) {

				var pointSymbolizer:PointSymbolizer = (symbolizer as PointSymbolizer);
				if (pointSymbolizer.graphic) {
					if (pointSymbolizer.graphic is Mark) {

						this.drawMark(pointSymbolizer.graphic as Mark);
					}
				}
			}

		}

		protected function drawMark(mark:Mark):void {
			trace("Drawing marks");
			Rule.configureGraphicsFill(mark.fill, this);
			Rule.configureGraphicsStroke(mark.stroke, this);
			// Variable declaration before for loop to improve performances
			var p:Point = null;
			var x:Number;
			var y:Number;
			var resolution:Number = this.layer.map.resolution
			var dX:int = -int(this.layer.map.layerContainer.x) + this.left;
			var dY:int = -int(this.layer.map.layerContainer.y) + this.top;

			for (var i:int = 0; i < points.componentsLength; i++) {
				p = points.componentByIndex(i) as Point;
				x = dX + p.x / resolution;
				y = dY - p.y / resolution;

				switch (mark.wellKnownName) {

					case Mark.WKN_SQUARE:  {
						this.graphics.drawRect(x - (mark.size / 2), y - (mark.size / 2), mark.size, mark.size);
						break;
					}
					case Mark.WKN_CIRCLE:  {
						this.graphics.drawCircle(x, y, mark.size);
						break;
					}
					case Mark.WKN_TRIANGLE:  {
						this.graphics.moveTo(x, y - (mark.size / 2));
						this.graphics.lineTo(x + mark.size / 2, y + mark.size / 2);
						this.graphics.lineTo(x - mark.size / 2, y + mark.size / 2);
						this.graphics.lineTo(x, y - (mark.size / 2));
						break;
					}
					// TODO : Implement other well known names and take into account opacity, rotation of the mark
				}
			}
		}

		/**
		 * To obtain feature clone
		 * */
		override public function clone():Feature {
			var geometryClone:Geometry = this.geometry.clone();
			var MultiPointFeatureClone:MultiPointFeature = new MultiPointFeature(geometryClone as MultiPoint, null, this.style, this.isEditable, this.isEditionFeature);
			return MultiPointFeatureClone;

		}
	}
}

