package org.openscales.core.security
{
	import flash.events.EventDispatcher;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.SecurityEvent;
	import org.openscales.core.layer.RequestLayer;
	import org.openscales.core.layer.requesters.ogc.WMSRequest;
	import org.openscales.core.security.SecurityConfiguration.LayerSecurity;
	import org.openscales.core.security.SecurityConfiguration.SecuritiesConfiguration;
	import org.openscales.core.security.SecurityRequesters.AbstractSecurityRequester;
	import org.openscales.core.security.SecurityRequesters.DefaultSecurityRequester;
	import org.openscales.core.security.SecurityRequesters.SecurityRequestersType;
	import org.openscales.core.security.SecurityRequesters.SimpleSecurityRequesters;
	
	/**
	 *This class is used for security management on a layer 
	 * this class is a Singleton
	 * @author DamienNda 
	 **/
	public class SecurityManager
	{
		
		
		/**
		 * @private
		 * security requesters factories
		 * */
		private  var FactorySecurityRequester:HashMap;
		
		/**
		 * @private
		 * The default requester
		 * */
		private  var _defaultRequester:DefaultSecurityRequester=new DefaultSecurityRequester();
		/**
		 * The security configuration
		 **/
		private var _securityConfiguration:SecuritiesConfiguration;
		
		/**
		 * Array of Security Requester
		 **/
		private var _securityRequesters:Array;
		
		private var _numberSecurityInitialized:int=0;
		/**
		 *RequestManager creation
		 **/
		public function SecurityManager(securityConfiguration:SecuritiesConfiguration)
		{
			this._securityConfiguration=securityConfiguration;
			_securityRequesters=new Array();
			FactorySecurityRequester=new HashMap();
			FactorySecurityRequester.put(SecurityRequestersType.simpleDRM,new SimpleSecurityRequesters(this));
		}
		
		/**
		 * This function is to add a securityLayer 
		 * @param securityLayer
		 * */
		public function addSecurityLayer(securityLayer:LayerSecurity):void
		{
			//To test if the security requester really exists
			if(FactorySecurityRequester.getValue(securityLayer.securityType)!=undefined && FactorySecurityRequester.getValue(securityLayer.securityType) is AbstractSecurityRequester){
				(FactorySecurityRequester.getValue(securityLayer.securityType) as AbstractSecurityRequester).addParams(securityLayer.securityParams);				
			}
		}
		
		/**
		 * To update the security requester before 
		 * @param securityLayer
		 * */
		public function updateSecurityRequesterList(securitiesLayers:Array):void
		{
			_securityRequesters=new Array();
			for each(var securityLayer:LayerSecurity in securitiesLayers)
			{
				if(FactorySecurityRequester.getValue(securityLayer.securityType)!=undefined && FactorySecurityRequester.getValue(securityLayer.securityType) is AbstractSecurityRequester){
					//if the security is already in the securityRequester list 
					if(!ExistSecurityRequester(securityLayer.securityType))
					{
					_securityRequesters.push(FactorySecurityRequester.getValue(securityLayer.securityType));					
					}
				}
			}
			
		}
		/**
		 * To know if a securityRequester has been already created
		 * @param security
		 * */
		public function ExistSecurityRequester(securityType:String):Boolean{
			
			for each(var securityRequester:AbstractSecurityRequester in  _securityRequesters)
			{
				if(securityRequester.type==securityType) return true;
			}
			return false;
		}
					
		/**
		 * Execute request from the layer tile 
		 * @param request:RequestLayer
		 **/
		
		public  function getLoader(request:WMSRequest):EventDispatcher
		{
			for each(var securityRequester:AbstractSecurityRequester in _securityRequesters)
			{
				if(securityRequester!=null)
				{
					if(securityRequester.canExecuteRequest(request)) return securityRequester.executeRequest(request);
				}
			
			}
			return _defaultRequester.ExecuteRequest(request);
		}
		
		 /**
		 *This function is directly call when a Security requester is completely initialized  
		 **/
		public function securityLoad(event:SecurityEvent):void
		{
		 	if(event.isAuthorized)
		 	{
		 		if(ExistSecurityRequester(event.securityType))
		 		{
		 			for each(var layer:RequestLayer in this.map.layers){
		 				if((FactorySecurityRequester.getValue(event.securityType) as AbstractSecurityRequester).canExecuteRequest(layer.requester))
		 				{
		 					this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYERS_CONF_END,layer,map.extent));
		 				}
		 			}
		 		
		 		}
		 	}
		}
		//getters &setters
		
		/**
		 * To get the Eventdispatcher In the case of
		 * OpenScales the event dispatcher will be a Map object
		 **/
		 public  function get map():Map
		 {	
		 		return this._securityConfiguration.map;
		 }
		 
		 public function get securityRequesters():Array
		 {
		 	return this._securityRequesters;
		 }
		 public function UpdatenumberSecurityInitialized():void
		 {
		 	this._numberSecurityInitialized=0;
		 }

	}
}