package org.openscales.core.layer.osm
{
	import org.openscales.core.Util;
	
	/**
	 * Mapnik OpenStreetMap layer
	 * 
	 * More informations on 
	 * http://wiki.openstreetmap.org/index.php/Mapnik
	 */
	public class Mapnik extends OSM
	{
		public function Mapnik(name:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
									projection:String = null, proxy:String = null)
		{
			var url:String = "http://a.tile.openstreetmap.org/";
			
			var alturls:Array = [	"http://b.tile.openstreetmap.org/",
        							"http://c.tile.openstreetmap.org/"];

        	
        	super(name, url, isBaseLayer, visible, projection, proxy);
			
			this.altUrls = alturls;
			this.numZoomLevels = 20;
		}
		
	}
}