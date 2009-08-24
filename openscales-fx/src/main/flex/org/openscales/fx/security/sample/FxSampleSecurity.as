package org.openscales.fx.security.sample
{
	import org.openscales.core.Map;
	import org.openscales.core.security.sample.SampleSecurity;
	import org.openscales.fx.security.FxAbstractSecurity;
	
	/**
	 * This class is an flex example for the security
	 * */
	public class FxSampleSecurity extends FxAbstractSecurity
	{
		private var _login:String;
		private var _password:String;
		public function FxSampleSecurity(map:Map=null,login:String=null,password:String=null)
		{			
			super(map);
			security=new SampleSecurity(map,login,password);
		}
		/**
		 * login used for authentification
		 * */
		public function get login():String{
			return this._login;	
		}
		/**
		 * @private
		 * */
		public function set login(value:String):void{
			this._login=value;
		}
		/**
		 * password
		 * */
		public function get password():String{
			return this._password;
		}
		/**
		 * @private
		 * */
		public function set password(value:String):void{
			this._password=value;
		}
	}
}