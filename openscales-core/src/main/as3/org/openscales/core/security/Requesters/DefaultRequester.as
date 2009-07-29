package org.openscales.core.security.Requesters
{
	import org.openscales.core.RequestLayer;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.security.SecurityType;
	/**
	 *This class is used as defaultRequester for the security  
	 * @author DamienNda 
	 **/
	public class DefaultRequester implements ISecurityRequester
	{
		/**
		 * @private
		 *Requester type 
		 **/
		protected  var _type:String;
		/**
		 * @private
		 **/
		private var _listLayer:Array=new Array();
		
		/**
		 *Default Requester creation 
		 **/
		public function DefaultRequester(listlayer:Array=null)
		{
			if(listlayer!=null) this._listLayer=listlayer;
			this._type=SecurityType.DefaultRequester;
		}
	
		/**
		 * @inheritDoc
		 * */
		public function IsSecuredByRequester(layerRefId:Layer):Boolean
		{
			for(var i:int=0; i < this._listLayer.length; i++) {
	            if (this._listLayer[i] == layerRefId) {
	                return true;
	            }
	        }
	        return false;
		} 
		 /**
		 * @inheritDoc
		 * */
		public function AuthentificateLayer(request:RequestLayer):void
		{
			request.layer.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_AUTHENTIFICATED,request.layer));
		}
		
		/**
		 * this function is use for adding unsecured layer to the security Requester
		 * @param layerRefId layer Reference
		 * */
		public function addsecuredLayer(layerRefId:Layer):Boolean
		{
			if(!this.IsSecuredByRequester(layerRefId))
			{
			this._listLayer.push(layerRefId);
	         return true;
			}
	        return false;
		}
		/**
		 *List of refences layers which are  concerned   
		 * by this security
		 **/
		public function get listLayer():Array
		{
			return this._listLayer;
		}
		/**
		 *Get requester type 
		 **/
		 public function get type():String
		 {
		 	return this._type;
		 }
	}
}