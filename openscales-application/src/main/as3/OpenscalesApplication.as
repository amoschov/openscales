package {
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.LayerSwitcher;
	import org.openscales.core.control.Navigation;
	import org.openscales.core.control.PanZoomBar;
	import org.openscales.core.layer.Mapnik;

	[SWF(width='800', height='600')]
	public class OpenscalesApplication extends Sprite
	{
		protected var _map:Map;
		
		public function OpenscalesApplication()
		{
			_map = new Map();
			_map.maxResolution = 1;
			_map.numZoomLevels = 21;
			_map.size=new Size(800, 600);
				
			//var osm:Osmarender = new Osmarender('Osmarender');
			var mapnik:Mapnik = new Mapnik("Mapnik");
							
			_map.addLayers([mapnik]);
			_map.addControl(new PanZoomBar());
			_map.addControl(new Navigation());
			_map.addControl(new LayerSwitcher({position: new Pixel(_map.width/2, 0)}));
			
			var lat:Number=-3.5397294921874973;
    		var lon:Number=-43.584918945312495;
    		var zoom:Number=8;
    		
    		var lonLat:LonLat = new LonLat(lon, lat);
    		_map.setCenter (lonLat, zoom);
        		
			this.addChild(_map);
		}
	}
}
