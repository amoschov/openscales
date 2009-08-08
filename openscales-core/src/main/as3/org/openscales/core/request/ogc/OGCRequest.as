package org.openscales.core.request.ogc
{
	import flash.events.EventDispatcher;
	
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.params.IHttpParams;
	import org.openscales.core.request.AbstractRequest;
	import org.openscales.core.request.IRequest;
	import org.openscales.core.layer.RequestLayer;

	/**
	 *This class is a requester for ogc
	 * Don't use it, directly use the  service requester like WMSRequest or WFSRequest  
	 **/
	public class OGCRequest extends AbstractRequest
	{
		/**
		 *The OGCRequester loader
		 * to load data or picture 
		 **/
		private var _loader:EventDispatcher;
		
		public function OGCRequest(layer:RequestLayer,url:String, method:String, params:IHttpParams, oncomplete:Function=null, loader:EventDispatcher=null)
		{	
			this._loader=loader;
			super(layer,url, method, params, oncomplete,null);
		}
		
		override public function executeRequest():EventDispatcher
		{
			return null;
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