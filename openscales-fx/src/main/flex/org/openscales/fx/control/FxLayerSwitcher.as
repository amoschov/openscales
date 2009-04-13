package org.openscales.fx.control
{
	import org.openscales.core.control.LayerSwitcher;

	public class FxLayerSwitcher extends FxControl
	{
		public function FxLayerSwitcher()
		{
			this.control = new LayerSwitcher();
			super();
		}
		
	}
}