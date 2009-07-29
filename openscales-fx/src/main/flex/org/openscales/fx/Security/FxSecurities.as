package org.openscales.fx.Security
{
	import flash.display.DisplayObject;
	
	import mx.core.Container;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.SecurityEvent;
	import org.openscales.core.security.RequestManager;
	/**
	 *This class is use for reassuring of layers 
	 * @author DamienNda 
	 **/
	public class FxSecurities extends Container
	{
		private var _map:Map;
		private var _listSecurity:Array=new Array;
		/**
		 *to create FxSecurities
		 **/
		public function FxSecurities()
		{

		}
		/**
		 * @private
		 * to record securities after we are sure that Fxsecurities creation is completely finished
		 **/
		private function onSetMap():void {
			

		  	for(var i:int=0; i < this.rawChildren.numChildren ; i++) 
		  	{
		  	 	var child:DisplayObject= this.rawChildren.getChildAt(i);
      	 	 	if(child is FxSecurity) _listSecurity.push(child as FxSecurity);    	 
			}
		  	//Securities instanciation
			SecurityInstanciation();
		}
		
		/**
		 *Security instanciation 
		 * @private
		 **/
		private function SecurityInstanciation():void{
			
		 for each(var fxsecurity:FxSecurity in _listSecurity)
		 {
			RequestManager.addSecurityRequester(fxsecurity.type);
			for(var i:int=0;i<=fxsecurity.securedlayers.length-1;i++)
			{
				if(map.getLayerByName(fxsecurity.securedlayers[i])!=null)
				{
				RequestManager.recordSecuritybySecurityType(map.getLayerByName(fxsecurity.securedlayers[i]),fxsecurity.type);
				}
			}
				
		 }
		 this.map.dispatchEvent(new SecurityEvent(SecurityEvent.LOAD_CONF_END));		
		}
		
		
		/**
		 * 
		 * map object
		 **/
 		 public function get map():Map {
      		return this._map;
   		 }
    
   	 	/**
    	* @private
  		**/
  		public function set map(map:Map):void
  		{
  			if(map!=null)
  			{
  				this._map=map;
  				onSetMap();
  			}
  		}		
	}
}