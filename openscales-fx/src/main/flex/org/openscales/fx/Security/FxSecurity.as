package org.openscales.fx.Security
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.Container;
	import mx.events.FlexEvent;
	
	import org.openscales.core.basetypes.maps.HashMap;
	
	
	/**
	 * 
	 * Layer Security
	 * */
	public class FxSecurity extends Container
	{
		/**
		 * @private
		 *secured layers name list  
		 **/
		private var _listLayers:Array=new Array();
		/**
		 * @private
		 *secure type 
		 **/
		private var _type:String;
		
		private var _params:HashMap=new HashMap();
		
		public function FxSecurity()
		{
			 this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function onCreationComplete(event:Event):void
		{
			for(var i:int=0; i < this.rawChildren.numChildren ; i++) 
		  	{
		  	 	var child:DisplayObject= this.rawChildren.getChildAt(i);
      	 	 	if(child is FxSecurityParam) this._params.put((child as FxSecurityParam).key,(child as FxSecurityParam).value);    	 
			}	
			var a:String=params.getValue("dzzd");
		}
		/**
		 * secured layers list
		 * for mxml access to the listlayers property
		 * because mxml also use String class  
		 **/
		public function get listLayers():String
		{
			var returnChain:String="";
			for(var i:int=0;i<=this._listLayers.length-1;i++)
			{
				if(i==this._listLayers.length-1) returnChain=returnChain+this._listLayers[i];
				else returnChain=returnChain+this._listLayers[i]+",";
			}
			return returnChain;
		}
		/**
		 * @private
		 **/
		public function set listLayers(listlayers:String):void
		{
			this._listLayers=(listlayers as String).split(",");
		}
		
		/**
		 * secured layers list
		 * for As3 access to the listlayers property
		 **/
		public function get securedlayers():Array
		{
			return this._listLayers;
		}
		
		/**
		 *security type 
		 **/
		public function get type():String
		 {
		 	return this._type;
		 }
		 /**
		 * @private
		 * */
		public function set type(type:String):void
		 {
		 	this._type=type;
		 }
		 /**
		 * Security params
		 **/
		 public function get params():HashMap{
		 	return this._params;
		 }
		 public function set params(Params:HashMap):void{
		 	this._params=Params;
		 }
	}
}