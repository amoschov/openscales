package org.openscales.fx.layer.osm {
	import org.openscales.core.layer.osm.CycleMap;
	import org.openscales.fx.layer.FxTMS;

	public class FxCycleMap extends FxTMS {
		public function FxCycleMap() {
			this._layer=new CycleMap("");
			super();
		}

	}
}