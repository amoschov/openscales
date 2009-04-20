package org.openscales.core.handler
{
	import org.openscales.core.Map;

	/**
	 * Handler base class
	 */
	public class Handler implements IHandler
	{
		private var _map:Map;
		
		private var _active:Boolean;
		
		public function Handler(map:Map = null, active:Boolean = false)
		{
			this.map = map;
			this.active = active;
		}

		public function get map():Map
		{
			return this._map;
		}
		
		public function set map(value:Map):void
		{
			// If control is active, unregisters listeners on the current target
			if(this._active){
				
				this.unregisterListeners();
			}
			
			this._map = value;
			
			// If control is active, registers listeners on the current target
			if(this._active){
			
				this.registerListeners();
			}
		}
		
		public function get active():Boolean
		{
			return this._active;
		}
		
		public function set active(value:Boolean):void
		{
			// If controls gets active, registers the listeners on the current target
			if(!this._active && value && (this._map != null)){
				
				this.registerListeners();
			}
			
			// If controls gets inactive, unregisters the listeners on the current target
			if(this._active && !value && (this._map != null)){
				
				this.unregisterListeners();
			}
		
			this._active = value;
		}
		
		protected function registerListeners():void {
			
		}
		
		protected function unregisterListeners():void {
		
		}
		
	}
}