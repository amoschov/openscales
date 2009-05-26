package org.openscales.fx.layer
{
	import org.openscales.core.layer.ogc.WMS;

	public class FxWMS extends FxGrid
	{
		public function FxWMS()
		{
			super();
		}
		
		override public function init():void {
			this._layer = new WMS("", "", new Object());
		}
		
		public function set layers(value:String):void {
	    	if(this.layer != null)
    		(this.layer as WMS).params.LAYERS = value;
	    }
	    
	    public function set format(value:String):void {
	    	if(this.layer != null)
	    		(this.layer as WMS).params.FORMAT = value;
	    }
		
	}
}