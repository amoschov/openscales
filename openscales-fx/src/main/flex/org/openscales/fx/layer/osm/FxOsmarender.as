package org.openscales.fx.layer.osm {
	import org.openscales.core.layer.osm.Osmarender;
	import org.openscales.fx.layer.FxTMS;

	public class FxOsmarender extends FxTMS {
		public function FxOsmarender() {
			this._layer=new Osmarender("");
			super();
		}

	}
}