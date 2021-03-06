package org.openscales.fx.layer
{
	import org.openscales.core.layer.KML;
	import org.openscales.proj4as.ProjProjection;

	public class FxKML extends FxFeatureLayer
	{
		public function FxKML()
		{
			super();
		}

	    override public function init():void {
			this._layer = new KML("", "", null);
	    }
		
		public function set url(value:String):void {
			if(this.layer != null)
				(this.layer as KML).url = value;
		}

		public function set srs(value:String):void {
			if (this.layer != null) {
				this.layer.projection = new ProjProjection(value);
			}
		}
		
	}
}