package org.openscales.fx.layer
{
	import org.openscales.core.Util;
	import org.openscales.core.layer.HTTPRequest;
	import org.openscales.core.layer.RequestLayer;
	import org.openscales.core.layer.requesters.AbstractRequest;

	public class FxHTTPRequest extends FxLayer
	{
		public function FxHTTPRequest()
		{
			super();
		}
		/**
		 * set this flag at true if the layer doesn't bneed security for request
		 * 
		 * */
		public function set isAuthorizedToDownload(value:Boolean):void{
			if(this.layer != null)
	    	{
	    		(this.layer as RequestLayer).isAuthorizedTodownload=value;
	    		
	    	}
		}
		public function set url(value:String):void {
	    	if(this.layer != null)
	    	{
	    		((this.layer as HTTPRequest).requester as AbstractRequest).url= value;
	    		//TODO remove that after creation of osparams and georssparams extends IhttpRequest
	    		(this.layer as HTTPRequest).url=value;
	    	}
	    }
		
		public function set altUrls(value:Array):void {
	    	if(this.layer != null)
	    	{	((this.layer as HTTPRequest).requester as AbstractRequest).altUrl = value.toString();
	    		//TODO remove that after creation of osparams and georssparams extends IhttpRequest
	    		(this.layer as HTTPRequest).altUrls=value;
	    	}
	    }
	    
	    public function set params(value:Object):void {
	    	if(this.layer != null){
	    		Util.extend(((this.layer as HTTPRequest).requester as AbstractRequest).params, value);
	    		//TODO remove that after creation of osparams and georssparams extends IhttpRequest
	    		Util.extend((this.layer as HTTPRequest).params, value);
	    	}
	    }
	}
}