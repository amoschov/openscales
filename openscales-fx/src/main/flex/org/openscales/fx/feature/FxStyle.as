package org.openscales.fx.feature
{
	import mx.core.UIComponent;
	
	import org.openscales.core.style.Style;

	public class FxStyle extends UIComponent
	{
		private var _style:Style;	
		
		public function FxStyle()
		{
			this._style = new Style();
			super();
		}
		
		public function get style():Style {
			return this._style;
		}
	}
}