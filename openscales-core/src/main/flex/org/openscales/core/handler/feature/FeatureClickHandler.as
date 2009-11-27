package org.openscales.core.handler.feature
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.handler.Handler;
	
	/**
	 * Depracated, should be removed in favor of SelectFeaturesHandler
	 * 
	 * This handler has been created in particurlaly for The edition mode
	 * It allows the user to differenciate click from double click and drag/drop
	 * */
	public class FeatureClickHandler extends Handler
	{
		/**
		 * Array which contains the feature concerned by the click
		 * 
		 * */
		private	var _featureArray:Array;
		
		private var _featureEvent:FeatureEvent;
		/**
		 * We use a timer to detect double click, without throwing a click before.
		 */
		private var _timer:Timer = new Timer(250,1);
		
		private var _StartPixel:Pixel=null;
		/**
		 * callback function oneclick(evt:FeatureEvent):void
		 */
		private var _click:Function = null;
		/**
		 * callback function doubleClick(evt:FeatureEvent):void
		 */
		private var _doubleClick:Function = null;
		
		private var _clickNum:Number = 0;
		
		private var _isdragging:Boolean=false;
		
		private var _draggingTolerance:Number=10;
		/**
		 * We use a tolerance to detect a drag or a click
		 */
		private var _tolerance:Number=2;
		
		private var _startDrag:Function=null;
		
		private var _stopDrag:Function=null;
		
		/**
		 * Constructor
		 * @param map:Map Map object
		 * @param active:Boolean to activate or deactivate the handler
		 * */
		public function FeatureClickHandler(map:Map=null, active:Boolean=false)
		{
			super(map, active);
			this._featureArray=new Array();		
		}
		
		 override protected function registerListeners():void{
			if (this.map) {
				this.map.addEventListener(FeatureEvent.FEATURE_MOUSEUP,this.mouseUp);
				this.map.addEventListener(FeatureEvent.FEATURE_MOUSEDOWN,this.mouseDown);
			}
			this._timer.addEventListener(TimerEvent.TIMER, chooseClick);
		
		}
		override protected function unregisterListeners():void{
			this._timer.stop();
			if (this.map) {
				this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEUP,this.mouseUp);
				this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEDOWN,this.mouseDown);
			}
		}
		//This function is used to detect a click
		//This function provided from the old ClickHandler
		private  function chooseClick(event:TimerEvent):void{
			if(_clickNum == 1) {
				if(_click != null)
				{
				//If the handler could treat operation on this feature
				if(Util.indexOf(_featureArray,_featureEvent.feature)!=-1){
				_click(_featureEvent);
				}
				_timer.stop();
				_clickNum=0;
				}
			} 
			//double click   
			else {
				
				//If the handler could treat operation on this feature
				if(Util.indexOf(_featureArray,_featureEvent.feature)!=-1)
				_doubleClick(_featureEvent);
				_timer.stop();
				_clickNum=0;
			}
		}
		
		/**
		 * The MouseDown Listener
		 */
		 protected function mouseDown(evt:FeatureEvent):void
		{
			var vectorFeature:Feature=evt.feature as Feature;
			if(vectorFeature!=null)this._StartPixel=new Pixel(evt.feature.layer.mouseX ,evt.feature.layer.mouseY);
			this._featureEvent=evt;
			//This function is used in  the case mouse is not on the feature
			//and the drop function is not launched
			this.map.addEventListener(MouseEvent.MOUSE_UP,this.dropMouseUp);
			
			this.dragfeatureStart(evt);
			
		}

		/**
		 * MouseUp Listener
		 */
		 protected function mouseUp(evt:FeatureEvent):void
		{
			if(_isdragging){
				var tmppx:Pixel=new Pixel(evt.feature.layer.mouseX ,evt.feature.layer.mouseY);
				//if the mousedown point is close from the mouseUp point it's a click or a double click
				if(Math.abs(tmppx.x-this._StartPixel.x)<this._draggingTolerance && Math.abs(tmppx.y-this._StartPixel.y)<this._draggingTolerance)
				{
					_isdragging=false;
				}
			}
			if(!_isdragging)
			{
			if(this._StartPixel!=null){
				//dx and dy variables are use to know if there was a drag or a click
				var vectorFeature:Feature=evt.feature as Feature;
				var dx :Number = Math.abs(this._StartPixel.x-evt.feature.layer.mouseX);
				var dy :Number = Math.abs(this._StartPixel.y-evt.feature.layer.mouseY);
				if(dx<=this._tolerance && dy<=this._tolerance)
				{
					this.featureClick(evt);
				}
			}
			}
			//it's a drag
			else dragfeatureStop(this._featureEvent);		
		}
		//In this function we count the click to different the double click from the click
		//This function provided from the old ClickHandler
		private function featureClick(evt:FeatureEvent):void
		{
			_featureEvent = evt;
			_clickNum++;
			_timer.start() 
		}
		/**
		 * This function is used for removing a  feature 
		 * from the the feature click handler controled features
		 * @param feature:Feature feature to remove
		 * */
		public function removeControledFeature(feature:Feature):void{
			Util.removeItem(this._featureArray,feature);
			feature.removeEventListener(FeatureEvent.FEATURE_MOUSEUP,this.mouseUp);
			feature.removeEventListener(FeatureEvent.FEATURE_MOUSEDOWN,this.mouseDown);
		}
		/**
		 * This function is used for removing an array of  features 
		 * from the the feature click handler controled features
		 * @param features:Array array of features to remove
		 * */
		public function removeControledFeatures(features:Array=null):void{
			if(features!=null){
				for each(var feature:Feature in features){
					removeControledFeature(feature);
				}
			}
		}
		/**
		 * Add a feature in the feature click handler controled features
		 * @param feature:Feature feature to add
		 * */
		public function addControledFeatures(features:Array):void{
			for each(var feature:Feature in features){
				this.addControledFeature(feature);
			}
		}
		/**
		 * Add an array of features in the feature click handler controled features
		 * @param features:Array array of features to add
		 * */
		public function addControledFeature(feature:Feature):void{
			this._featureArray.push(feature);
			feature.addEventListener(FeatureEvent.FEATURE_MOUSEUP,this.mouseUp);
			feature.addEventListener(FeatureEvent.FEATURE_MOUSEDOWN,this.mouseDown);
		}
		/**
		 * This function is laun
		 * */
		private function dragfeatureStart(event:FeatureEvent):void{
			var vectorfeature:Feature=event.feature as Feature;
			if(Util.indexOf(_featureArray,vectorfeature)!=-1){
			if(this._startDrag!=null) 
				{
				this._startDrag(event);
				this._isdragging=true;
				}
			}
		}
		private function dragfeatureStop(event:FeatureEvent):void{
			var vectorfeature:Feature=event.feature as Feature;
			if(Util.indexOf(_featureArray,_featureEvent.feature)!=-1){
			if(this._stopDrag!=null){
				this._stopDrag(event);
				
				}
				this._isdragging=false;
				_featureEvent=null; 
			}
		}
		public function dropMouseUp(evt:MouseEvent):void{
			if(_featureEvent!=null && _isdragging){
				if(this._stopDrag!=null){
				this._stopDrag(new FeatureEvent(FeatureEvent.FEATURE_DRAG_STOP,_featureEvent.feature));
				this._isdragging=false;
				}
			}
		}
		
		//getters && setters
		/**
		 * double click callback function
		 * */
		public function get doubleclick():Function{
			return this._doubleClick;
		}
		/**
		 * @private
		 * */
		public function set doubleclick(value:Function):void{
			this._doubleClick=value;
		}
		/**
		 *  click callback function
		 * */
		public function get click():Function{
			return this._click;
		}
		public function set click(value:Function):void{
			this._click=value;
		}
		/**
		 * drag callback function
		 * */
		public function get startDrag():Function{
			return this._startDrag;
		}
		/**
		 * @private
		 * */
		public function set startDrag(value:Function):void{
			this._startDrag=value;
		}
		/**
		 * drop callback function
		 * */
		 
		public function get stopDrag():Function{
			return this._stopDrag;
		}
		/**
		 * @private
		 * */
		public function set stopDrag(value:Function):void{
			this._stopDrag=value;
		}
		
		
	}
}