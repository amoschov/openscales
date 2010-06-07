package org.openscales.core.filter {
	import org.openscales.core.Trace;
	import org.openscales.core.feature.Feature;
	import org.openscales.geometry.Geometry;
	import org.openscales.proj4as.ProjProjection;

	public class ContainsFilter extends IntersectsFilter
	{
		public function ContainsFilter(geom:Geometry, srsCode:String/*=Layer.DEFAULT_SRS_CODE*/) {
			super(geom, srsCode);
		}
		
		override public function matches(feature:Feature):Boolean {
			if (super.matches(feature)) {
				// the two geometries intersect, so we have to test the inclusion
				return this.geometry.contains(feature.geometry, true);
			} else {
				return false;
			}
		}
		
	}
}