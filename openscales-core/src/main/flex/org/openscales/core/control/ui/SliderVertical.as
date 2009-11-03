package org.openscales.core.control.ui
{
	import org.openscales.core.basetypes.Pixel;

	/**
	 * SliderVertical class allows to create vertical slider intsances in pure AS3.
	 * Extends Button class.
	 */
	public class SliderVertical extends Button
	{

		[Embed(source="/assets/images/slide-vertical.png")]
		private var _layerSwitcherSlideVerticalImg:Class;

		private var _layerName:String;

		public function SliderVertical(name:String, xy:Pixel,layerName:String)
		{
			super(name, new _layerSwitcherSlideVerticalImg(), xy);
			this._layerName = layerName;
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

