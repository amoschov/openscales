package org.openscales.core.layer
{
	import org.openscales.core.basetypes.Bounds;

	/**
	 * Base class for Open Street Map layers
	 *
	 * @author Bouiaw
	 */	
	public class HTC extends TMS
	{
		public static const MISSING_TILE_URL:String="http://openstreetmap.org/openlayers/img/404.png";
		
		public static const DEFAULT_MAX_RESOLUTION:Number = 2047.99990273;
		
		public static const DEFAULT_NUM_ZOOM_LEVELS:uint = 14;
		

		public function HTC(name:String = "", url:String = "", isBaseLayer:Boolean = true,
			visible:Boolean = true, projection:String = null, proxy:String = null) {
			
			if (projection == null || projection == "")
				projection = "EPSG:900913";

			super(name, url, isBaseLayer, visible, projection, proxy);
            this.generateResolutions(DEFAULT_NUM_ZOOM_LEVELS, DEFAULT_MAX_RESOLUTION);
		}

		override public function getURL(bounds:Bounds):String
		{
		var src:String= this.url;
		
		var mapName:String = this.name;
		//htc has reverse zoom 
		var resolution:Number = this.map.resolution;
		var zoom:int = DEFAULT_NUM_ZOOM_LEVELS - this.map.zoom;
        // calcul du numero de la tuile
        var numX:Number = Math.floor(bounds.centerPixel.x / (this.tileWidth * resolution));

        var numY:Number = Math.floor(bounds.centerPixel.y / (this.tileHeight * resolution));
  	
  	    var srcfinal:String;
        
        var format:String = "png8";
  		
  		var zoomString:String = String(zoom);
  		
  		if(zoomString.length == 1 ){
  			zoomString = "0" + zoomString;
  		}
  		
  		
  		srcfinal = mapName;
  		
  		srcfinal+= "_" +  format.substring(0,3)+"_" + String(this.tileWidth) + "_" + String(this.tileHeight) + "_" + zoomString +"/";
  		var minusX:String = "";
  		if(numX <0){
  			minusX = "-";
  		}
  		var minusY:String = "";
  		if(numY < 0){
  			minusY = "-";
  		}
  		
  		var numXString:String = String(Math.abs(numX));
  		var indice:int = 0;
  		for(indice=7-numXString.length;indice>0;indice--){
  			numXString = '0' + numXString;
  		}
  		
  		var numYString:String = String(Math.abs(numY));
  		for(indice=7-numYString.length;indice>0;indice--){
  			numYString = '0' + numYString;
  		}
  		
  		
  		srcfinal+="x" + minusX +  numXString.substr(0,4) + "/" + numXString.substr(4,3) + "/y" + minusY +  numYString.substr(0,4)+"/"  + numYString.substr(4,3);
  		  		
  		
        src += srcfinal + "." + format.substring(0,3);
		
  	    return src;
		}
	}
}
