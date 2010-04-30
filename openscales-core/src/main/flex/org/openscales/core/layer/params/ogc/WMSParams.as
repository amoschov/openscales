package org.openscales.core.layer.params.ogc
{
	import org.openscales.core.layer.params.IHttpParams;

	/**
	 * Implementation of IHttpParams interface.
	 * Extends OGCParams.
	 * It adds specific WMS request params.
	 */
	public class WMSParams extends OGCParams
	{

		private var _format:String;
		private var _exceptions:String;
		private var _layers:String;
		private var _styles:String;
		private var _width:Number;
		private var _height:Number;
		private var _transparent:Boolean;
		private var _bgcolor:String;
		private var _tiled:Boolean;

		public function WMSParams(layers:String, format:String = "image/jpeg", transparent:Boolean = false, 
			tiled:Boolean = false, styles:String = null, bgcolor:String = null)
		{
			super("WMS", "1.1.1", "GetMap");

			this._exceptions = "application/vnd.ogc.se_inimage";

			this._layers = layers;
			this._format = format;
			this._transparent = transparent;
			this._tiled = tiled;
			this._styles = styles;	
			this._bgcolor = bgcolor;		

		}

		override public function toGETString():String {
			var str:String = super.toGETString();
			if (this.bbox != null)
				str += "BBOX=" + this.bbox + "&";
			
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
			str += "TRANSPARENT=" + this._transparent.toString().toUpperCase() + "&";

			if (this._bgcolor != null)
				str += "BGCOLOR=" + this._bgcolor + "&";


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

		public function get transparent():Boolean {
			return _transparent;
		}

		public function set transparent(transparent:Boolean):void {
			_transparent = transparent;
		}

		public function get tiled():Boolean {
			return _tiled;
		}

		public function set tiled(tiled:Boolean):void {
			_tiled = tiled;
		}

		public function get bgcolor():String {
			return _bgcolor;
		}

		public function set bgcolor(bgcolor:String):void {
			_bgcolor = bgcolor;
		}
	}
}

