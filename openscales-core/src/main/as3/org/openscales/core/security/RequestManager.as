package org.openscales.core.security
{
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	
	import org.openscales.core.RequestLayer1;
	import org.openscales.core.events.SecurityEvent;
	import org.openscales.core.security.Requesters.DefaultRequester;
	import org.openscales.core.security.Requesters.ISecurityRequester;
	import org.openscales.core.security.Requesters.ReqManagerFactory;
	import org.openscales.core.security.Requesters.SecurityFactory;
	
	/**
	 *This class is used for security management on a layer 
	 * this class is a Singleton
	 * @author DamienNda 
	 **/
	public class RequestManager
	{
		/**
		 * @private
		 * */
		 private var _map:EventDispatcher;
		/**
		 * @private
		 * */
		private  var _defaultRequester:DefaultRequester=new DefaultRequester();
		
		private var _numberSecurityInitialized:int=0;
		/**
		 *RequestManager creation
		 **/
		public function RequestManager(map:EventDispatcher=null)
		{
			if(this._map!=null)
			{
			this.map=map;
			this.map.addEventListener(SecurityEvent.SECURITY_LOAD,this.SecurityRequesterIsInitialized);
			}
		}
		
		/**
		 * Execute request from the layer tile 
		 * @param request:RequestLayer
		 **/
		
		public  function getLoader(request:RequestLayer1):Loader
		{
		
			 for(var i:int=0;i<=ReqManagerFactory.requestManager.securityRequesters.length-1;i++)
			 {
			 	var securityRequester:ISecurityRequester=ReqManagerFactory.requestManager.securityRequesters[i];
			 	if(securityRequester!=null)
			 	{
			 		if(securityRequester.canExecuteRequest(request)) return securityRequester.executeRequest(request);
			 	}
			 }
			 return ReqManagerFactory.requestManager._defaultRequester.ExecuteRequest(request);
		}
		
		 /**
		 *This function is directly call when a Security requester is completely initialized  
		 **/
		 public function SecurityRequesterIsInitialized(securityEvent:SecurityEvent):void{
		 	
		 	_numberSecurityInitialized++;
		 	//there is also the defaultRequester
		 	if(_numberSecurityInitialized==this.securityRequesters.length+1)
		 	{
		 		this._map.dispatchEvent(new SecurityEvent(SecurityEvent.LOAD_CONF_END));
		 		this._map.removeEventListener(SecurityEvent.SECURITY_LOAD,ReqManagerFactory.requestManager.SecurityRequesterIsInitialized);	
		 	}
		 }
		
		//getters &setters
		/**
		 *to get all Security requester 
		 **/
		public  function get securityRequesters():Array
		{
			return SecurityFactory.listSecurity;
		}
		
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
		 	this._map.addEventListener(SecurityEvent.SECURITY_LOAD,ReqManagerFactory.requestManager.SecurityRequesterIsInitialized);		
		 	this._defaultRequester.map=eventDispatcher;
		 }

	}
}