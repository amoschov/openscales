package org.openscales.fx.layer
{
	import org.openscales.core.layer.ogc.WMSC;

	public class FxWMSC extends FxWMS
	{
		public function FxWMSC()
		{
			super();
		}
		
		override public function init():void {
			this._layer = new WMSC("", "", new Object());
		}
		
	}
}