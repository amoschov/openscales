package org.openscales.core.layer.requesters
{
	import flash.events.EventDispatcher;
	
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.params.IHttpParams;
	
	/**
	 *This class is the abstract class for layers http Request
	 *@author damienNda 
	 **/
	public class AbstractRequest implements IhttpRequest
	{
		/**
		 * layer concerned by the request
		 * @private
		 **/
		 private var _layer:Layer;
		/**
		 * Layer url
		 * @private
		 **/
			private var _url:String;
		/**
		 *Alternative url
		 * @private 
		 **/
		 	private var _altUrl:Array;
		/**
		 *  Requesting method  POST  or GET   
		 * @private     
		 **/
		private var _method:String;
		/**
		 *	Oncomplete function is used to execute a 
		 *  function after a download 
		 * @private
		 **/
		private var _onComplete:Function;
		/**
		 *	onFailure function is used to execute a 
		 *  function after a bad download 
		 * @private
		 **/
		private var _onfailure:Function;
		/**
		 *	Requesting params 
		 * @private
		 **/
		private var _params:IHttpParams;
		/**
		 * proxy
		 * @private
		 **/
		private var _proxy:String="";
		/**
		 * download authorization
		 * when this is flags is equaled true the layer is allowed to download tile
		 * @private
		 * */
		private var _isAuthorized:Boolean=false;
		/**
		 *This class is an Abstract class don't instanciate it  
		 **/
		public function AbstractRequest(layer:Layer,url:String,method:String,params:IHttpParams,oncomplete:Function=null,altUrl:Array=null)
		{
			this._layer=layer;
			this._url=url;
			this._method=method;
			this._params=params;
			this._onComplete=oncomplete;
			this._altUrl=altUrl;
		}
		
		public function getUrl():String
		{
			return null;
		}

		public function executeRequest():EventDispatcher
		{
			return null;
		}
		/**
		 * layer concerned by the request
		 **/
		 public function get layer():Layer{
		 	return this._layer;
		 }
		 /**
		 * @private
		 **/
		 public function set layer(value:Layer):void{
		 	this._layer=value;
		 }
		/**
		 * Layer url
		 **/
		public function get url():String{
			return this._url;
		}
		/**
		 * @private
		 * */
		public function set url(value:String):void{
			this._url=value;	
		}
		/**
		 *  Requesting method  POST  or GET   
		 **/
		public function get method():String{
			return this._method;
		}
		/**
		 * @private
		 * */
		public function set method(value:String):void{
			this._method=value;
		}
		
		public function get onComplete():Function{
			return this._onComplete;
		}
		/**
		 * @private
		 * */
		public function set onComplete(value:Function):void{
			this._onComplete=value;
		}
		/**
		 *	Oncomplete function is used to execute a 
		 *  function after a download 
		 * */
		 /**
		 *	onFailure function is used to execute a 
		 *  function after a bad download 
		 **/
		public function get onFailure():Function{
			return this._onfailure;
		}
		/**
		 * @private
		 * */
		public function set onFailure(value:Function):void{
			this._onfailure=value;
		}
		
		/**
		 * Requesting params
		 **/
		public function get params():IHttpParams{
			return this._params;
		}
		/**
		 * @private
		 * */
		public function set params(value:IHttpParams):void{
			 this._params=value;
		}
		/**
		 * alternative url
		 * */
		 public function get altUrl():Array{
		 	return this._altUrl;
		 }
		 /**
		 * @private
		 * */
		 public function set altUrl(value:Array):void{
		 	this._altUrl=value;
		 }
		/**
		 * proxy
		 * */
		 public function get proxy():String{
		 	if(this.layer)
		 		return this.layer.proxy;
		 	else
		 		return null;
		 }
		 
		/**
		 * download authorization
		 * when this is flags is equaled true the layer is allowed to download tile
		 * */
		 public function get isAuthorized():Boolean{
		 	return this._isAuthorized;
		 }
		 /**
		 * @private
		 **/
		public function set isAuthorized(value:Boolean):void{
			this._isAuthorized=value;
		}
	}
}