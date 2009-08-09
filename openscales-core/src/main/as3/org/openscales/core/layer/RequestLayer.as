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
		private var _request:IRequest;
		
		public function RequestLayer(name:String,request:IRequest,isBaseLayer:Boolean=false, visible:Boolean=true, projection:String=null, proxy:String=null)
		{
			this._request=request;
			super(name, isBaseLayer, visible, projection, proxy);
		
		}
		
		override public function set map(map:Map):void {
			super.map = map;
			if (this.isBaseLayer) {
				this.map.addEventListener(LayerEvent.LAYER_INITIALIZED,(this as RequestLayer).onLayerInitialized);
			}
		}
		
		/**
		 * Start download after init
		 * @param LayerEvent
		 * */
		public function onLayerInitialized(layerEvent:LayerEvent):void
		{
			if(layerEvent.layer==this)
			{
				this.request.isAuthorized=true;
				this.moveTo(layerEvent.bounds,true);
			}
		}
		/**
		 * The requester object
		 **/
		public function get request():IRequest
		{
		return this._request;	
		}
		public function set request(value:IRequest):void
		{
			this._request=value;
		}
		
	}
}