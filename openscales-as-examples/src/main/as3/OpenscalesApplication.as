package {
	import flash.display.Sprite;

	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.LayerSwitcher;
	import org.openscales.core.control.MousePosition;
	import org.openscales.core.control.PanZoomBar;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.handler.mouse.DragHandler;
	import org.openscales.core.handler.mouse.WheelHandler;
	import org.openscales.core.layer.osm.CycleMap;
	import org.openscales.core.layer.osm.Maplint;
	import org.openscales.core.layer.osm.Mapnik;

	[SWF(width='600',height='400')]
	public class OpenscalesApplication extends Sprite {
		protected var _map:Map;

		public function OpenscalesApplication() {
			_map=new Map();
			
			_map.maxResolution=156543.0339;
			_map.numZoomLevels=20;
			_map.size=new Size(600, 400);

			// Add layers to map
			var mapnik:Mapnik=new Mapnik("Mapnik", true); // a base layer
			_map.addLayer(mapnik);

			var cycle:CycleMap=new CycleMap("Cycle", true); // a base laye
			_map.addLayer(cycle);

			// Add Controls to map
			_map.addControl(new MousePosition());
			_map.addControl(new LayerSwitcher());
			_map.addControl(new PanZoomBar());

			// Add handlers
			_map.addHandler(new WheelHandler());
			_map.addHandler(new DragHandler());
			_map.addHandler(new ClickHandler());

			// Set the map center
			_map.center=new LonLat(538850.47459,5740916.1243);;
			_map.zoom=9;
						
			this.addChild(_map);

			
		}
	}
}
