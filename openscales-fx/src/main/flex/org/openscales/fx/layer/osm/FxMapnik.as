package org.openscales.fx.layer.osm {
	import org.openscales.core.layer.osm.Mapnik;
	import org.openscales.fx.layer.FxLayer;

	public class FxMapnik extends FxLayer {
		public function FxMapnik() {
			this._layer=new Mapnik("");
			super();
		}

	}
}