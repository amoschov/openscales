package org.openscales.core.feature {
	import flash.display.DisplayObject;

	import org.openscales.core.Trace;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.Point;
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
			if (symbolizer is PointSymbolizer) {
				var pointSymbolizer:PointSymbolizer = (symbolizer as PointSymbolizer);
				if (pointSymbolizer.graphic) {

					var render:DisplayObject = pointSymbolizer.graphic.getDisplayObject(this);
					render.x += x;
					render.y += y;

					this.addChild(render);
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

