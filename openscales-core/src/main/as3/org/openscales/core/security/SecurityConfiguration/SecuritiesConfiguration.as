package org.openscales.core.security.SecurityConfiguration
{
	import org.openscales.core.Map;
	import org.openscales.core.events.SecurityEvent;
	import org.openscales.core.security.SecurityManager;
	/**
	 * This class is used for layer securities configuration
	 * The securities configuration starting with map settings
	 * it's important to set the map before adding all securityLayer instances by addsecurityLayer function
	 * */
	public class SecuritiesConfiguration
	{
		/**
		 * Map object to use it like a bus event
		 * This is the map concerned by the security configuration
		 * @private
		 * */
		private var _map:Map;
		
		/**
		 * The Security Manager
		 * @private
		 **/
		private var _securityManager:SecurityManager;
		
		/**
		 * Securities table
		 **/
		public function SecuritiesConfiguration(map:Map=null)
		{
			this.map=map;
			_securityManager=new SecurityManager(this);
		}
		
		public function get securitymanager():SecurityManager{
			return this._securityManager;
		}
		/**
		 * Map object to use it like a bus event
		 **/
		 public function get map():Map{
		 	return this._map;
		 }
		 /**
		 *@private 
		 **/
		 public function set map(value:Map):void{
		 	if(value!=null)
		 	{		 		
		 		this._map=value;
		 		this.securitymanager.UpdatenumberSecurityInitialized();		
		 		this._map.addEventListener(SecurityEvent.SECURITY_LOAD,_securityManager.securityLoad);		 			 	
		 		this._map.securityConfiguration=this;
		 	}
		 }
		 
		 /**
		 * add Security layer
		 * @param a LayerSecurity
		 **/
		 private function addSecurityLayer(securityLayer:LayerSecurity):void{
		 	
		 	_securityManager.addSecurityLayer(securityLayer);
		 }
		 /**
		 *add securities layer
		 *@param Array of security layer 
		 **/
		 public function addSecuritiesLayer(securitiesLayer:Array):void{
		 	
		 	//We do that here because it's important to know the list of securityRequester 
		 	//implemented in the list providing for the FxSecurities file
		 	_securityManager.updateSecurityRequesterList(securitiesLayer);
		 	
		 	var j:int=0;
		 	for each(var securityLayer:LayerSecurity in securitiesLayer)
		 	{	
		 		//To know if we have to transmit a LayerSecurity
		 		//In the case of there is  a layer security alrea
		 		var transmitSecurity:Boolean=true;
		 		
		 		var i:int=0;	 		
		 		for each(var securityLayerTmp:LayerSecurity in securitiesLayer)
		 		 {		 		 	
		 		 	if(securityLayer!=securityLayerTmp && securityLayer.securityType==securityLayerTmp.securityType){
		 		 		
		 		 		//if there is a layer security having the same type
		 		 		if(j<i)	 securityLayer.addSecuritiesParams(securityLayerTmp.securityParams);
		 		 		
		 		 		else  
		 		 		{
		 		 			transmitSecurity=false;
		 					break;
		 		 		}
		 		 	}
		 		 	i++;
		 		 }
		 		 if(transmitSecurity)this.addSecurityLayer(securityLayer);
		 		 j++;
		 	}
		 }
	}
}