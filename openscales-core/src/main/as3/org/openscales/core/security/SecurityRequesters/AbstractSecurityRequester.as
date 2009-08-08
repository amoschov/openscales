package org.openscales.core.security.SecurityRequesters
{
	import flash.events.EventDispatcher;
	
	import org.openscales.core.Map;
	import org.openscales.core.request.AbstractRequest;
	import org.openscales.core.security.SecurityManager;
	import org.openscales.core.request.IRequest;
	/**
	 * This class is an abstract class 
	 * don't instanciate it
	 * directly use the Security Requester
	 * 
	 **/
	public class AbstractSecurityRequester implements ISecurityRequester
	{
		
		/**
		 * security manager of the sevcurity requester
		 * @private
		 * */
		 private var _securityManager:SecurityManager;
		 
		/**
		 * @private
		 * */
		 private var _map:EventDispatcher;
		 
		public function AbstractSecurityRequester(securityManager:SecurityManager)
		{
			this._securityManager=securityManager;
		}

		public function executeRequest(request:IRequest):EventDispatcher
		{
			return null;
		}
		
		public function canExecuteRequest(request:IRequest):Boolean
		{
			return false;
		}
		
		public function addParams(params:Array):void
		{
		}

		static public function get type():String{
			return "";
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
		 }
		 
		 public function get type():String{
			return "";
		 }
	
	}
}