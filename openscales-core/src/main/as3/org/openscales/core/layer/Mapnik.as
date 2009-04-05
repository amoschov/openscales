package org.openscales.core.layer
{
	import org.openscales.commons.Util;
	
	public class Mapnik extends OSM
	{
		public function Mapnik(name:String, options:Object=null)
		{
			var url:String = "http://a.tile.openstreetmap.org/";
			
			var alturls : Array = [	"http://b.tile.openstreetmap.org/",
        							"http://c.tile.openstreetmap.org/"];

        	
        	options = Util.extend({ numZoomLevels: 19 }, options);
		
			super(name, url, options);
			this.altUrls = alturls;
		}
		
	}
}