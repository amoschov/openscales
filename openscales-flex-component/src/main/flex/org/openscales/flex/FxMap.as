package org.openscales.flex {
	
	import mx.core.UIComponent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Size;

	public class FxMap extends UIComponent {
		
		private var _map:Map;
		
		public function FxMap() {
			super();
			
		}
		
		override protected function createChildren():void
		{
			
			super.createChildren();

			this._map = new Map();
			this.addChild(this._map);
		}
		
		public function get map():Map {
			return this._map;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			
			if(map)
				map.width = value;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			
			if(map)
				map.height = value;
		}
		
		override public function set percentWidth(value:Number):void {
			super.percentWidth = value;
			
			if(map)
				map.width = this.width;
		}

		override public function set percentHeight(value:Number):void {
			super.percentHeight = value;
			
			if(map)
				map.height = this.height;
		}
		
	}
}