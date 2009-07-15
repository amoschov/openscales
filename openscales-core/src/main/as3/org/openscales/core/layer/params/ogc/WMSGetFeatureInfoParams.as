package org.openscales.core.layer.params.ogc
{
	public class WMSGetFeatureInfoParams extends OGCParams
	{
				
		private var _format:String;
		private var _exceptions:String;
		private var _layers:String;
		private var _query_layers:String;
		private var _styles:String;
		private var _width:Number;
		private var _height:Number;
		private var _maxFeatures:Number;
		private var _x:Number;
		private var _y:Number;
		private var _srs:String;
		
		
		public function WMSGetFeatureInfoParams(layers:String, format:String = "text/xml", styles:String = null)
		{
			super("WMS", "1.1.1", "GetFeatureInfo");
			
			this._exceptions = "application/vnd.ogc.se_inimage";
			
			this._layers = layers;
			this._query_layers = layers;
			this._format = format;
			this._styles = styles;			
			
		}
		
		override public function toGETString():String {
			var str:String = super.toGETString();
			
			if (this._format != null)
				str += "INFO_FORMAT=" + this._format + "&";
				
			if (this._exceptions != null)
				str += "EXCEPTIONS=" + this._exceptions + "&";
				
			if (this._layers != null)
				str += "LAYERS=" + this._layers + "&";
				
			if (this._query_layers != null)
				str += "QUERY_LAYERS=" + this._layers + "&";
				
			if (this._styles != null)
				str += "STYLES=" + this._styles + "&";
			else
				str += "STYLES=&";
				
			if (this._srs != null)
				str += "SRS=" + this._srs + "&";
				
			str += "X=" + this._x + "&";
			str += "Y=" + this._y + "&";
				
			str += "WIDTH=" + this._width + "&";
			str += "HEIGHT=" + this._height + "&";
			str += "FEATURE_COUNT=" + this._maxFeatures + "&";
			
			return str.substr(0, str.length-1);
		}
		
		
		//Getters & setters
		public function get format():String {
			return _format;
		}

		public function set format(format:String):void {
			_format = format;
		}

		public function get exceptions():String {
			return _exceptions;
		}

		public function set exceptions(exceptions:String):void {
			_exceptions = exceptions;
		}

		public function get layers():String {
			return _layers;
		}

		public function set layers(layers:String):void {
			_layers = layers;
		}

		public function get styles():String {
			return _styles;
		}

		public function set styles(styles:String):void {
			_styles = styles;
		}

		public function get width():Number {
			return _width;
		}

		public function set width(width:Number):void {
			_width = width;
		}

		public function get height():Number {
			return _height;
		}

		public function set height(height:Number):void {
			_height = height;
		}

		public function get maxFeatures():Number {
			return _maxFeatures;
		}

		public function set maxFeatures(maxFeatures:Number):void {
			_maxFeatures = maxFeatures;
		}

		public function get x():Number {
			return _x;
		}

		public function set x(x:Number):void {
			_x = x;
		}

		public function get y():Number {
			return _y;
		}

		public function set y(y:Number):void {
			_y = y;
		}
		
	}
}