package org.openscales.core.layer
{
	import org.openscales.core.Util;
	
	public class CycleMap extends OSM
	{
		public function CycleMap(name:String, options:Object)
		{
			var url:String = "http://a.andy.sandbox.cloudmade.com/tiles/cycle/";
        	
        	var alturls:Array = [	"http://b.andy.sandbox.cloudmade.com/tiles/cycle/",
        							"http://c.andy.sandbox.cloudmade.com/tiles/cycle/"];
        							
        	options = Util.extend({ numZoomLevels: 19 }, options);

			super(name, url, options);
			this.altUrls = alturls;
		}
		
	}
}