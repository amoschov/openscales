package org.openscales.fx.control
{
	import org.openscales.core.Map;
	import org.openscales.basetypes.Pixel;
	import org.openscales.core.control.ScaleLine;
	
	public class FxScaleLine extends FxControl
	{
		
		public function FxScaleLine()
		{
			super();
			this.control = new ScaleLine();
			this.control.active = true;
		}
		
		//getters setters
		public function get map():Map{
			return this.control.map;
		}
		public function set map(value:Map):void{
			this.control.map=value;
		}
	}
}