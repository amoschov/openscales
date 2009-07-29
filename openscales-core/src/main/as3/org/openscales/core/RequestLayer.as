package org.openscales.core
{
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.params.IHttpParams;
	
	/**
	 *this class is use for layers requesting 
	 * @author DamienNda 
	 **/
	public class RequestLayer 
	{
	
		
		/**
		 * @private
		 * layer concerned by the request  
		 **/ 
		private var _layer:Layer;
		
		/**
		 * @private
		 * the requesting url
		 **/
		private var _url:String;
		
		/**
		 *@private 
		 * the alternative requesting url
		 **/
		private var _altUrls:Array;
		/**
		 * @private
		 * requesting params depending of the service(WMS,WFS)
		 **/
		private var _params:IHttpParams;
		/**
		 * @private
		 * the request submission method  
		 * */
		private var _method:String=null;
		/**
		 * @private
		 * Oncomplete function is executed when the request is completely finished
		 * */
		private var _onComplete:Function = null;
	
		/**
		 * create a requestlayer
		 * @param url the requesting url
		 * @param params the requesting params of the request
		 * @param method the request submission method
		 * @param onComplete  this function is executed when the request is completely finished
		 **/
		public function RequestLayer(url:String,params:IHttpParams,layer:Layer,method:String=null,onComplete:Function=null,altUrls:Array=null,map:Map=null)
		{
			this._url=url;
			this._altUrls=altUrls;
			this._method=method;
			this._params=params;
			this._layer=layer;
			this._onComplete=onComplete;
		}
	
		/**
		 * Combine url with layer's params and these newParams.
		 * to have the real request url
		 * @return 
		 **/
		 public function getFullRequestSring():String
		 {
		 	if(this._url.indexOf("?")==-1) return this._url+"?"+this._params.toGETString();
		 	else return this._url+"&"+this._params.toGETString();
		 }
		 
		/**
		* is used for default srs projection 
		**/ 
		public function get layer():Layer
		{
			return this._layer;
		} 
		/**
		 * @private
		 **/
		 public function set layer(layer:Layer):void
		 {
		 	this._layer=layer;
		 } 
		/**
		 * requesting params depending of the service(WMS,WFS)
		 * */
		public function get url():String
		{
			return this._url;
		}
		/**
		 * @private
		 **/
		public function set url(url:String):void
		{
			this._url=url;	
		}
		/**
		 * alternative url
		 * */
		 public function get altUrls():Array
		 {
		 	return this._altUrls;
		 }
		 /**
		 * @private
		 * */
		 public function set altUrls(alturls:Array)
		 {
		 	this._altUrls=alturls;
		 }
		/**
		 * requesting params depending of the service(WMS,WFS)
		 * */
		public function get params():IHttpParams
		{
			return this._params;
		}
		/**
		 * @private
		 **/
		public function set params(params:IHttpParams):void
		{
			this._params=params;
		}
		/**
		 * the request submission method 
		 * @default null
		 * */
		public function get method():String
		{
			return this._method;
		}
		/**
		 * @private
		 **/
		public function set method(method:String):void
		{
			this._method=method;
		}
		/**
		 * Oncomplete function is executed when the request is completely finished
		 * @default null
		 * */
		public function get onComplete():Function
		{
			return this._onComplete;
		}
		/**
		 * @private
		 **/
		public function set onComplete(onComplete :Function):void
		{
			this._onComplete=onComplete;
		}
	
	}
}