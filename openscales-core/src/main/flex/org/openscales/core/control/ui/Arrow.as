package org.openscales.core.control.ui
{
	import flash.display.Bitmap;

	import org.openscales.basetypes.Pixel;

	/**
	 * Classes to represent an arrow in pure AS3.
	 * Extends Button class.
	 */
	public class Arrow extends Button
	{

		[Embed(source="/assets/images/arrow_down.png")]
		private var _arrowDownImg:Class;

		[Embed(source="/assets/images/arrow_up.png")]
		private var _arrowUpImg:Class;

		private var _state:String;
		private var image:Bitmap;
		private var _layerName:String;

		public function Arrow(xy:Pixel,layerName:String,state:String)
		{
			this._layerName = layerName;
			this._state = state;
			if(this._state == "UP")
			{
				this.image = new _arrowUpImg();
			}
			else
			{
				this.image = new _arrowDownImg();
			}
			super("Arrow", this.image, xy);
		}

		public function set state(value:String):void 
		{
			this._state = value;

			for(var i:int=0; i<this.numChildren;i++) 
			{
				this.removeChildAt(0);
			}

			if(this._state == "UP") {
				this.image = new _arrowUpImg();
			} else {
				this.image = new _arrowDownImg();
			}
			this.addChild(this.image);

		}

		public function get state():String
		{
			return this._state;
		}

		public function get layerName():String
		{
			return this._layerName;
		}
		public function set layerName(value:String):void
		{
			this._layerName=value;
		}

	}
}

