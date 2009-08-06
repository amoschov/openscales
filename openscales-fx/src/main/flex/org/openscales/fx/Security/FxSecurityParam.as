package org.openscales.fx.Security
{
	import mx.core.UIComponent;
	
	import org.openscales.core.layer.Layer;
	import org.openscales.core.security.SecurityConfiguration.SecurityParams;
	
	
	
	/**
	 * This class is a wrapper of security param
	 * 
	 **/
	public class FxSecurityParam extends UIComponent
	{
		/**
		 * @private
		 * The security param
		 * */
		private var _securityParams:SecurityParams;
		public function FxSecurityParam()
		{
			_securityParams=new SecurityParams();
		}
		public function get securityParams():SecurityParams{
			return this._securityParams;
		}
		
		/**
		 *security layer 
		 **/
		 public function get layer():Layer{
		 	return this._securityParams.layer;
		 }
		 /**
		 * @private
		 **/
		 public function set layer(layer:Layer):void{
		 this._securityParams.layer=layer;	
		 }
		/**
		 * security key
		 * */
		public function get key():String{
			return this._securityParams.key;
		}
		/**
		 * @private
		 * */
		 public function set key(Key:String):void
		 {
		 	this._securityParams.key=Key;
		 }
		 /**
		 * security value
		 **/
		public function get value():String{
			return this._securityParams.value;
		}
		/**
		 * @private
		 * */
		 public function set value(Value:String):void
		 {
		 	 this._securityParams.value=Value;
		 }
	}
}