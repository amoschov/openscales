package {
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.LayerSwitcher;
	import org.openscales.core.control.MousePosition;
	import org.openscales.core.control.PanZoomBar;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.handler.mouse.DragHandler;
	import org.openscales.core.handler.feature.SelectFeaturesHandler;
	import org.openscales.core.handler.mouse.WheelHandler;
	import org.openscales.core.layer.ogc.WFS;
	import org.openscales.core.layer.osm.CycleMap;
	import org.openscales.core.layer.osm.Mapnik;
	import org.openscales.core.style.Style;

	[SWF(width='600',height='400')]
	public class OpenscalesApplication extends Sprite {
		protected var _map:Map;

		public function OpenscalesApplication() {
			_map=new Map();
			_map.size=new Size(600, 400);

			// Add layers to map
			var mapnik:Mapnik=new Mapnik("Mapnik", true); // a base layer
			mapnik.maxExtent = new Bounds(-20037508.34,-20037508.34,20037508.34,20037508.34);		
			_map.addLayer(mapnik);

			var cycle:CycleMap=new CycleMap("Cycle", true); // a base laye
			_map.addLayer(cycle); 
			
			
			var regions:WFS = new WFS("IGN - Geopla (Region)", "http://openscales.org/geoserver/wfs","pg:ign_geopla_region",false,true,"EPSG:2154");
			regions.style = Style.getDefaultSurfaceStyle();
			
			_map.addLayer(regions);

			// Add Controls to map
			_map.addControl(new MousePosition());
			_map.addControl(new LayerSwitcher());
			_map.addControl(new PanZoomBar());
			new SelectFeaturesHandler(_map,true);

			// Add handlers
			new WheelHandler(_map);
			new DragHandler(_map);

			// Set the map center
			_map.center=new LonLat(538850.47459,5740916.1243);
			_map.zoom=5;
						
			this.addChild(_map);
		}
	}
}
