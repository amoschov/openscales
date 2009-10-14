package org.openscales.fx.layer
{
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.style.Style;
	
	public class FxVectorLayer extends FxLayer
	{
		
		public function FxVectorLayer()
		{
			this._layer = new VectorLayer("");
		}
		
		public function set style(value:Style):void{
			
			if(this._layer){
				(this._layer as VectorLayer).style = value; 
			}
		}
		
		public function get style():Style{
			
			return (this._layer as VectorLayer).style;
		}
	}		
}