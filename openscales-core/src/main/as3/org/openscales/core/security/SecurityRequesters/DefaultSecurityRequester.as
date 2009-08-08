package org.openscales.core.security.SecurityRequesters
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.openscales.core.events.SecurityEvent;
	import org.openscales.core.request.AbstractRequest;
	import org.openscales.core.request.ogc.WMSRequest;
	import org.openscales.core.request.IRequest;
	import org.openscales.core.security.SecurityManager;
	/**
	 *This class is used as defaultRequester for the security  
	 * @author DamienNda 
	 **/
	public class DefaultSecurityRequester extends AbstractSecurityRequester
	{
		public static const TYPE:String = "Default";

		/**
		 *Default Requester creation 
		 **/
		public function DefaultSecurityRequester(securityManager:SecurityManager=null)
		{
			super(securityManager);
		}
		
		/**
		 *Execute request providing from RequestManager when the layer concerned
		 * by the request has no Security
		 **/
		override public function executeRequest(request:IRequest):EventDispatcher
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
		
		
		 override public function get type():String{
			return TYPE;
		 }
		
	}
}