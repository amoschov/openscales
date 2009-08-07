package org.openscales.core.layer
{
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.layer.requesters.AbstractRequest;
	
	/**
	 *This class is use for all layers requests 
	 **/
	public class RequestLayer extends Layer
	{
		
		/**
		 *The requester object 
		 **/
		private var _requester:AbstractRequest;
		
		public function RequestLayer(name:String,ihttpRequest:AbstractRequest,isBaseLayer:Boolean=false, visible:Boolean=true, projection:String=null, proxy:String=null)
		{
			this._requester=ihttpRequest;
			super(name, isBaseLayer, visible, projection, proxy);
		
		}
		/**
		 * To start tiles downloading
		 * @param LayerEvent
		 * */
		public function tilesDownload(layerEvent:LayerEvent):void
		{
			if(layerEvent.layer==this)
			{
				this.moveTo(layerEvent.bounds,true);
				this.isAuthorizedTodownload=true;
			}
		}
		/**
		 * The requester object
		 **/
		public function get requester():AbstractRequest
		{
		return this._requester;	
		}
		public function set requester(value:AbstractRequest):void
		{
			this._requester=value;
		}
		/**
		 * To know if the Request  layer is authorized to download
		 * */
		public function get isAuthorizedTodownload():Boolean{
			return this._requester.isAuthorized;
		}
		/**
		 * @private
		 * */
		public function set isAuthorizedTodownload(value:Boolean):void{
		if(this._requester!=null)	
			this._requester.isAuthorized=value
		
		}
	}
}