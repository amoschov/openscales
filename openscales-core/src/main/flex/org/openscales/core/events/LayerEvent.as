package org.openscales.core.events
{
	import org.openscales.core.basetypes.Bounds;
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

		/**
		 * Event type dispatched when a layer is added to the map.
		 */ 
		public static const LAYER_ADDED:String="openscales.addlayer";

		/**
		 * Event type dispatched when a layer is removed form the map.
		 */
		public static const LAYER_REMOVED:String="openscales.removelayer";

		/**
		 * Event type dispatched when a layer has been updated (FIXME : need to be confirmed).
		 */
		public static const LAYER_CHANGED:String="openscales.changelayer";

		/**
		 * Event type dispatched when the base layer of the map has changed
		 */	
		public static const BASE_LAYER_CHANGED:String="openscales.changebaselayer";

		
		/**
		 * Event type dispatched when the current map resolution is within the layer's min/max range.
		 */
		public static const LAYER_IN_RANGE:String="openscales.layerinrange";

		/**
		 * Event type dispatched when the current map resolution is out of the layer's min/max range.
		 */
		public static const LAYER_OUT_RANGE:String="openscales.layeroutrange";

		/**
		 * Event type dispatched when the layer is initialized and ready to request remote data if needed
		 */		
		public static const LAYER_INITIALIZED:String="openscales.layerinitialized";
		
		/**
		 * Event type dispatched when property visible of layer is changed
		 */		
		public static const LAYER_VISIBLE_CHANGED:String="openscales.visibilitychanged";
		
		/**
		 * Event type dispatched when loading is started
		 */		
		public static const LAYER_LOAD_START:String="openscales.layerloadstart";
		
		/**
		 * Event type dispatched when loading is completed
		 */		
		public static const LAYER_LOAD_END:String="openscales.layerloadend";

		public function LayerEvent(type:String, layer:Layer, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			this._layer = layer;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Layer concerned by the event.
		 */
		public function get layer():Layer {
			return this._layer;
		}
		public function set layer(layer:Layer):void {
			this._layer = layer;	
		}



	}
}

