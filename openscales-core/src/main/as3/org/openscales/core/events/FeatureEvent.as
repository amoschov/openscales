package org.openscales.core.events
{
	import org.openscales.core.feature.VectorFeature;

	 /**
	 * 
	 *Event related to a Vectorfeature.
	 */
	public class FeatureEvent extends OpenScalesEvent
	{
		
		/**
		 * @private 
		 * Vectorfeature concerned by the event.
		 */
		private var _vectorfeature:VectorFeature = null;
		

		/**
		 * event's types 
		 */
		 	
		//Ctrl is pressed or not
		/**
		 * To know if ctrl key is pressed
		 */
		private var _ctrlPressed:Boolean = false;
			

		public static const FEATURE_OVER:String="openscales.feature.over";
		public static const FEATURE_OUT:String="openscales.feature.out";
		public static const FEATURE_CLICK:String="openscales.feature.click";
		public static const FEATURE_DOUBLECLICK:String="openscales.feature.doubleclick";
		public static const FEATURE_MOUSEDOWN:String="openscales.feature.mousedown";
		public static const FEATURE_MOUSEUP:String="openscales.feature.mouseup";
		public static const FEATURE_MOUSEMOVE:String="openscales.feature.mousemove";
		public static const FEATURE_DRAGGING:String="openscales.feature.dragging";
		public static const FEATURE_SELECTED:String="openscales.feature.selected";

		
		/**
		 * FeatureEvent constructor
		 *
		 * @param type event
		 * @param active to determinates if the handler is active
		 */

		public function FeatureEvent(type:String,vectorfeature:VectorFeature,ctrlStatus:Boolean = false,bubbles:Boolean=false,cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			this.vectorfeature=vectorfeature;
			this._ctrlPressed = ctrlStatus;
		}
	
		// Getters & setters as3
		/**
		 * Vectorfeature concerned by the event.
		 * @default null
		 */
		public function get vectorfeature():VectorFeature
		{
			return this._vectorfeature;
		}
		/**
		 * @private 
		 */
		public function set vectorfeature(vector:VectorFeature):void
		{
			this._vectorfeature=vector;
		}
		/**
		 * To know if ctrl key is pressed
		 * @default false
		 */
		public function get ctrlPressed():Boolean
		{
			return this._ctrlPressed;
		}
	}
}