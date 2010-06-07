package org.openscales.fx.layer.osm {
	import org.openscales.core.layer.osm.Maplint;
	import org.openscales.fx.layer.FxTMS;

	public class FxMaplint extends FxTMS {
		public function FxMaplint() {
			this._layer=new Maplint("");
			super();
		}

	}
}