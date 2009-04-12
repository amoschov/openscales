package {
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.handler.mouse.BorderPanningMouseHandler;
	import org.openscales.core.handler.mouse.ClickMouseHandler;
	import org.openscales.core.handler.mouse.WheelZoomMouseHandler;
	import org.openscales.core.layer.osm.Mapnik;

	[SWF(width='600', height='400')]
	public class OpenscalesApplication extends Sprite
	{
		protected var _map:Map;
		
		public function OpenscalesApplication()
		{
			_map = new Map();
			_map.maxResolution = 1;
			_map.numZoomLevels = 21;
			_map.size=new Size(600, 400);
				
			//var osm:Osmarender = new Osmarender('Osmarender');
			var mapnik:Mapnik = new Mapnik("Mapnik");
							
			_map.addLayers([mapnik]);
			_map.addHandler(new WheelZoomMouseHandler());
			_map.addHandler(new BorderPanningMouseHandler());
			_map.addHandler(new ClickMouseHandler());
			
			var lat:Number=-3.5397294921874973;
    		var lon:Number=-43.584918945312495;
    		var zoom:Number=8;
    		
    		var lonLat:LonLat = new LonLat(lon, lat);
    		_map.setCenter (lonLat, zoom);
        		
			this.addChild(_map);
		}
	}
}
