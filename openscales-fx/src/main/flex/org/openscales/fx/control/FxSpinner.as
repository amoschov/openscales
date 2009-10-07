package org.openscales.fx.control
{
	import org.openscales.component.control.spinner.Spinner;
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.MapEvent;
	
	public class FxSpinner extends FxControl
	{
		private var slices:int = 12;
		private var radius:int = 6;
		private var rotationspeed:int = 80;
		private var color:uint = 0x000000;
		
		public function FxSpinner()	{
			if (x >= 0 && y>= 0) {
				this.control = new Spinner(slices, radius, rotationspeed, color, new Pixel(x,y));
			}	
			this.control.active = true;		
			super();
		}
	}
}