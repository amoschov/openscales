package org.openscales.core.security.SecurityConfiguration
{
	public class LayerSecurity
	{
		/**
		 *Security type 
		 *@private
		 **/		 
		private var _securityType:String;
		
		/**
		 * security param
		 * @private
		 **/
		 private var _securityParams:Array=new Array();
		/**
		 * This class gives a layer security type 
		 * @param securityType
		 * */
		public function LayerSecurity(securityType:String=null,securityParams:Array=null)
		{
			this._securityType=securityType;
			if(securityParams!=null)
			{
				this.addSecuritiesParams(securityParams);
			} 
			
		}
		/**
		 * Security type 
		 **/
		public function get securityType():String{
			return this._securityType;
		}
		/**
		 * @private
		 * */
		public function set securityType(value:String):void{
			this._securityType=value;
		}
		/**
		 * security param
		 **/
		public function get securityParams():Array{
			return this._securityParams;
		}
		/**
		 * To add a security param to a layer security
		 * @param securityparam 
		 * */
		public function addSecurityParams(securityParams:SecurityParams):void
		{
			this._securityParams.push(securityParams);
		}
		/**
		 * To add securities param to a layer security
		 * @param Array of Security param
		 * */
		public function addSecuritiesParams(securitiesParams:Array):void{	
			for each(var securityparam:SecurityParams in securitiesParams)
			{
				this.addSecurityParams(securityparam);
			}
		}
	}
}