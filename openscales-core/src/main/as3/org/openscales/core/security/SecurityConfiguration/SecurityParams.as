package org.openscales.core.security.SecurityConfiguration
{
	import org.openscales.core.layer.Layer;
	
	public class SecurityParams
	{
		/**
		 *layer concerned by the security param
		 * @private
		 **/
		private var _layer:Layer;
		/**
		 * the key/value cuple of the param
		 * @private
		 **/
		private var _key:String;
		private var _value:String;
		
		/**
		 *To creation a new Security param
		 * @param layer
		 * @param  
		 **/
		public function SecurityParams(layer:Layer=null,key:String=null,value:String=null)
		{
			this._layer=layer;
			this._key=key;
			this._value=value;
		}
		/**
		 *layer concerned by the security param
		 **/
		public function get layer():Layer{
			return this._layer;
		}
		/**
		 * @private
		 * */
		public function set layer(value:Layer):void{
			this._layer=value;
		} 
		/**
		 *param key
		 **/
		public function get key():String{
			return this._key;	
		}
		/**
		 * @private
		 * */
		public function set key(value:String):void{		
		this._key=value;
		}
		/**
		 *param value
		 **/
		public function get value():String{
			return this._value;	
		}
		/**
		 * @private
		 * */
		public function set value(values:String):void{		
		this._value=values;
		}
	}
}