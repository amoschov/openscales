package org.openscales.core.security.SecurityRequesters
{
	import flash.events.EventDispatcher;
	
	import org.openscales.core.layer.requesters.AbstractRequest;
	import org.openscales.core.layer.requesters.IRequest;
	/**
	 *This class is used as Interface  for all security requsters  
	 * @author DamienNda 
	 **/
	public interface ISecurityRequester
	{
		
		/**
		 *execution of request providing from the RequestManager
		 * @param the requesting object
		 **/
		 function executeRequest(request:IRequest):EventDispatcher;
		 /**
		 * To know if  a layer is abble to execute a request providing from the requestManager
		 * @param the requesting object 
		 **/
		 function canExecuteRequest(request:IRequest):Boolean;
		 
		 /**
		 * The params are a cuple value\key which contain attributes like layer
		 * and securities informations
		 * */
		 function addParams(params:Array):void;
	}
}