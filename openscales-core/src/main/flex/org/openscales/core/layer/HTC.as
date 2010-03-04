package org.openscales.core.layer
{
	import org.openscales.core.basetypes.Bounds;
	
	/**
	 * High Traffic Client (HTC) layers
	 * Support of GeoConcept HTC protocol
	 *
	 * @author Bouiaw
	 */	
	public class HTC extends TMS
	{
		public static const DEFAULT_MAX_RESOLUTION:Number = 8191.99961092;

		public static const DEFAULT_NUM_ZOOM_LEVELS:uint = 14;

		public static const DEFAULT_ZOOM_MAX:uint = 16;

		private var _zoom_max:uint;
		
		private var _format:String = "png";

		/**
		 * setter for the max zoom level
		 */
		public function set zoom_max(value:uint):void{
			this._zoom_max = value;
		}

		/**
		 * setter for tile image format
		 * 
		 * @param value:String the tile image extention
		 */
		public function set format(value:String):void {
			if(value.length==0)
				return;
			else if(value.charAt(0)='.')
				this._format = value.substr(1,value.length-1);
			else
				this._format = value;
		}
		/**
		 * getter for tile image format
		 * 
		 * @return String the tile image format
		 */
		public function get format():void {
			return this._format;
		}

		/**
		 * Constructor
		 * 
		 * @param name:String the name of the layer
		 * @param url:String URL of the server
		 * @param isBaseLayer:Boolean is the layer a baselayer. Default true
		 * @param visible:Boolean is the layer visible. Default true
		 * @param projection:String the projection of the layer. Default null
		 * @param proxy:String the proxy to use for the request, usefull when the server does not have a crossdomain.xml. Default null
		 * @param maxResolution:Number the max resolution tu use for the computation of resolutions. default DEFAULT_MAX_RESOLUTION
		 * @param numZoomLevel:uint the number of zoom level. Default DEFAULT_NUM_ZOOM_LEVELS
		 * @param zoom_max:uint the maximum zoom value. Default DEFAULT_ZOOM_MAX
		 */
		public function HTC(name:String = "",
							url:String,
							isBaseLayer:Boolean = true,
							visible:Boolean = true,
							projection:String = null,
							proxy:String = null,
							maxResolution:Number=DEFAULT_MAX_RESOLUTION,
							numZoomLevel:uint=DEFAULT_NUM_ZOOM_LEVELS,
							zoom_max:uint=DEFAULT_ZOOM_MAX) {

			// prevent malformed urls due to lack of slash sign
			if(url.length>0 && url.substr(-1,1)!="/")
				url+="/";

			this._zoom_max = zoom_max;
			if (projection == null || projection == "")
				projection = "EPSG:900913";

			super(name, url, isBaseLayer, visible, projection, proxy);
			this.generateResolutions(numZoomLevel, maxResolution);
		}

		/**
		 * Return the url to request for a specific bounds
		 * 
		 * @param bounds:Bounds bounds to request
		 */
		override public function getURL(bounds:Bounds):String
		{
			var resolution:Number = this.map.resolution;
			// htc has reverse zoom 
			var zoom:int = _zoom_max - this.map.zoom ;
			var zoomString:String = String(zoom);

			// compute the number of the tile
			var numX:Number = Math.floor(bounds.centerPixel.x / (this.tileWidth * resolution));
			var numY:Number = Math.floor(bounds.centerPixel.y / (this.tileHeight * resolution));

			var srcfinal = this.url+this.name;

			srcfinal+= "_" +  this._format + "_" + String(this.tileWidth) + "_" + String(this.tileHeight) + "_" + zoomString + "/";

			var minusX:String = "";
			if(numX <0){
				minusX = "-";
			}
			var minusY:String = "";
			if(numY < 0){
				minusY = "-";
			}

			var indice:int;
			// adjust length of X an Y coordinates
			var numXString:String = String(Math.abs(numX));
			for(indice=7-numXString.length;indice>0;indice--){
				numXString = '0' + numXString;
			}
			var numYString:String = String(Math.abs(numY));
			for(indice=7-numYString.length;indice>0;indice--){
				numYString = '0' + numYString;
			}

			srcfinal+="x" + minusX +  numXString.substr(0,4) + "/" + numXString.substr(4,3) + "/y" + minusY +  numYString.substr(0,4)+"/"  + numYString.substr(4,3);

			return srcfinal + "." + this._format;
		}
	}
}