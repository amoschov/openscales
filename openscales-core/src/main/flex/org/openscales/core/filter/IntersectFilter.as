package org.openscales.core.filter {
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.layer.Layer;
	import org.openscales.proj4as.ProjProjection;

	public class IntersectFilter implements IFilter
	{
		private var _extent:Bounds;
		private var _projection:ProjProjection;
		
		public function IntersectFilter(extent:Bounds, srsCode:String/*=Layer.DEFAULT_SRS_CODE*/) {
			this._extent = extent;
			this._projection = new ProjProjection(srsCode);
		}
		
		public function matches(feature:VectorFeature):Boolean {
			var fBounds:Bounds = feature.geometry.bounds;
			fBounds.transform(feature.layer.map.baseLayer.projection, this._projection);
			return this._extent.intersectsBounds(fBounds);
		}
		
	}
}