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
		 * @private
		 */
		private var _layer:Layer = null;
		/**
		 * Layer extent corresponding to map extent
		 * is used here for the security
		 * @private
		 * */
		private var _bounds:Bounds=null;
		
		public static const LAYER_ADDED:String="openscales.addlayer";
		
		public static const LAYER_REMOVED:String="openscales.removelayer";
		
		public static const LAYER_CHANGED:String="openscales.changelayer";
		
		public static const BASE_LAYER_CHANGED:String="openscales.changebaselayer";
		
		public static const LAYER_IN_RANGE:String="openscales.layerinrange";
		
		public static const LAYER_OUT_RANGE:String="openscales.layeroutrange";
		
		public static const LAYER_AUTHENTIFICATED:String="openscales.layerauthentificated";
		
		public static const LAYERS_CONF_END:String="openscales.layersconfend";
		public function LayerEvent(type:String, layer:Layer,bounds:Bounds=null, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			this._layer = layer;
			this._bounds=bounds;
			super(type, bubbles, cancelable);
		}
		/**
		 * Layer concerned by the event.
		 */
		public function get layer():Layer {
			return this._layer;
		}
		/**
		 *@private
		 **/
		public function set layer(layer:Layer):void {
			this._layer = layer;	
		}
		/**
		 * Layer extent corresponding to map extent
		 * is used here for the security
		 **/
		 public function get bounds():Bounds{
		 	return this._bounds;
		 }
		 
		 /**
		 * @private
		 * */
		 public function set bounds(value:Bounds){
		 	this._bounds=value;
		 }
		
		
		
	}
}