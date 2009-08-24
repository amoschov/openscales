package org.openscales.fx.security
{
	import mx.core.UIComponent;
	
	import org.openscales.core.Map;
	import org.openscales.core.security.ISecurity;
	/**
	 * Flex Base abstract class for all securities
	 */
	public class FxAbstractSecurity extends UIComponent
	{
		/**
		 * @private
		 * */
		private var _security:ISecurity;
		/**
		 * @private
		 * */
		private var _map:Map=null;
		
		public function FxAbstractSecurity(map:Map=null)
		{
			if(map!=null) this._map=map;
			this.init();
		}
		public function init():void {

   		 }
   		 /**
   		 * Map instance
   		 * */
   		 public function get map():Map{
   		 	return this._map;
   		 }
   		 /**
   		 * @private
   		 * */
   		 public function set map(map:Map):void{
   		 	this._map=map;
   		 }
   		 /**
   		 * Security mecanism used for authentification
   		 * */
   		 protected function get security():ISecurity {
   		 	return this._security;
   		 }
   		 
   		 /**
   		 * @private
   		 * */
   		 protected function set security(value:ISecurity):void{
   		 	this._security=value;
   		 }
	}
}