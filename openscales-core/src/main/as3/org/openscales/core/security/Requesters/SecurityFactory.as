package org.openscales.core.security.Requesters
{
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.security.SecurityType;
	
	public class SecurityFactory
	{
		/**
		 * @private
		 * security requesters factories
		 * */
		private static var Factory:HashMap=new HashMap();
		Factory.put(SecurityType.IgnGeoDrm,new GeoIgnSecurityRequester());
		
		/**
		 * security list
		 * */
		private static var _listSecurityRequesters:Array=new Array();
		
		public function SecurityFactory()
		{
		}
		/**
		 * this static function is used for adding
		 * new security requester in the requesterManager security requester table
		 * @param securityType:  the type of requester
		 * @return the position orf the securityRequester in the securityRequester table
		 **/
		public static function addSecurity(securityType:String,params:HashMap=null):void
		{

			if(SecurityFactory.Factory.getValue(securityType)!=undefined && !SecurityFactory.isAlreadyCreated(securityType))
			{
			SecurityFactory._listSecurityRequesters.push(SecurityFactory.Factory.getValue(securityType));
			}
			(SecurityFactory.Factory.getValue(securityType) as ISecurityRequester).addParams(params);
		}
		/**
		 *To get the security requester list 
		 * 
		 **/
		public static function get listSecurity():Array
		{
			return SecurityFactory._listSecurityRequesters;
		}
		/**
		 * To know if a security requester has been created
		 * @param securitytype the security type
		 * @private
		 **/
		private static function isAlreadyCreated(securityType:String):Boolean{
			for(var i:int=0;i<SecurityFactory.listSecurity.length;i++){
				var b:String=Factory.getKey(SecurityFactory.listSecurity[i]);
				if(Factory.getKey(SecurityFactory.listSecurity[i])!=null) return true;
			}
			return false;
		}
		
	}
}