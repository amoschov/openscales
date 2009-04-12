package org.openscales.fx
{
	import mx.core.UIComponent;
	
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.WFS;
	import org.openscales.core.layer.WMS;
	import org.openscales.core.layer.WMSC;
	import org.openscales.core.layer.osm.CycleMap;
	import org.openscales.core.layer.osm.Maplint;
	import org.openscales.core.layer.osm.Mapnik;

	public class FxLayer extends UIComponent
	{
		private var _layer:Layer;
		
		private var _type:String;
		
		public function FxLayer()
		{
			super();
		}
		
		[Inspectable(category="Map",
					 enumeration="OSM_MAPNIK, OSM_MAPLINT, OSM_CYCLE_MAP",
					 defaultValue="OSM_MAPNIK")]
		public function set type(value:String):void {
			switch(value) {
				case "OSM_MAPNIK":
					_layer = new Mapnik("OSM_MAPNIK");
					_type = value;
					break;
				case "OSM_MAPLINT":
					_layer = new Maplint("OSM_MAPLINT");
					_type = value;
					break;
				case "OSM_CYCLE_MAP":
					_layer = new CycleMap("OSM_CYCLE_MAP");
					_type = value;
					break;
				case "WMSC":
					_layer = new WMSC("WMSC", "", {});
					_type = value;
					break;
				case "WMS":
					_layer = new WMS("WMS", "", {});
					_type = value;
					break;
				case "WFS":
					_layer = new WFS("WFS", "", {});
					_type = value;
					break;
			}
		}
		
		public function get type():String {
			return this._type;
		}
		
		public function get layer():Layer {
			return this._layer;
		}
		
	}
}