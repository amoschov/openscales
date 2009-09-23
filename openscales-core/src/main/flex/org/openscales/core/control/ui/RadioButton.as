package org.openscales.core.control.ui
{
	import flash.display.Bitmap;

	import org.openscales.core.basetypes.Pixel;

	/**
	 * RadioButton class allows to create radiobutton intsances in pure AS3.
	 * Extends Button class.
	 */
	public class RadioButton extends Button
	{

		[Embed(source="/org/openscales/core/img/radiobutton-selected.png")]
		private var _layerSwitcherRadioButtonSelectedImg:Class;

		[Embed(source="/org/openscales/core/img/radiobutton-noselected.png")]
		private var _layerSwitcherRadioButtonNoSelectedImg:Class;

		private var _status:Boolean=false;
		private var image:Bitmap;
		private var _layerName:String;

		public function RadioButton(xy:Pixel,layerName:String,status:Boolean)
		{
			this._layerName = layerName;
			this._status = status;
			if(this._status)
			{
				this.image = new _layerSwitcherRadioButtonSelectedImg();
			}
			else
			{
				this.image = new _layerSwitcherRadioButtonNoSelectedImg();
			}
			super("selected", this.image, xy);
		}

		public function set status(value:Boolean):void {
			this._status = value;

			for(var i:int=0; i<this.numChildren;i++) {
				this.removeChildAt(0);
			}

			if(this._status == false) {
				this.image = new _layerSwitcherRadioButtonNoSelectedImg();
			} else {
				this.image = new _layerSwitcherRadioButtonSelectedImg();
			}
			this.addChild(this.image);


		}

		public function get status():Boolean
		{
			return this._status;
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

