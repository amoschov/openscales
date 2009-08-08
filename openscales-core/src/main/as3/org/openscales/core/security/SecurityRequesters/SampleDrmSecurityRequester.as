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
	import org.openscales.core.security.SecurityManager;
	import org.openscales.core.request.IRequest;
	
	public class SampleDrmSecurityRequester extends AbstractSecurityRequester 
	{		
		public static const TYPE:String = "SampleDrm";
		
		public function SampleDrmSecurityRequester(securityManager:SecurityManager)
		{
			super(securityManager);
		}
		/**
		 *@inherited
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
		 /**
		 *@inherited 
		 **/
		override public function canExecuteRequest(request:IRequest):Boolean
		 {
		 	return true;
		 }
		 /**
		 * @inherited
		 * */
		override  public function addParams(params:Array):void
		 {
		 	this.map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_LOAD,this.type,true));
		 }
		 override public function get type():String{
			return TYPE;
		 }
	}
}