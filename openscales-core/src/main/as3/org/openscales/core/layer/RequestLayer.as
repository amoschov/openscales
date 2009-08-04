package org.openscales.core.layer
{
	import org.openscales.core.layer.requesters.IhttpRequest;
	
	/**
	 *This class is use for all layers requests 
	 **/
	public class RequestLayer extends Layer
	{
		
		/**
		 *The requester object 
		 **/
		private var _requester:IhttpRequest;
		
		public function RequestLayer(name:String,ihttpRequest:IhttpRequest,isBaseLayer:Boolean=false, visible:Boolean=true, projection:String=null, proxy:String=null)
		{
			this._requester=ihttpRequest;
			super(name, isBaseLayer, visible, projection, proxy);
		
		}
		
		/**
		 * The requester object
		 **/
		public function get requester():IhttpRequest
		{
		return this._requester;	
		}
		public function set requester(value:IhttpRequest):void
		{
			this._requester=value;
		}
	}
}