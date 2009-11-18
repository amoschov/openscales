package org.openscales.fx.control
{
	import mx.core.UIComponent;
	
	import org.openscales.core.control.IControl;

	public class FxControl extends UIComponent
	{
		private var _control:IControl;
		
		public function FxControl()
		{
			super();
		}
		
		public function set control(value:IControl):void {
			this._control = value;
		}
		
		public function get control():IControl {
			return this._control;
		}
		
		override public function set x(value:Number):void {
			super.x = value;
			if(this.control != null)
				this.control.x = value;
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			if(this.control != null)
				this.control.y = value;
		}
		
	}
}