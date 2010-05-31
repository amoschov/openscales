package org.openscales.core.filter {
	import org.openscales.core.Trace;
	import org.openscales.core.feature.Feature;
	import org.openscales.geometry.Geometry;
	import org.openscales.proj4as.ProjProjection;

	public class IntersectsFilter implements IFilter
	{
		private var _geom:Geometry;
		private var _projection:ProjProjection;
		
		public function IntersectsFilter(geom:Geometry, srsCode:String/*=Layer.DEFAULT_SRS_CODE*/) {
			this._geom = geom;
			this._projection = new ProjProjection(srsCode);
		}
		
		public function matches(feature:Feature):Boolean {
			if ((this.geometry==null) || (this.projection==null) || (feature==null)) {
				return false;
			}
			if (this.projection.srsCode != feature.layer.map.baseLayer.projection.srsCode) {
				this._geom.transform(this.projection, feature.layer.map.baseLayer.projection);
				this.projection = feature.layer.map.baseLayer.projection.clone();
			}
			return this.geometry.intersects(feature.geometry);
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