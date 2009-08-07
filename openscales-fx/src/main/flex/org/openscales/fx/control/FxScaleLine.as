package org.openscales.fx.control
{
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.control.ScaleLine;
	
	public class FxScaleLine extends FxControl
	{
		
		public function FxScaleLine()
		{
			this.control=new ScaleLine(new Pixel(0,600));
				this.control.active=true;
			super();
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