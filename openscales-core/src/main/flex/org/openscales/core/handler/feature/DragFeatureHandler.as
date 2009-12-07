package org.openscales.core.handler.feature
{
	import flash.events.Event;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.handler.mouse.DragHandler;
	import org.openscales.core.layer.FeatureLayer;
	
	/**
	 * DragFeature is use to drag a feature
	 * To use this handler, it's  necessary to add it to the map
	 * It dispatch FeatureEvent.FEATURE_DRAG_START and FeatureEvent.FEATURE_DRAG_STOP events
	 */
	public class DragFeatureHandler extends DragHandler
	{
	
		/**
		* The feature currently dragged
		* */
		private var _featureCurrentlyDragged:Feature=null;
		/**
		 * Array of features which are undraggabled and belongs to a
		 * draggable layers 
	 	* */	 
		 private var _undraggableFeatures:Array=null;	
		 /**
		 * Array of layers which allow dragging
		 * */
		 private var _draggableLayers:Array=null;
	 	/**
	 	 * Constructor class
	 	 * 
	 	 * @param map:Map Object 
	 	 * @param active:Boolean to active or deactivate the handler
	 	 * */
		public function DragFeatureHandler(map:Map=null, active:Boolean=false)
		{
			super(map, active);
			_undraggableFeatures=new Array();
			_draggableLayers=new Array();
		}
		/**
		 * This function is launched when the Mouse is down
		 */
		override  protected function onMouseDown(event:Event):void{
			var feature:Feature=event.target as Feature;
			//The target is a feature , its' layer is draggable and it doesn't belongs to the undraggableFeatures Array
			if(feature!=null && Util.indexOf(_draggableLayers,feature.layer)!=-1 && Util.indexOf(_undraggableFeatures,feature)==-1){
				feature.startDrag();
				_featureCurrentlyDragged=feature;
				this.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DRAG_START,feature));
			}
		}
		/**
		 * This function is launched when the Mouse is up
		 */
		 override protected function onMouseUp(event:Event):void{
		 	var feature:Feature=event.target as Feature;
		 	//The target is a feature and is the feature currently dragged
		 	if(feature!=null && _featureCurrentlyDragged==feature){
				feature.stopDrag();
				_featureCurrentlyDragged=null;
				this.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DRAG_STOP,feature));
			}
		 }
		 /**
		 * This function is used to add an array of undraggable feature which belong to a draggable layer
		 * @param features:Array Array of feature to make undraggable
		 * */
		 public function addUndraggableFeatures(features:Array):void{
		 	for(var i:int=0;i<features.length;i++){
		 		addUndraggableFeature(features[i] as Feature);
		 	}
		 }
		/**
		 * This function is used to add an undraggable feature which belong to a draggable layer
		 * @param feature:Feature The feature to add
		 * */
		public function addUndraggableFeature(feature:Feature):void{
			var addFeature:Boolean=false;
			if(feature!=null){
				for each(var featureLayer:FeatureLayer in _draggableLayers){
					//The feature belongs to a draggable layers
					if(Util.indexOf(featureLayer.features,feature)!=-1){
						addFeature=true;	
						break;
					}
				}
				if(addFeature){
					if(Util.indexOf(_undraggableFeatures,feature)==-1){
						_undraggableFeatures.push(feature);
					}
				}
			}
		}
		/**
		 * This function add an array of  layers as draggabble layer
		 * @param layers: Array of  layer to add
		 * */
		public function addDraggableLayers(layers:Array):void {
				for(var i:int=0;i<layers.length;i++){
					addDraggableLayer(layers[i] as FeatureLayer);
				}
		}
		/**
		 * This function add a layers as draggabble layer
		 * @param layer:FeatureLayer the layer to add
		 * */
		public function addDraggableLayer(layer:FeatureLayer):void{
			if(layer!=null && Util.indexOf(_draggableLayers,layer)==-1){
				_draggableLayers.push(layer);
			}
		}
	}
}