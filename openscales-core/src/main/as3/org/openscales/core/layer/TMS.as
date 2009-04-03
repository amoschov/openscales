package org.openscales.core.layer
{
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.tile.Image;
	import org.openscales.core.tile.Tile;
	
	public class TMS extends Grid
	{
		
		private var serviceVersion:String = "1.0.0";
			
		private var tileOrigin:LonLat = null;
		
		/* A list of all resolutions available on the server. Only set this property
		if the map resolutions differs from the server */
		private var serverResolutions:Array = null;
		
		public function TMS(name:String, url:String, options:Object = null):void
		{
			this.isBaseLayer = true;
			super(name, url, null, options);
		}
		
		override public function clone(obj:Object):Object
		{
			if (obj == null)
			{
				obj = new TMS(this.name, this.url);
			}
			
			obj = super.clone([obj]);
			
			return obj;
		}
		
		override public function getURL(bounds:Bounds):String
		{
			bounds = this.adjustBoundsByGutter(bounds);
			var res:Number = this.map.resolution;
			var x:Number = Math.round((bounds.left - this.tileOrigin.lon) / (res * this.tileSize.w));
 	        var y:Number = Math.round((bounds.bottom - this.tileOrigin.lat) / (res * this.tileSize.h));
 	        var z:Number = this.serverResolutions != null ? this.serverResolutions.indexOf(res) : this.map.zoom;
 	        // Overrided so commented
 	        // Use name instead of layername, cf. http://trac.openlayers.org/ticket/737
 	        var path:String = ""/*this.serviceVersion + "/" + this.name + "/" + z + "/" + x + "/" + y + "." + this.type*/;
 	        var url:String = this.url;
 	        return url + path;
		}
		
		override public function addTile(bounds:Bounds, position:Pixel):Tile
		{
			return new Image(this, position, bounds, null, this.tileSize);
		}
		
		override public function set map(map:Map):void {
 	        super.map = map;
 	        if (!this.tileOrigin) {
 	        	this.tileOrigin = new LonLat(this.map.maxExtent.left, this.map.maxExtent.bottom);
 	        }
 		} 
	}
}