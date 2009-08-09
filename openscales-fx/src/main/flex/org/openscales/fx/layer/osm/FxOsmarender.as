package org.openscales.fx.layer.osm {
	import org.openscales.core.layer.osm.Osmarender;
	import org.openscales.fx.layer.FxLayer;

	public class FxOsmarender extends FxLayer {
		public function FxOsmarender() {
			this._layer=new Osmarender("");
			super();
		}

	}
}