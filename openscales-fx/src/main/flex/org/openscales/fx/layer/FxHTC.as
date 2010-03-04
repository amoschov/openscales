package org.openscales.fx.layer
{
	import org.openscales.core.layer.HTC;
	
	public class FxHTC extends FxLayer
	{
		public function FxHTC(name:String,url:String)
		{
			this._layer=new HTC(name,url);
			super();
		}

		public function set tileWidth(value:Number):void {
			if(this.layer != null)
				(this.layer as HTC).tileWidth = value;
		}

		public function set tileHeight(value:Number):void {
			if(this.layer != null)
				(this.layer as HTC).tileHeight = value;
		}

		public function set url(value:String):void {
			if(this.layer != null)
				(this.layer as HTC).url = value;
		}
	}
}