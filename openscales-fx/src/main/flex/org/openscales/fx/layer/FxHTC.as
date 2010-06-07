package org.openscales.fx.layer
{
	import org.openscales.core.layer.HTC;
	
	public class FxHTC extends FxTMS
	{
		public function FxHTC() {
			this._layer=new HTC("","");
			super();
		}

		public function set directoryPrefix(value:String):void {
			if(this.layer != null)
				(this.layer as HTC).directoryPrefix = value;
		}
	}
}