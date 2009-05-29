package org.openscales.fx.layer.osm
{
	import org.openscales.core.layer.osm.CycleMap;
	import org.openscales.fx.layer.FxLayer;

	public class FxCycleMap extends FxLayer
	{
		public function FxCycleMap()
		{
			this._layer = new CycleMap("");
			super();
		}
		
	}
}