package org.openscales.core.handler
{
	import org.openscales.core.Map;

	public class AbstractHandler implements IHandler
	{
		private var _target:Map;
		
		private var _active:Boolean;
		
		public function AbstractHandler(target:Map = null, active:Boolean = false)
		{
			this.target = target;
			this.active = active;
		}

		public function get target():Map
		{
			return this._target;
		}
		
		public function set target(value:Map):void
		{
			// If control is active, unregisters listeners on the current target
			if(this._active){
				
				this.unregisterListeners();
			}
			
			this._target = value;
			
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
			if(!this._active && value && (this._target != null)){
				
				this.registerListeners();
			}
			
			// If controls gets inactive, unregisters the listeners on the current target
			if(this._active && !value && (this._target != null)){
				
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