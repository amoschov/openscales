package org.openscales.core.layer.osm
{
	import com.gradoservice.proj4as.ProjProjection;
	
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Unit;
	import org.openscales.core.layer.TMS;
	
	/**
	 * Base class for Open Streert Map layers
	 *  
	 * @author Bouiaw
	 */	
	public class OSM extends TMS
	{
		public function OSM(name:String, url:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
							projection:String = null, proxy:String = null) {
			
			/* If projection string is null or empty, we init the layer's projection
			with EPSG:900913 (default value to OpenStreetMap layers) */
			if (projection == null || projection == "")
				projection = "EPSG:900913";
			
			super(name, url, isBaseLayer, visible, projection, proxy);
			
			this.maxResolution = 156543.0339;
			this.units = Unit.METER;
			
		}
		
		override public function getURL(bounds:Bounds):String
		{
			var res:Number = this.map.resolution;
        	var x:Number = Math.round((bounds.left - this.maxExtent.left) / (res * this.tileSize.w));
        	var y:Number = Math.round((this.maxExtent.top - bounds.top) / (res * this.tileSize.h));
        	var z:Number = this.map.zoom;
        	var limit:Number = Math.pow(2, z);

	        if (y < 0 || y >= limit)
	        {
	            return Util.MISSING_TILE_URL;
	        }
	        else
	        {
	            x = ((x % limit) + limit) % limit;

            	var url:String = this.url;
            	var path:String = z + "/" + x + "/" + y + ".png";
            	
	          	if (this.altUrls != null) {
		            url = this.selectUrl(this.url + path, this.getUrls());
		        }  
				
            	return url + path;
 	       }
		}
	
	}
}