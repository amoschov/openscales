package org.openscales.core.layer.requesters.ogc
{
	import flash.events.EventDispatcher;
	
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.params.IHttpParams;
	import org.openscales.core.layer.requesters.AbstractRequest;
	import org.openscales.core.layer.requesters.IhttpRequest;

	/**
	 *This class is a requester for ogc
	 * Don't use it, directly use the  service requester like WMSRequest or WFSRequest  
	 **/
	public class OGCRequest extends AbstractRequest implements IhttpRequest
	{
		/**
		 *The OGCRequester loader
		 * to load data or picture 
		 **/
		private var _loader:EventDispatcher;
		
		public function OGCRequest(layer:Layer,url:String, method:String, params:IHttpParams, oncomplete:Function=null,proxy:String=null,loader:EventDispatcher=null)
		{	
			this._loader=loader;
			super(layer,url, method, params, oncomplete,null,proxy);
		}
		
		override public function executeRequest():void
		{

		}
		/**
		 * The OGCRequester loader
		 * to load data or picture 
		 **/
		public function get loader():EventDispatcher
		{
			return this._loader;
		}
		/**
		 *@private
		 * */
		public function set loader(loader:EventDispatcher):void{
			this._loader=loader;
		}
	}
}