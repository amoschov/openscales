package org.openscales.core.request
{
	import flash.events.EventDispatcher;
	
	import org.openscales.core.layer.RequestLayer;
	import org.openscales.core.layer.params.IHttpParams;
	
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
		 
		 function get url():String;
		 function set url(value:String):void;
		 
		 /**
		  * alternative url
		  **/
		 function get altUrl():Array;
		 function set altUrl(value:Array):void;
		 
		 function set isAuthorized(value:Boolean):void;
		 function get isAuthorized():Boolean;
		 
		 function get onComplete():Function;
		 function set onComplete(value:Function):void;
		 
		 function get onFailure():Function;
		 function set onFailure(value:Function):void;
		 
		 function get params():IHttpParams;
		 function set params(value:IHttpParams):void;
		 
		 /**
		  *  Requesting method  POST  or GET   
		  **/
		 function set method(value:String):void
		 function get method():String;
		
		 function executeRequest():EventDispatcher;
	}
}