package org.openscales.core.layer.requesters.ogc
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.params.ogc.WMSParams;
	import org.openscales.core.layer.requesters.IhttpRequest;
	/**
	 * This class is used for all WMSRequest
	 **/
	public class WMSRequest extends OGCRequest implements IhttpRequest
	{
		public function WMSRequest(layer:Layer,url:String, method:String, params:WMSParams,proxy:String=null,oncomplete:Function=null)
		{
			//WMS downloads a picture 
			//consequently we use a loader providing for flash.display
			super(layer,url, method, params,oncomplete,proxy,new Loader());
		}
		
		override public function getUrl():String{
			
			var request:String;
		 	if(this.url.indexOf("?")==-1) request= this.url+"?"+this.params.toGETString();
		 	else request=this.url+"&"+this.params.toGETString();
		 	if(this.proxy!=null)
		 	{
		 		return this.proxy+ encodeURIComponent(request);
		 	}
		 	return request;
		}
			
		override public function executeRequest():void
		{
			if(this.onComplete!=null)
			{
				this.loader=new Loader();
				(this.loader as Loader).load(new URLRequest(this.getUrl()));
				(this.loader as Loader).contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete,false, 0, true);
				
			}
		}
	}
}