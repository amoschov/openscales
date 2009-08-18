package org.openscales.core.events
{
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.feature.Feature;

	/**
	 * Event related to a Feature.
	 */
	public class FeatureEvent extends OpenScalesEvent
	{

		/**
		 * An array of features concerned by the event.
		 */
		private var _features:Array = null;


		/**
		 * event's types
		 */

		//Ctrl is pressed or not
		/**
		 * To know if ctrl key is pressed
		 */
		private var _ctrlPressed:Boolean = false;


		public static const FEATURE_PRE_INSERT:String="openscales.feature.preinsert";
		public static const FEATURE_INSERT:String="openscales.feature.insert";
		public static const FEATURE_OVER:String="openscales.feature.over";
		public static const FEATURE_OUT:String="openscales.feature.out";
		public static const FEATURE_CLICK:String="openscales.feature.click";
		public static const FEATURE_DOUBLECLICK:String="openscales.feature.doubleclick";
		public static const FEATURE_MOUSEDOWN:String="openscales.feature.mousedown";
		public static const FEATURE_MOUSEUP:String="openscales.feature.mouseup";
		public static const FEATURE_MOUSEMOVE:String="openscales.feature.mousemove";
		public static const FEATURE_DRAGGING:String="openscales.feature.dragging";
		public static const FEATURE_SELECTED:String="openscales.feature.selected";
		public static const FEATURE_SELECTEDBOX:String="openscales.feature.selectedbox";
		public static const FEATURE_UNSELECTED:String="org.openscales.feature.unselected";


		/**
		 * FeatureEvent constructor
		 *
		 * @param type event
		 * @param active to determinates if the handler is active
		 */

		public function FeatureEvent(type:String,features:Array,ctrlStatus:Boolean = false,bubbles:Boolean=false,cancelable:Boolean=false,bounds:Bounds = null) 
		{
			super(type, bubbles, cancelable);
			this._features=features;
			this._ctrlPressed = ctrlStatus;
		}

		// Getters & setters as3
		/**
		 * Vectorfeature concerned by the event.
		 * @default null
		 */
		public function get features():Array{
			return this._features;
		}
		/**
		 * @private
		 */
		public function set features(value:Array):void{
			this._features=value;
		}
		/**
		 * To know if ctrl key is pressed
		 * @default false
		 */
		public function get ctrlPressed():Boolean{
			return this._ctrlPressed;
		}
	}
}

