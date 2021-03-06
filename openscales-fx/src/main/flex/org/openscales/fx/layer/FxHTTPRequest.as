package org.openscales.fx.layer
{
	import org.openscales.core.Util;
	import org.openscales.core.layer.HTTPRequest;

	public class FxHTTPRequest extends FxLayer
	{
		public function FxHTTPRequest()
		{
			super();
		}
		
		public function set url(value:String):void {
	    	if(this.layer != null)
	    		(this.layer as HTTPRequest).url = value;
	    }
		
		public function set altUrls(value:Array):void {
	    	if(this.layer != null)
	    		(this.layer as HTTPRequest).altUrls = value;
	    }
	    
	    public function set params(value:Object):void {
	    	if(this.layer != null)
	    		Util.extend((this.layer as HTTPRequest).params, value);
	    }
	}
}