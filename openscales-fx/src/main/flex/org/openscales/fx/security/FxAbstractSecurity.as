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
	
		private var _map:Map=null;
		
		private var _layers:String=null;
		
		public function FxAbstractSecurity()
		{
			
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
   		 public function get security():ISecurity {
   		 	return null;
   		 }
   		 
   		 /**
   		  * Name of layers that use this Security manager, separated by commas
   		  */ 
   		 public function set layers(value:String):void {
			 this._layers = value;
		  }
		  
		  public function get layers():String {
   		 	return this._layers;
   		 }
	}
}