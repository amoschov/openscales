package org.openscales.core.control.ui
{
	import org.openscales.core.basetypes.Pixel;
	import flash.display.Bitmap;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.Button;

	public class SliderVertical extends Button
	{
		
		[Embed(source="/org/openscales/core/img/slide-vertical.png")]
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