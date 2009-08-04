package org.openscales.fx.Security
{
	import mx.core.UIComponent;
	
	
	
	/**
	 * This class has a hashmap format
	 * 
	 **/
	public class FxSecurityParam extends UIComponent
	{
		/**
		 *@private 
		 **/
		private var _key:String="";
		/**
		 *@private 
		 **/
		private var _value:String="";
		
		public function FxSecurityParam(key:String=null,value:String=null)
		{
			this._key=key;
			this._value=value;
		}
		/**
		 * the key
		 * */
		public function get key():String{
			return this._key;
		}
		/**
		 * @private
		 * */
		 public function set key(Key:String):void
		 {
		 	this._key=Key;
		 }
		 /**
		 * the value
		 **/
		public function get value():String{
			return this._value;
		}
		/**
		 * @private
		 * */
		 public function set value(Value:String):void
		 {
		 	 this._value=Value;
		 }
	}
}