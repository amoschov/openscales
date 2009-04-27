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
		
		//To know if the feature has been selected or unselected 
		private var _isSelect:Boolean;
		
		//Points coordinates
		private var _stageX:Number;
		private var _stageY:Number;
		
		public static const FEATURE_HOVER:String="openscales.feature.hover";
		public function FeatureEvent(type:String,vectorfeature:VectorFeature,isselect:Boolean,StageX:Number=0,StageY:Number=0,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.vectorfeature=vectorfeature;
			this._isSelect=isselect;
			this._stageX=StageX;
			this._stageY=StageY;
		}
	
		public function get vectorfeature():VectorFeature
		{
			return this._vectorfeature;
		}
		public function set vectorfeature(vector:VectorFeature):void
		{
			this._vectorfeature=vector;
		}
		public function get isselect():Boolean
		{
			return this._isSelect
		}
		public function set isselect(isselect:Boolean):void
		{
			this._isSelect=isselect;
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