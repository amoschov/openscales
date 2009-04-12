package org.openscales.fx {
	
	import flash.display.DisplayObject;
	
	import mx.core.Container;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Size;

	public class FxMap extends Container {
		
		private var _map:Map;
			
		private var _maxResolution:Number = NaN;
		
		private var _numZoomLevels:Number = NaN;
				
		public function FxMap() {
			super();
			//this._size = new Size(400,300);
		}
		
		override protected function createChildren():void
		{
			
			this._map = new Map();
			this.rawChildren.addChild(this._map);
			super.createChildren();
						
			if(!isNaN(this._maxResolution))
				this.map.maxResolution = this._maxResolution;
				
			if(!isNaN(this._numZoomLevels))
				this.map.numZoomLevels = this._numZoomLevels;
			
			for(var i:int=0; i < this.rawChildren.numChildren ; i++) {
				var child:DisplayObject = this.rawChildren.getChildAt(i);
				if(child is FxLayer) {
					this.map.addLayer((child as FxLayer).layer);
				}
			}
			
		}
				
		public function get map():Map {
			return this._map;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			
			if(this.map != null)
				this.map.width = value;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			
			if(this.map != null)
				this.map.height = value;
		}
		
		public function set maxResolution(value:Number):void {
			this._maxResolution = value;
		}
		
		public function set numZoomLevels(value:Number):void {
			this._numZoomLevels = value;
		}
			
	}
}