package org.openscales.fx.Security
{
	import flash.display.DisplayObject;
	
	import mx.core.Container;
	
	import org.openscales.core.Map;
	import org.openscales.core.security.SecurityConfiguration.SecuritiesConfiguration;
	/**
	 *This class is a wrapper of SecuritiesConfiguration as 3 classes 
	 * @author DamienNda 
	 **/
	public class FxSecurities extends Container
	{
		/**
		 * securities configuration Object 
		 **/
		private var _securitiesConfiguration:SecuritiesConfiguration;
		
		/**
		 *to create FxSecurities
		 **/
		public function FxSecurities()
		{
			this._securitiesConfiguration=new SecuritiesConfiguration();
		}
		/**
		 * map object is used hear as  bus event
		 * */
		public function get map():Map
		{
			return this._securitiesConfiguration.map; 
		}
		/**
		 * @private
		 * */
		 public function set map(map:Map):void{
		 	if(map!=null){		 	
		 	this._securitiesConfiguration.map=map;	
		 	onSetMap(); 	
		 	}
		 }
		 private function onSetMap():void {
			
			var securityLayers:Array=new Array();
		  	for(var i:int=0; i < this.rawChildren.numChildren ; i++) 
		  	{
		  	 	var child:DisplayObject= this.rawChildren.getChildAt(i); 
      	 	 	if(child is FxSecurity) securityLayers.push((child as FxSecurity).securityLayer);   	 
			}
			_securitiesConfiguration.addSecuritiesLayer(securityLayers);

		}
	}
}