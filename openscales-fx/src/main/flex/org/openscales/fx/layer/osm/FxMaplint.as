package org.openscales.fx.layer.osm
{
	import org.openscales.core.layer.osm.Maplint;
	import org.openscales.fx.layer.FxLayer;

	public class FxMaplint extends FxLayer
	{
		public function FxMaplint()
		{
			this.layer = new Maplint();
			super();
		}
		
	}
}