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
		
		//features coordonnates
		private var _stageX:Number=NaN;
		private var _stageY:Number=NaN;
			
		public static const FEATURE_OVER:String="openscales.feature.over";
		public static const FEATURE_OUT:String="openscales.feature.out";
		public static const FEATURE_CLICK:String="openscales.feature.click";
		public static const FEATURE_DOUBLECLICK:String="openscales.feature.doubleclick";
		public static const FEATURE_MOUSEDOWN:String="openscales.feature.mousedown";
		public static const FEATURE_MOUSEUP:String="openscales.feature.mouseup";
		public static const FEATURE_MOUSEMOVE:String="openscales.feature.mousemove";
		public static const FEATURE_DRAGGING:String="openscales.feature.dragging";
		public function FeatureEvent(type:String,vectorfeature:VectorFeature,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.vectorfeature=vectorfeature;
			this._stageX=stageX;
			this._stageY=stageY;
		}
	
		//Properties
		public function get vectorfeature():VectorFeature
		{
			return this._vectorfeature;
		}
		public function set vectorfeature(vector:VectorFeature):void
		{
			this._vectorfeature=vector;
		}
		
		public function set stageX(stageX:Number):void
		{
			this._stageX=stageX;
		}
		public function get stageX():Number
		{
			return this._stageX;
		}
		public function set stageY(stageY:Number):void
		{
			this._stageY=stageY;	
		}
		public function get stageY():Number
		{
			return this._stageY;
		}
	}
}