package org.openscales.core.layer
{
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.request.IRequest;
	import org.openscales.core.Map;
	
	/**
	 *This class is use for all layers requests 
	 **/
	public class RequestLayer extends Layer
	{
		
		/**
		 *The requester object 
		 **/
		private var _requester:IRequest;
		
		public function RequestLayer(name:String,request:IRequest,isBaseLayer:Boolean=false, visible:Boolean=true, projection:String=null, proxy:String=null)
		{
			this._requester=request;
			super(name, isBaseLayer, visible, projection, proxy);
		
		}
		
		override public function set map(map:Map):void {
			super.map = map;
			if (this.isBaseLayer) {
				this.map.addEventListener(LayerEvent.LAYERS_CONF_END,(this as RequestLayer).tilesDownload);
			}
		}
		
		/**
		 * To start tiles downloading
		 * @param LayerEvent
		 * */
		public function tilesDownload(layerEvent:LayerEvent):void
		{
			if(layerEvent.layer==this)
			{
				this.isAuthorizedTodownload=true;
				this.moveTo(layerEvent.bounds,true);
			}
		}
		/**
		 * The requester object
		 **/
		public function get requester():IRequest
		{
		return this._requester;	
		}
		public function set requester(value:IRequest):void
		{
			this._requester=value;
		}
		/**
		 * To know if the Request  layer is authorized to download
		 * */
		public function get isAuthorizedTodownload():Boolean{
			return this._requester.isAuthorized;
		}

		public function set isAuthorizedTodownload(value:Boolean):void{
		if(this._requester!=null)	
			this._requester.isAuthorized=value
		
		}
	}
}