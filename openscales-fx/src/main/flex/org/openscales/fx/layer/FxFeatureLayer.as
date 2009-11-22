package org.openscales.fx.layer
{
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.style.Style;
	
	public class FxFeatureLayer extends FxLayer
	{
		public function FxFeatureLayer() {
			super();
		}
		
		override public function init():void {
			this._layer = new FeatureLayer("");
		}
		
		public function get style():Style{
			return (this._layer as FeatureLayer).style;
		}
		
		public function set style(value:Style):void{
			if (this._layer) {
				(this._layer as FeatureLayer).style = value; 
			}
		}
		
	}		
}