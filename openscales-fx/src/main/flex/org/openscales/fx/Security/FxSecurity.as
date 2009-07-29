package org.openscales.fx.Security
{
	import mx.core.UIComponent;
	
	
	/**
	 * 
	 * Layer Security
	 * */
	public class FxSecurity extends UIComponent
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
		
		
		public function FxSecurity()
		{
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
		 *secure type 
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
	}
}