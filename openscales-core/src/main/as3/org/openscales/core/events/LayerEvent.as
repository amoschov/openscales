package org.openscales.core.events
{
	import org.openscales.core.layer.Layer;
	
	/**
	 * Event related to a layer.
	 */
	public class LayerEvent extends OpenScalesEvent
	{
		/**
		 * Layer concerned by the event.
		 */
		private var _layer:Layer = null;
		
		public static const LAYER_ADDED:String="openscales.addlayer";
		
		public static const LAYER_REMOVED:String="openscales.removelayer";
		
		public static const LAYER_CHANGED:String="openscales.changelayer";
		
		public static const BASE_LAYER_CHANGED:String="openscales.changebaselayer";
		
		public static const LAYER_IN_RANGE:String="openscales.layerinrange";
		
		public static const LAYER_OUT_RANGE:String="openscales.layeroutrange";
		
		public function LayerEvent(type:String, layer:Layer, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._layer = layer;
			super(type, bubbles, cancelable);
		}
		
		public function get layer():Layer {
			return this._layer;
		}
		
		public function set layer(layer:Layer):void {
			this._layer = layer;	
		}
		
	}
}