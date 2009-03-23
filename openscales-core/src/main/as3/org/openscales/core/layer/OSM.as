package org.openscales.core.layer
{
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	
	public class OSM extends TMS
	{
		public function OSM(name:String, url:String, options:Object):void
		{
			options = Util.extend({
				attribution: "Data by <a href='http://openstreetmap.org/'>OpenStreetMap</a>",
            	//maxExtent: new Bounds(-20037508.34,-20037508.34,20037508.34,20037508.34),
            	maxResolution: 156543.0339,
            	units: "m",
            	//projection: "EPSG:900913",
            	projection: "EPSG:4326",
            	transitionEffect: "resize"
			}, options);
			super(name, url, options);
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