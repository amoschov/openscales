package org.openscales.core.layer
{
	import org.openscales.core.Util;
	
	public class Maplint extends OSM
	{
		public function Maplint(name:String, options:Object=null)
		{
			var url :String = "http://d.tah.openstreetmap.org/Tiles/maplint/";
            	        	
        	var alturls : Array = [	"http://e.tah.openstreetmap.org/Tiles/maplint/",
            						"http://f.tah.openstreetmap.org/Tiles/maplint/"];

        	options = Util.extend({ numZoomLevels: 18, isBaseLayer: false, visible: false }, options);
        		
			super(name, url, options);
			this.altUrls=alturls;
		}
		
	}
}