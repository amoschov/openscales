package org.openscales.fx.control
{
	import org.openscales.component.control.spinner.Spinner;
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.MapEvent;
	
	public class FxSpinner extends FxControl
	{
		public function FxSpinner()	{
			if (x >= 0 && y>= 0) {
				this.control = new Spinner(15, 30, 65, new Pixel(x,y));
			}	
			this.control.active = true;		
			super();
		}
	}
}