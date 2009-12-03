package org.openscales.core.handler.mouse
{
	import flash.events.Event;
	
	import org.openscales.core.Map;
	import org.openscales.core.feature.Feature;
	
	/**
	 * DragFeature is use to drag a feature
	 * To use this handler, it's  necessary to add it to the map
	 * DragFeature is a pure ActionScript class. Flex wrapper and components can be found in the
	 * openscales-fx module FxDragFeature.
	 */
	public class DragFeature extends DragHandler
	{
	
		/**
		* The feature currently dragged
		* */
		private var featureDragged:Feature=null;
		/**
		 * Array of features which are undraggabled and belongs to a
		 * draggable layers 
	 	* */	 
		 private var UndraggableFeature:Array=null;	
		 /**
		 * Array of layers which are draggable
		 * */
		 private var _layers:Array=null;
	 	/**
	 	 * Constructor
	 	 * @param map:Map Object 
	 	 * @param active:Boolean to active or deactivate the handler
	 	 * */
		public function DragFeature(map:Map=null, active:Boolean=false)
		{
			super(map, active);
		}
		/**
		 * This function is launched when the Mouse is down
		 */
		override  protected function onMouseDown(event:Event):void{
			if(event.target is Feature){
				
			}
		}
		/**
		 * This function is launched when the Mouse is up
		 */
		 override protected function onMouseUp(event:Event):void{
		 	if(event.target is Feature){
				
			}
		 }
		
	}
}