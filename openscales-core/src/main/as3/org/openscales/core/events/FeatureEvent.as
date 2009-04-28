package org.openscales.core.events
{
	import org.openscales.core.feature.VectorFeature;
	/**
	 * Event related to a Vectorfeature.
	 */
	public class FeatureEvent extends OpenScalesEvent
	{
		
		/**
		 * Vectorfeature concerned by the event.
		 */
		private var _vectorfeature:VectorFeature = null;
			
		public static const FEATURE_OVER:String="openscales.feature.over";
		public static const FEATURE_OUT:String="openscales.feature.out";
		public static const FEATURE_CLICK:String="openscales.feature.click";
		public static const FEATURE_DOUBLE_CLICK:String="openscales.feature.doubleclick";
		
		
		public function FeatureEvent(type:String,vectorfeature:VectorFeature,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.vectorfeature=vectorfeature;
		}
	
		public function get vectorfeature():VectorFeature
		{
			return this._vectorfeature;
		}
		public function set vectorfeature(vector:VectorFeature):void
		{
			this._vectorfeature=vector;
		}	
	}
}