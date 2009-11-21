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
				// the two geometries intersect, so we have to test the inclusion
Trace.debug("ContainsFilter.matches: => "+true);//this.geometry.containsFeature(feature));
				return true;//this.geometry.containsFeature(feature);
			} else {
Trace.debug("ContainsFilter.matches: false from IntersectsFilter");
				return false;
			}
		}
		
	}
}