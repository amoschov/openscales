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
				this.control = new Spinner(15,30,65,new Pixel(x,y));
			}	
			this.control.active = true;		
			super();
		}
		
		//getters setters
		public function get map():Map{
			return this.control.map;
		}
		
		public function set map(value:Map):void{
			this.control.map=value;
			this.control.map.addEventListener(MapEvent.LOAD_START,mapEventHandler);
			this.control.map.addEventListener(MapEvent.LOAD_END,mapEventHandler);
			
			// check if map is already loading.
			if (!this.map.loadComplete)			 
			 (this.control as Spinner).start();
		}
		
		private function mapEventHandler(event:MapEvent):void
		{
			switch (event.type) 	{
				case MapEvent.LOAD_START:
				 (this.control as Spinner).start();
				 break;
				case MapEvent.LOAD_END:
				 this.visible = false;
				 (this.control as Spinner).stop();
				 break;
			}
		}
	}
}