package org.openscales.core.request
{
	import flash.events.EventDispatcher;
	import org.openscales.core.layer.RequestLayer;
	
	/**
	 * This class is an interface for request layers
	 * @author damienNda 
	 **/
	public interface IRequest
	{
		
		/**
		 * layer concerned by the request
		 **/
		 function get layer():RequestLayer;
		 function set layer(value:RequestLayer):void;
		 
		 function set isAuthorized(value:Boolean):void;
		 function get isAuthorized():Boolean;
		
		function executeRequest():EventDispatcher;
	}
}