package org.openscales.core.control.ui
{
	import org.openscales.core.basetypes.Pixel;

	public class SliderHorizontal extends Button
	{
		[Embed(source="/org/openscales/core/img/slide-horizontal.png")]
        private var _layerSwitcherSlideHorizontalImg:Class;
        
		private var _layerName:String;
		
		public function SliderHorizontal(name:String, xy:Pixel,layerName:String)
		{
			super(name, new _layerSwitcherSlideHorizontalImg(), xy);
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