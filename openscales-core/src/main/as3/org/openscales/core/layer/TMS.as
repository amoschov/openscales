package org.openscales.core.layer
{
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.tile.ImageTile;
	import org.openscales.core.tile.Tile;

	/**
	 * The Tiled Web Service provides access to resources, in particular, to rendered
	 * cartographic tiles at fixed scales.
	 *
	 * More informations on http://wiki.osgeo.org/wiki/Tile_Map_Service_Specification
	 *
	 */
	public class TMS extends Grid
	{

		private var _serviceVersion:String = "1.0.0";

		private var _tileOrigin:LonLat = null;

		/**
		 * A list of all resolutions available on the server.
		 * Only set this property if the map resolutions differs from the server
		 */
		private var _serverResolutions:Array = null;

		public function TMS(name:String, url:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
			projection:String = null, proxy:String = null) {

			super(name, url, params,isBaseLayer, visible, projection, proxy);

		}

		override public function getURL(bounds:Bounds):String
		{
			bounds = this.adjustBoundsByGutter(bounds);
			var res:Number = this.map.resolution;
			var x:Number = Math.round((bounds.left - this._tileOrigin.lon) / (res * this.tileSize.w));
			var y:Number = Math.round((bounds.bottom - this._tileOrigin.lat) / (res * this.tileSize.h));
			var z:Number = this._serverResolutions != null ? this._serverResolutions.indexOf(res) : this.map.zoom;
			// Overrided so commented
			// Use name instead of layername, cf. http://trac.openlayers.org/ticket/737
			var path:String = ""/*this.serviceVersion + "/" + this.name + "/" + z + "/" + x + "/" + y + "." + this.type*/;
			var url:String = this.url;
			return url + path;
		}

		override public function addTile(bounds:Bounds, position:Pixel):Tile
		{
			return new ImageTile(this, position, bounds, null, this.tileSize);
		}

		override public function set map(map:Map):void {
			super.map = map;
			if (!this._tileOrigin) {
				this._tileOrigin = new LonLat(this.map.maxExtent.left, this.map.maxExtent.bottom);
			}
		} 
	}
}

