package org.openscales.core.layer
{
	import org.openscales.basetypes.Bounds;
	import org.openscales.proj4as.ProjProjection;
	
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

		private var _directoryPrefix:String = "";

		/**
		 * setter for the max zoom level
		 */
		public function set zoom_max(value:uint):void{
			this._zoom_max = value;
		}

		/**
		 * setter for directory name
		 * 
		 * @param value:String the directory name
		 */
		public function set directoryPrefix(value:String):void {
			if(value.length==0)
				this._directoryPrefix = "";
			else if(value.charAt(value.length-1)=="_")
				this._directoryPrefix = value;
			else
				this._directoryPrefix = value+"_";
		}
		/**
		 * getter for directory name
		 * 
		 * @return String the directory name
		 */
		public function get directoryPrefix():String {
			return this._directoryPrefix;
		}

		/**
		 * Constructor
		 * 
		 * @param name:String the name of the layer
		 * @param url:String URL of the server
		 * @param maxResolution:Number the max resolution tu use for the computation of resolutions. default DEFAULT_MAX_RESOLUTION
		 * @param numZoomLevel:uint the number of zoom level. Default DEFAULT_NUM_ZOOM_LEVELS
		 * @param zoom_max:uint the maximum zoom value. Default DEFAULT_ZOOM_MAX
		 */
		public function HTC(name:String,
							url:String,
							maxResolution:Number=DEFAULT_MAX_RESOLUTION,
							numZoomLevel:uint=DEFAULT_NUM_ZOOM_LEVELS,
							zoom_max:uint=DEFAULT_ZOOM_MAX) {

			// prevent malformed urls due to lack of slash sign
			if(url.length>0 && url.substr(-1,1)!="/")
				url+="/";
			super(name,url);
			this.isBaseLayer = true;
			this.projection = new ProjProjection("EPSG:900913");
			this._zoom_max = zoom_max;
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

			var srcfinal:String = this.url+this.directoryPrefix;

			srcfinal+= this.format + "_" + String(this.tileWidth) + "_" + String(this.tileHeight) + "_" + zoomString + "/";

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
			indice=7-numXString.length;
			for(indice;indice>0;--indice){
				numXString = '0' + numXString;
			}
			var numYString:String = String(Math.abs(numY));
			indice=7-numYString.length;
			for(indice;indice>0;--indice){
				numYString = '0' + numYString;
			}

			srcfinal+="x" + minusX +  numXString.substr(0,4) + "/" + numXString.substr(4,3) + "/y" + minusY +  numYString.substr(0,4)+"/"  + numYString.substr(4,3);

			return srcfinal + "." + this.format;
		}
	}
}