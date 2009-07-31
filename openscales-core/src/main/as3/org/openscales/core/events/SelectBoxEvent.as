package org.openscales.core.events
{
	import org.openscales.core.basetypes.Bounds;
	
	public class SelectBoxEvent extends OpenScalesEvent
	{
		
		private var _bounds:Bounds = null;
		
		public static const SELECTBOX_DRAW:String="openscales.selectedbox.draw";
		
		public function SelectBoxEvent(type:String, bounds:Bounds ,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._bounds = bounds;
		}
		
		public function get bounds():Bounds
		{
			return this._bounds;
		}
		/**
		 * @private 
		 */
		public function set bounds(value:Bounds):void
		{
			this._bounds=value;
		}
		
	}
}