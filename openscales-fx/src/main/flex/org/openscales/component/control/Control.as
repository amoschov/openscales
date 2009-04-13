package org.openscales.component.control
{
	import mx.containers.Canvas;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.control.IControl;

	public class Control extends Canvas implements IControl
	{
		protected var _map:Map = null;
		protected var _active:Boolean = false;
		
		public function Control()
		{
			super();
		}
		
		public function get map():Map
		{
			return this._map;
		}
		
		public function set map(value:Map):void
		{
			this._map = value;
		}
		
		public function get active():Boolean
		{
			return this._active;
		}
		
		public function set active(value:Boolean):void
		{
			this._active = value;
		}
		
		public function draw():void
		{
		}
		
		public function set position(px:Pixel):void
		{
			if (px != null) {
	            this.x = px.x;
	            this.y = px.y;
	        }
		}
		
		public function get position():Pixel
		{
			return new Pixel(this.x, this.y);
		}
	
	}
}