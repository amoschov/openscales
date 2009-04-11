package org.openscales.core.events
{
	import org.openscales.core.layer.Layer;
	
	public class LayerEvent extends OpenScalesEvent
	{
		private var _layer:Layer = null;
		
		public static const LAYER_ADDED:String="openscales.addlayer";
		
		public static const LAYER_REMOVED:String="openscales.removelayer";
		
		public static const LAYER_CHANGED:String="openscales.changelayer";
		
		public static const BASE_LAYER_CHANGED:String="openscales.changebaselayer";
		
		public function LayerEvent(type:String, layer:Layer, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._layer = layer;
			super(type, bubbles, cancelable);
		}
		
	}
}