package org.openscales.fx.control
{
	import org.openscales.core.control.PanZoom;

	public class FxPanZoom extends FxControl
	{
		public function FxPanZoom()
		{
			this.control = new PanZoom();
			super();
		}
		
	}
}