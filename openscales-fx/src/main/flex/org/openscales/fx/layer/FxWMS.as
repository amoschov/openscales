package org.openscales.fx.layer
{
	import org.openscales.core.layer.ogc.WMS;
	import org.openscales.core.layer.params.ogc.WMSParams;

	public class FxWMS extends FxGrid
	{
		public function FxWMS()
		{
			super();
		}
		
		override public function init():void {
			this._layer = new WMS("", "");
		}
		
		public function set layers(value:String):void {
	    	if(this.layer != null)
    			((this.layer as WMS).params as WMSParams).layers = value;
	    }
	    
	    public function set format(value:String):void {
	    	if(this.layer != null)
	    		((this.layer as WMS).params as WMSParams).format = value;
	    }
		
	}
}