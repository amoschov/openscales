package org.openscales.core.filter {
	import org.openscales.core.Trace;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.proj4as.ProjProjection;

	public class IntersectsFilter implements IFilter
	{
		private var _geom:Geometry;
		private var _projection:ProjProjection;
		
		public function IntersectsFilter(geom:Geometry, srsCode:String/*=Layer.DEFAULT_SRS_CODE*/) {
			this._geom = geom;
			this._projection = new ProjProjection(srsCode);
		}
		
		public function matches(feature:VectorFeature):Boolean {
			if ((this.geometry==null) || (this.projection==null) || (feature==null)) {
				return false;
			}
			var fgeom:Geometry = feature.geometry;
			fgeom.transform(feature.layer.map.baseLayer.projection, this.projection);
Trace.debug("IntersectsFilter.matches: "+this.geometry.toShortString()+" ; "+fgeom.bounds.toString()+" => "+this.geometry.intersects(fgeom));
			return this.geometry.intersects(fgeom);
		}
		
		/**
		 * Getter and setter of the geometry
		 */
		public function get geometry():Geometry {
			return this._geom;
		}
		public function set geometry(value:Geometry):void {
			this._geom = value;
		}
		
		/**
		 * Getter and setter of the projection
		 */
		public function get projection():ProjProjection {
			return this._projection;
		}
		public function set projection(value:ProjProjection):void {
			this._projection = value;
		}
		
	}
}