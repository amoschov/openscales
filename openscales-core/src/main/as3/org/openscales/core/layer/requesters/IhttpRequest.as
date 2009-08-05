package org.openscales.core.layer.requesters
{
	import flash.events.EventDispatcher;
	
	/**
	 *This class is an Interface for layers http Request
	 *@author damienNda 
	 **/
	public interface IhttpRequest
	{
		
		function executeRequest():EventDispatcher;
	}
}