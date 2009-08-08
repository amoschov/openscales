package org.openscales.core.layer.requesters.ogc
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.params.ogc.WMSParams;
	import org.openscales.core.layer.requesters.IRequest;
	import org.openscales.core.layer.RequestLayer;
	/**
	 * This class is used for all WMSRequest
	 **/
	public class WMSRequest extends OGCRequest
	{
		public function WMSRequest(layer:RequestLayer,url:String, method:String, params:WMSParams, oncomplete:Function=null)
		{
			//WMS downloads a picture 
			//consequently we use a loader providing for flash.display
			super(layer,url, method, params,oncomplete,new Loader());
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
			
		override public function executeRequest():EventDispatcher
		{
			
			return this.layer.map.securityConfiguration.securitymanager.getLoader(this);
		}
	}
}