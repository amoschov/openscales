package org.openscales.core.layer.osm
{
	import org.openscales.core.Util;

	/**
	 * CycleMap OpenStreetMap layer
	 *
	 * More informations on
	 * http://www.gravitystorm.co.uk/shine/cycle-info/
	 */
	public class CycleMap extends OSM
	{
		public function CycleMap(name:String)
		{
			var url:String = "http://a.andy.sandbox.cloudmade.com/tiles/cycle/";

			var alturls:Array = ["http://b.andy.sandbox.cloudmade.com/tiles/cycle/",
								 "http://c.andy.sandbox.cloudmade.com/tiles/cycle/"];

			super(name, url);

			this.altUrls = alturls;

			this.generateResolutions(17, OSM.DEFAULT_MAX_RESOLUTION);
		}
	}
}

