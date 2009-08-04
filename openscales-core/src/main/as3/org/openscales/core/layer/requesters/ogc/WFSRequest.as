package org.openscales.core.layer.requesters.ogc
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Trace;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.params.AbstractParams;
	import org.openscales.core.layer.params.ogc.WFSParams;
	import org.openscales.core.layer.requesters.IhttpRequest;

	/**
	 * This class is for WFS request Execution 
 	**/
	public class WFSRequest extends OGCRequest implements IhttpRequest
	{
		//this object represents a datas of a POST request 
		/**
		 *@private 
		 **/
		private var _postbody:Object;
		
		public function WFSRequest(layer:Layer,url:String, method:String, params:WFSParams, oncomplete:Function=null, loader:EventDispatcher=null)
		{
			//WFS directly downloads data or textual response
			//For it we use an URLLoader			
			super(layer,url, method, params, oncomplete,new URLLoader());
		}
		/**
		 * @inherited
		 * */
		override public function executeRequest():void
		{	

		    try {
			 if (this.onComplete != null) {
		      var body:Object= this.postbody;
		      
		      if (body) {
		      	this.method = URLRequestMethod.POST;
		      	
		      	if ((params as AbstractParams).bbox!=null) {
		      		var bbox:String = (params as AbstractParams).bbox;
		      		body.*::Query.*::Filter.*::And.*::BBOX.*::Box.*::coordinates = bbox;
		      		url = url.split("?")[0];
		      	}
		      }

		      Trace.info(this.url);
		      
		      if (this.method == URLRequestMethod.GET && params!=null)
		        this.url += (this.url.match(/\?/) ? '&' : '?') + params.toGETString();

		      if ((proxy != null) && (proxy != "")) {
		      	this.url = proxy + encodeURIComponent(this.url);
		      }
		      this.loader = new URLLoader();
			  

		      var urlRequest:URLRequest = new URLRequest(this.url);
		      urlRequest.method = this.method;

			  if (this.method == URLRequestMethod.POST) {
		      		urlRequest.data = body;
		      		urlRequest.contentType = "application/xml";
		      }

		     
		      this.loader.addEventListener(Event.COMPLETE, this.onComplete);
		      	
		      
			  (this.loader as URLLoader).load ( urlRequest );

			}
		    } catch (e:Error) {
		      Trace.error(e.message);
		    }
		}
		/**
		 * this object represents a datas of a POST request 
		 * */
		public function get postbody():Object
		{
			return this._postbody;
		}
		public function set postbody(value:Object):void
		{
			this._postbody=value;
		}
		
	}
}