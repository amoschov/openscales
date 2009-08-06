package org.openscales.fx.Security
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.Container;
	import mx.events.FlexEvent;
	
	import org.openscales.core.security.SecurityConfiguration.LayerSecurity;
	
	
	/**
	 * This class is LayerSecurity wrapper
	 * Layer Security
	 * */
	public class FxSecurity extends Container
	{
		
		
		/**
		 *LayerSecurity 
		 **/
		private var _securityLayer:LayerSecurity;
		
		
		public function FxSecurity()
		{
			 this._securityLayer=new LayerSecurity();
			 this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function onCreationComplete(event:Event):void
		{
			for(var i:int=0; i < this.rawChildren.numChildren ; i++) 
		  	{
		  	 	var child:DisplayObject= this.rawChildren.getChildAt(i);
      	 	 	if(child is FxSecurityParam) this._securityLayer.addSecurityParams((child as FxSecurityParam).securityParams);  	 
			}	
		}
		
		/**
		 * the security layer
		 * */
		 public function get securityLayer():LayerSecurity{
		 	return this._securityLayer;
		 }
		/**
		 *security type 
		 **/
		public function get type():String
		 {
		 	return this._securityLayer.securityType;
		 }
		 /**
		 * @private
		 * */
		public function set type(type:String):void
		 {
		 	this._securityLayer.securityType=type;
		 }
	}
}