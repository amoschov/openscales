package org.openscales.fx.layer.osm {
	import org.openscales.core.layer.osm.Mapnik;
	import org.openscales.fx.layer.FxTMS;

	public class FxMapnik extends FxTMS {
		public function FxMapnik() {
			this._layer=new Mapnik("");
			super();
		}

	}
}