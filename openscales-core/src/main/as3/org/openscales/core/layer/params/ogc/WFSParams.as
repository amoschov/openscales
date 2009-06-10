package org.openscales.core.layer.params.ogc
{
	public class WFSParams extends OGCParams
	{
		
		private var _typename:String;
		private var _maxFeatures:Number;
		private var _handle:String;
		
		
		
		public function WFSParams(typename:String)
		{
			super("WFS", "1.0.0", "GetFeature");
			
			this._typename = typename;
		}
		
		override public function toGETString():String {
			var str:String = super.toGETString();
			
			if (this._typename != null)
				str += "TYPENAME=" + this._typename + "&";
				
			if (this._maxFeatures >= 0)
				str += "MAXFEATURES=" + this._maxFeatures + "&";
				
			if (this._handle != null)
				str += "HANDLE=" + this._handle + "&";
			
			return str.substr(0, str.length-1);
		}
		
		
		// Getters & setters
		public function get typename():String {
			return _typename;
		}

		public function set typename(typename:String):void {
			_typename = typename;
		}

		public function get maxFeatures():Number {
			return _maxFeatures;
		}

		public function set maxFeatures(maxFeatures:Number):void {
			_maxFeatures = maxFeatures;
		}

		public function get handle():String {
			return _handle;
		}

		public function set handle(handle:String):void {
			_handle = handle;
		}
		
	}
}