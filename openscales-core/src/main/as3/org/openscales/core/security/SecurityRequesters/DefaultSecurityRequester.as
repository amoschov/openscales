package org.openscales.core.security.SecurityRequesters
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.openscales.core.events.SecurityEvent;
	import org.openscales.core.layer.requesters.AbstractRequest;
	import org.openscales.core.layer.requesters.ogc.WMSRequest;
	import org.openscales.core.layer.requesters.IRequest;
	/**
	 *This class is used as defaultRequester for the security  
	 * @author DamienNda 
	 **/
	public class DefaultSecurityRequester
	{
		/**
		 * @private
		 * */
		 private var _map:EventDispatcher;
		/**
		 *Default Requester creation 
		 **/
		public function DefaultSecurityRequester()
		{
			
		}
		
		/**
		 *Execute request providing from RequestManager when the layer concerned
		 * by the request has no Security
		 **/
		public function executeRequest(request:IRequest):EventDispatcher
		{
			if(request is WMSRequest) return this.wmsTreatment(request as WMSRequest);
			return null;
		}
		
		public function wmsTreatment(request:WMSRequest):EventDispatcher{
			
			if(request.onComplete!=null)
				{
					request.loader=new Loader();
					(request.loader as Loader).name=request.getUrl();
					(request.loader as Loader).contentLoaderInfo.addEventListener(Event.COMPLETE,request.onComplete,false, 0, true);
				
					if(request.onFailure!=null){
					(request.loader as Loader).contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, request.onFailure, false, 0, true);
					}
					(request.loader as Loader).load(new URLRequest(request.getUrl()));
					return request.loader as Loader;			
				}
				return null;
		}
		
		
		//getters & setters
		/**
		 * To get the Eventdispatcher In the case of
		 * OpenScales the event dispatcher will be a Map object
		 **/
		 public  function get map():EventDispatcher
		 {	
		 		return this._map;
		 }
		 /**
		 * @private
		 * */
		 public function set map(eventDispatcher:EventDispatcher):void
		 {
		 	this._map=eventDispatcher;
		 	//this._map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_LOAD));
		 }
		
	}
}