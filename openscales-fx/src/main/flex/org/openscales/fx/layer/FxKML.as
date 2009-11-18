package org.openscales.fx.layer
{
	import org.openscales.core.layer.KML;

	public class FxKML extends FxLayer
	{
		public function FxKML()
		{
			this._layer = new KML("", "", null);
			super();
		}
		
		public function set url(value:String):void {
			if(this.layer != null)
				(this.layer as KML).url = value;
		}
		
	}
}