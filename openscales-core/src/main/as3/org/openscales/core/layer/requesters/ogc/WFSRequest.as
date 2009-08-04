package org.openscales.core.layer.requesters.ogc
{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.params.ogc.WFSParams;
	import org.openscales.core.layer.requesters.IhttpRequest;

	public class WFSRequest extends OGCRequest implements IhttpRequest
	{
		public function WFSRequest(layer:Layer,url:String, method:String, params:WFSParams, oncomplete:Function=null,proxy:String=null,loader:EventDispatcher=null)
		{
			//WFS directly downloads data or textual response
			//For it we use an URLLoader			
			super(layer,url, method, params, oncomplete,proxy,new URLLoader());
		}
		
		override public function executeRequest():void
		{
			//TODO: implement function

		}
		
	}
}