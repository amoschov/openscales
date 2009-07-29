package org.openscales.core.security
{
	import org.openscales.core.RequestLayer;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.security.Requesters.DefaultRequester;
	import org.openscales.core.security.Requesters.GeoIgnSecurityRequester;
	import org.openscales.core.security.Requesters.ISecurityRequester;
	
	/**
	 *This class is used for security management on a layer 
	 * this class is a Singleton
	 * @author DamienNda 
	 **/
	public class RequestManager
	{
		/**
		 * @private
		 * security requesters factories
		 * */
		private static var securityFactory:HashMap=new HashMap();
		securityFactory.put(SecurityType.DefaultRequester,new DefaultRequester());
		securityFactory.put(SecurityType.IgnGeoDrm,new GeoIgnSecurityRequester());
		
		/**
		 * @private		 
		 **/
		private static var _securityRequesters:Array=new Array(new DefaultRequester());

		/**
		 *RequestManager creation
		 **/
		public function RequestManager()
		{
		}
		
		/**
		 *  Layer Authentification 
		 * The layer reference is in request object
		 * @param layer: layer concerned by the authentification operation
		 * @param request: the request object
		 **/
		public static function Authentificate(request:RequestLayer):void
		{
			var securityRequester:ISecurityRequester=RequestManager.getSecurityRequesterByLayer(request.layer);
			if(securityRequester!=null)
			{
				securityRequester.AuthentificateLayer(request);
			}
			else
			{
				/*
				To choose a requester by default
				for example we can  choose a requester by layer url consequently url DNS
				*/
				var defaultRequester:ISecurityRequester=RequestManager.getDefaultRequester();
				defaultRequester.addsecuredLayer(request.layer);
				defaultRequester.AuthentificateLayer(request);
			}
		}
		/**
		 * this static function is used for adding
		 * new security requester in the requesterManager security requester table
		 * @param securityType:  the type of requester
		 * @return the position orf the securityRequester in the securityRequester table
		 **/
		public static  function addSecurityRequester(securityType:String):int
		{
			var index:int=-1;
			if(!RequestManager.ExistSecurityRequester(securityType))
			{
				var securityrequester:ISecurityRequester=RequestManager.securityFactory.getValue(securityType);
			
				if(securityrequester!=null)
				{
			 	index=RequestManager._securityRequesters.push(securityrequester);
				}
			}
			return index;
		}
		
		/**
		 *  To record a security on a layer by the securitytype
		 * @param layer reference
		 * @param security type
		 **/
		public static function recordSecuritybySecurityType(layerRefId:Layer,securityType:String):void
		{
			var securityrequester:ISecurityRequester=RequestManager.getSecurityRequesterByType(securityType);
			if(securityrequester!=null) securityrequester.addsecuredLayer(layerRefId);
			//else we use default requester
			else RequestManager.getDefaultRequester().addsecuredLayer(layerRefId);
		}
		/**
		 *To get security Requester from security type
		 * @private
		 * @param  the security type
		 * @return the security requester
		 **/
		 private static function getSecurityRequesterByType(securityType:String):ISecurityRequester
		 {
		 	for each(var securityRequester:ISecurityRequester in _securityRequesters)
		 	{
		 		if((securityRequester as DefaultRequester).type==securityType) return securityRequester;	
		 	}
		 	return null;
		 	//else it's also possible to return DefaultRequester
		 	//return getSecurityRequesterByType(SecurityType.DefaultRequester);
		 	
		 }
		 /**
		 *To get security Requester from security type
		 * @private
		 * @param  a securized layer
		 * @return the security requester
		 **/
		 private static function getSecurityRequesterByLayer(layer:Layer):ISecurityRequester
		 {
		 	
		 	for each(var securityRequester:ISecurityRequester in _securityRequesters)
		 	{
		 		//we use defaultrequester because all requesters extend DefaultRequester
		 		for(var i:int=0;i<=(securityRequester as DefaultRequester).listLayer.length-1;i++)
		 		{
		 			if((securityRequester as DefaultRequester).listLayer[i]==layer)
		 			{
		 				return securityRequester;
		 			}
		 		}
		 	}
		 	return null;
		 }
		 /**
		 *To get security Requester from security type
		 * @private
		 * @param  layer index
		 * @return the security requester
		 **/
		 private static function getSecurityRequesterByIndex(index:int):ISecurityRequester
		 {
		 	if(_securityRequesters[index]!=undefined) return _securityRequesters[index];
		 	return null;
		 }
		 /**
		 *To get default requester 
		 * @private
		 **/
		 private static function getDefaultRequester():ISecurityRequester
		 {
		 	return RequestManager.getSecurityRequesterByType(SecurityType.DefaultRequester);
		 }
		 /**
		 * To know if the securityRequest already exists in  the security request list
		 * */
		 private static function ExistSecurityRequester(securityType:String)
		 {
		 	for each(var securityRequester:ISecurityRequester in _securityRequesters)
		 	{
		 		//All security requester extend default Requester
		 		if((securityRequester as DefaultRequester).type==securityType) return true;
		 	}
		 	return false;
		 }
	}
}