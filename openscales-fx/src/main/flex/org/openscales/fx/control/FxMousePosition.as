package org.openscales.fx.control
{
	import org.openscales.proj4as.ProjProjection;
	
	import org.openscales.core.control.MousePosition;

	public class FxMousePosition extends FxControl
	{
		public function FxMousePosition()
		{
			this.control = new MousePosition();
			super();
		}
		
		public function set displayProjection(value:String):void {
			if (this.control != null && value != null)
				(this.control as MousePosition).displayProjection = new ProjProjection(value);
		}
		
	}
}