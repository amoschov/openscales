package org.openscales.core.layer.osm
{
	import org.openscales.core.Util;
	
	public class Osmarender extends OSM
	{
		public function Osmarender(name:String="", options:Object = null)
		{
        	var url :String= "http://a.tah.openstreetmap.org/Tiles/tile/";
        	var alturls : Array = [	"http://b.tah.openstreetmap.org/Tiles/tile/",
        							"http://c.tah.openstreetmap.org/Tiles/tile/"];

        	options = Util.extend({ numZoomLevels: 18 }, options);
			
			super(name, url, options);
			this.altUrls = alturls;
		}
		

	}
}