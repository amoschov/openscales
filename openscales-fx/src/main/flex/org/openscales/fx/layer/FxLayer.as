package org.openscales.fx.layer
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
			
		public function FxLayer()
		{
			super();
		}
		
		public function set layer(value:Layer):void {
			this._layer = value;
		}
				
		public function get layer():Layer {
			return this._layer;
		}
		
	}
}