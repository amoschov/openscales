package org.openscales.core.security.SecurityRequesters
{
	import flash.events.EventDispatcher;
	
	import org.openscales.core.Map;
	import org.openscales.core.layer.requesters.AbstractRequest;
	import org.openscales.core.security.SecurityManager;
	import org.openscales.core.layer.requesters.IRequest;
	/**
	 * This class is an abstract class 
	 * don't instanciate it
	 * directly use the Security Requester
	 * 
	 **/
	public class AbstractSecurityRequester implements ISecurityRequester
	{
		/**
		 *Security Type 
		 * @private
		 **/
		protected var _type:String;
		
		/**
		 * security manager of the sevcurity requester
		 * @private
		 * */
		 private var _securityManager:SecurityManager;
		 
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
		/**
		 * Security Type
		 * read only property
		 * */
		public function get type():String{
			return this._type;
		}
	
		/**
		 * map object is here used as bus event
		 * */
		public function get map():Map{
			return this._securityManager.map;
		}
	}
}