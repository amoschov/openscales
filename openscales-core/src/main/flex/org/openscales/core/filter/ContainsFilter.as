package org.openscales.core.filter {
	import org.openscales.core.Trace;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.proj4as.ProjProjection;

	public class ContainsFilter extends IntersectsFilter
	{
		public function ContainsFilter(geom:Geometry, srsCode:String/*=Layer.DEFAULT_SRS_CODE*/) {
			super(geom, srsCode);
		}
		
		override public function matches(feature:VectorFeature):Boolean {
			if (super.matches(feature)) {
				// Test the inclusion
				return true;//this.geometry.containsFeature(feature);
			} else {
				return false;
			}
			/*var fBounds:Bounds = feature.geometry.bounds;
			fBounds.transform(feature.layer.map.baseLayer.projection, this._projection);
			return this._extent.intersectsBounds(fBounds);*/
		}
		
	}
}