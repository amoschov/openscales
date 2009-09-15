package org.openscales.fx.layer
{
	import org.openscales.core.layer.Grid;

	public class FxGrid extends FxHTTPRequest
	{
		public function FxGrid()
		{
			super();
		}
		
		public function set tileWidth(value:Number):void {
	    	if(this.layer != null)
	    		(this.layer as Grid).tileWidth = value;
	    }
	    
	    public function set tileHeight(value:Number):void {
	    	if(this.layer != null)
	    		(this.layer as Grid).tileHeight = value;
	    }	
		
	}
}