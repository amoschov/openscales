package org.openscales.fx.basetypes
{
	import mx.core.UIComponent;
	
	import org.openscales.core.basetypes.Bounds;

	public class FxBounds extends UIComponent
	{
		private var _bounds:Bounds;	
		
		public function FxBounds()
		{
			this._bounds = new Bounds();
			super();
		}
		
		public function set left(value:Number):void {
			if(this.bounds != null)
				this.bounds.left = value;
		}
		
		public function set bottom(value:Number):void {
			if(this.bounds != null)
				this.bounds.bottom = value;
		}
		
		public function set right(value:Number):void {
			if(this.bounds != null)
				this.bounds.right = value;
		}
		
		public function set top(value:Number):void {
			if(this.bounds != null)
				this.bounds.top = value;
		}
				
		public function get bounds():Bounds {
			return this._bounds;
		}
		
		
		
	}
}