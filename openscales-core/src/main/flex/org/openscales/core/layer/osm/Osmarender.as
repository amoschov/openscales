package org.openscales.core.layer.osm
{
	import org.openscales.core.Util;

	/**
	 * Osmarender OpenStreetMap layer
	 *
	 * More informations on
	 * http://wiki.openstreetmap.org/index.php/Osmarender
	 */
	public class Osmarender extends OSM
	{
		public function Osmarender(name:String,
								   isBaseLayer:Boolean = false,
								   visible:Boolean = true,
								   projection:String = null,
								   proxy:String = null)
		{
			var url:String= "http://a.tah.openstreetmap.org/Tiles/tile/";

			var alturls:Array = ["http://b.tah.openstreetmap.org/Tiles/tile/",
								 "http://c.tah.openstreetmap.org/Tiles/tile/"];        	

			super(name, url, isBaseLayer, visible, projection, proxy);

			this.altUrls = alturls;

			this.generateResolutions(18, OSM.DEFAULT_MAX_RESOLUTION);
		}

	}
}

