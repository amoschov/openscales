package org.openscales.core.layer.osm
{
	import org.openscales.core.Util;

	/**
	 * Mapnik OpenStreetMap layer
	 *
	 * More informations on
	 * http://wiki.openstreetmap.org/index.php/Mapnik
	 */
	public class Maplint extends OSM
	{
		public function Maplint(name:String)
		{
			var url :String = "http://d.tah.openstreetmap.org/Tiles/maplint/";

			var alturls : Array = [	"http://e.tah.openstreetmap.org/Tiles/maplint/",
									"http://f.tah.openstreetmap.org/Tiles/maplint/"];

			super(name, url);

			this.altUrls = alturls;

			this.generateResolutions(19, OSM.DEFAULT_MAX_RESOLUTION);
		}
	}
}

