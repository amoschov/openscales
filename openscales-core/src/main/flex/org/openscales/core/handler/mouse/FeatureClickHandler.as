package org.openscales.core.handler.mouse
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.handler.Handler;
	/**
	 * This handler has been created in particurlaly for 
	 * double click event on the vector feature dispatching
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
		
		
		public function FeatureClickHandler(map:Map=null, active:Boolean=false)
		{
			super(map, active);
			this._featureArray=new Array();		
		}
		/**
		 * Event Management
		 * */
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
		private  function chooseClick(event:TimerEvent):void{
			if(_clickNum == 1) {
				if(_click != null)
				{
				if(Util.indexOf(_featureArray,_featureEvent.feature)!=-1){
				_click(_featureEvent);
				}
				_timer.stop();
				_clickNum=0;
				}
			}    
			else {
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
			var vectorFeature:VectorFeature=evt.feature as VectorFeature;
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
				if(Math.abs(tmppx.x-this._StartPixel.x)<this._draggingTolerance && Math.abs(tmppx.y-this._StartPixel.y)<this._draggingTolerance)
				{
					_isdragging=false;
				}
			}
			if(!_isdragging)
			{
			if(this._StartPixel!=null){
				//dx and dy variables are use to know if there was a drag or a click
				var vectorFeature:VectorFeature=evt.feature as VectorFeature;
				var dx :Number = Math.abs(this._StartPixel.x-evt.feature.layer.mouseX);
				var dy :Number = Math.abs(this._StartPixel.y-evt.feature.layer.mouseY);
				if(dx<=this._tolerance && dy<=this._tolerance)
				{
					this.featureClick(evt);
				}
			}
			}
			else dragfeatureStop(this._featureEvent);		
		}
		private function featureClick(evt:FeatureEvent):void
		{
			_featureEvent = evt;
			_clickNum++;
			_timer.start() 
		}
		public function removeControledFeature(feature:VectorFeature):void{
			Util.removeItem(this._featureArray,feature);
			feature.removeEventListener(FeatureEvent.FEATURE_MOUSEUP,this.mouseUp);
			feature.removeEventListener(FeatureEvent.FEATURE_MOUSEDOWN,this.mouseDown);
		}
		public function removeControledFeatures(features:Array=null):void{
			if(features==null){
				for(var i:int=0;i<features.length;i++){
					features.pop();
				}
			}
			else{
				for each(var feature:VectorFeature in features){
					removeControledFeature(feature);
				}
			}
		}
		public function addControledFeatures(features:Array):void{
			for each(var feature:VectorFeature in features){
				this.addControledFeature(feature);
			}
		}
		public function addControledFeature(feature:VectorFeature):void{
			this._featureArray.push(feature);
			feature.addEventListener(FeatureEvent.FEATURE_MOUSEUP,this.mouseUp);
			feature.addEventListener(FeatureEvent.FEATURE_MOUSEDOWN,this.mouseDown);
		}
		
		public function dragfeatureStart(event:FeatureEvent):void{
			var vectorfeature:VectorFeature=event.feature as VectorFeature;
			if(Util.indexOf(_featureArray,vectorfeature)!=-1){
				//vectorfeature.buttonMode=true;
				
		//		vectorfeature.startDrag();
				//we dispatch an event for the edition point feature
		//		if(vectorfeature.isEditionFeature)this.map.dispatchEvent(new FeatureEvent(FeatureEvent.EDITION_POINT_FEATURE_DRAG_START,vectorfeature));
			if(this._startDrag!=null) 
				{
				this._startDrag(event);
				this._isdragging=true;
				}
			}
		}
		public function dragfeatureStop(event:FeatureEvent):void{
			var vectorfeature:VectorFeature=event.feature as VectorFeature;
			if(Util.indexOf(_featureArray,_featureEvent.feature)!=-1){
				//vectorfeature.buttonMode=false;
				//vectorfeature.stopDrag();
				
		//	if(vectorfeature.isEditionFeature)this.map.dispatchEvent(new FeatureEvent(FeatureEvent.EDITION_POINT_FEATURE_DRAG_STOP,vectorfeature));
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
		public function get doubleclick():Function{
			return this._doubleClick;
		}
		public function set doubleclick(value:Function):void{
			this._doubleClick=value;
		}
		public function get click():Function{
			return this._click;
		}
		public function set click(value:Function):void{
			this._click=value;
		}
		public function set startDrag(value:Function):void{
			this._startDrag=value;
		}
		
		public function get startDrag():Function{
			return this._startDrag;
		}
		
		public function set stopDrag(value:Function):void{
			this._stopDrag=value;
		}
		public function get stopDrag():Function{
			return this._stopDrag;
		}
		
	}
}