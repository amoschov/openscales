package org.openscales.core.security.Requesters
{
	import flash.display.Loader;
	
	import org.openscales.core.RequestLayer1;
	import org.openscales.core.basetypes.maps.HashMap;
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
		 function executeRequest(request:RequestLayer1):Loader;
		 /**
		 * To know if  a layer is abble to execute a request providing from the requestManager
		 * @param the requesting object 
		 **/
		 function canExecuteRequest(request:RequestLayer1):Boolean;
		 
		 /**
		 * The params are a cuple value\key which contain attributes like layer
		 * and securities informations
		 * */
		 function addParams(params:HashMap):void;
	}
}