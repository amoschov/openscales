package org.openscales.core.security.Requesters
{
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	import org.openscales.core.RequestLayer1;
	import org.openscales.core.events.SecurityEvent;
	/**
	 *This class is used as defaultRequester for the security  
	 * @author DamienNda 
	 **/
	public class DefaultRequester
	{
		/**
		 * @private
		 * */
		 private var _map:EventDispatcher;
		/**
		 *Default Requester creation 
		 **/
		public function DefaultRequester()
		{
			
		}
		
		/**
		 *Execute request providing from RequestManager when the layer concerned
		 * by the request has no Security
		 **/
		public function ExecuteRequest(request:RequestLayer1):Loader
		{
			var loader:Loader=new Loader();
			loader.load(new URLRequest(request.getFullRequestSring()));
			return loader;
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
		 	this._map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_LOAD));
		 }
		
	}
}