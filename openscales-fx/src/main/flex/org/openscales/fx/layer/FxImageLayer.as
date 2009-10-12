package org.openscales.fx.layer
{
	import org.openscales.core.layer.ImageLayer;

	public class FxImageLayer extends FxLayer
	{
		public function FxImageLayer()
		{
			this._layer = new ImageLayer("", "", null);
			super();
		}
		
		public function set url(value:String):void {
			if(this.layer != null)
				(this.layer as ImageLayer).url = value;
		}
		
		public function set bounds(value:String):void {
			this.maxExtent = value;
		}
		
	}
}