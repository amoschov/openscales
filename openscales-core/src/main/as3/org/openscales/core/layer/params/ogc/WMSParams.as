package org.openscales.core.layer.params.ogc
{
	public class WMSParams extends OGCParams
	{
		
		private var _format:String = null;
		private var _exceptions:String = null;
		private var _layers:String = null;
		private var _styles:String = null;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _transparent:Boolean = false;
		private var _tiled:Boolean = false;
		
		
		public function WMSParams(layers:String, format:String = "image/jpeg", transparent:Boolean = false, 
									tiled:Boolean = false, styles:String = null)
		{
			super("WMS", "1.1.1", "GetMap");
			
			this._exceptions = "application/vnd.ogc.se_inimage";
			
			this._layers = layers;
			this._format = format;
			this._transparent = transparent;
			this._tiled = tiled;
			this._styles = styles;			
			
		}
		
		override public function toGETString():String {
			var str:String = super.toGETString();
			
			if (this._format != null)
				str += "FORMAT=" + this._format + "&";
				
			if (this._exceptions != null)
				str += "EXCEPTIONS=" + this._exceptions + "&";
				
			if (this._layers != null)
				str += "LAYERS=" + this._layers + "&";
				
			if (this._styles != null)
				str += "STYLES=" + this._styles + "&";
				
			str += "WIDTH=" + this._width + "&";
			str += "HEIGHT=" + this._height + "&";
			str += "TILED=" + this._tiled + "&";
			str += "TRANSPARENT=" + this._transparent + "&";
			
			return str.substr(0, str.length-1);
		}
		
	}
}