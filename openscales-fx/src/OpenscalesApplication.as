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
	import org.openscales.core.handler.mouse.WheelHandler;
	import org.openscales.core.layer.ogc.WFS;
	import org.openscales.core.layer.osm.CycleMap;
	import org.openscales.core.layer.osm.Mapnik;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Fill;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.core.style.symbolizer.Stroke;

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
			mapnik.maxExtent = new Bounds(-20037508.34,-20037508.34,20037508.34,20037508.34);		
			_map.addLayer(mapnik);

			var cycle:CycleMap=new CycleMap("Cycle", true); // a base laye
			_map.addLayer(cycle); 
			
			var regions:WFS = new WFS("Regions", "http://openscales.org/geoserver/wfs","pg:ign_geopla_france",false,true,"EPSG:2154");
			
			var fill1:Fill = new Fill();
			fill1.color = 0xffaaaa;
			
			var stroke1:Stroke = new Stroke();
			stroke1.width = 2;
			stroke1.color = 0xffee00;
			
			var stroke2:Stroke = new Stroke();
			stroke2.width = 4
			stroke2.color = 0xffffff;
			
			var ps1 = new PolygonSymbolizer();
			ps1.fill = fill1;
			ps1.stroke = stroke2;
			
			var ps2 = new PolygonSymbolizer();
			ps2.stroke = stroke1;
			
			var rule:Rule = new Rule();
			rule.symbolizers.push(ps1,ps2);
			
			var style:Style = new Style();
			style.rules.push(rule);
			style.name = "Super style de la mort qui tue";
			regions.style = style;
			
			_map.addLayer(regions);

			// Add Controls to map
			_map.addControl(new MousePosition());
			_map.addControl(new LayerSwitcher());
			_map.addControl(new PanZoomBar());

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
