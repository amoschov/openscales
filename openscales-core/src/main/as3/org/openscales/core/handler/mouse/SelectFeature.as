package org.openscales.core.handler.mouse
{
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.control.ui.CheckBox;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.VectorLayer;
	
	/**
	 * 
	 * SelectFeature is use to select feature by hover
	 * Create a new instance of  SelectFeature with the constructor 
	 * 
	 * To use this handler, it's  necessary to add it to the map
	 * SelectFeature is a pure ActionScript class. Flex wrapper and components can be found in the
	 * openscales-fx module FxSelectFeature.
	 */
	public class SelectFeature extends Handler
	{
		/**
		 * Callback's function
		 */
		private var _select:Function=null;
		private var _unselect:Function=null;
		
		private var _layer:VectorLayer;
		private var _lastfeature:VectorFeature=null;
		private var _currentfeature:VectorFeature=null;
		//Accept hover or not
		private var _hover:Boolean=true;
		
		private var _startPixel:Pixel=null;
		
		public function SelectFeature(map:Map=null,layer:VectorLayer=null,active:Boolean=false)
		{
			super(map,active);
			this.layer=layer;
		}
		
		override protected function registerListeners():void{
			this.map.addEventListener(FeatureEvent.FEATURE_OVER,this.OnOver);
			this.map.addEventListener(FeatureEvent.FEATURE_OUT,this.OnOut);
			this.map.addEventListener(FeatureEvent.FEATURE_MOUSEDOWN, this.onMouseDown);
			this.map.addEventListener(FeatureEvent.FEATURE_MOUSEUP, this.onMouseUp);	
			
		}
		override protected function unregisterListeners():void{
			this.map.removeEventListener(FeatureEvent.FEATURE_OVER,this.OnOver);
			this.map.removeEventListener(FeatureEvent.FEATURE_OUT,this.OnOut);
			this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEDOWN, this.onMouseDown);
			this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEUP, this.onMouseUp);
		}
	
		public function OnOut(pevt:FeatureEvent):void
		{
			if(pevt.vectorfeature.layer==this.layer)
			{
				if(this._unselect!=null)this._unselect(pevt);
			}
		}
		public function OnOver(pevt:FeatureEvent):void
		{
			if(hover)
			{
				if(pevt.vectorfeature.layer==this.layer)
				{
				if(this._select!=null) this._select(pevt);
				}
			}
		}
		

		public function onMouseUp(pevt:FeatureEvent):void
		{
			if(!this.hover)
			{
				if((this._startPixel.x-pevt.vectorfeature.layer.mouseX==0)&&(this._startPixel.y-pevt.vectorfeature.layer.mouseY==0))
				{
					if(this._select!=null)this._select(pevt);
				}						
			}
		}
		public function onMouseDown(pevt:FeatureEvent):void
		{
			if(!this.hover)
			{
				this._startPixel=new Pixel(pevt.vectorfeature.layer.mouseX,pevt.vectorfeature.layer.mouseY);		
				if(this._unselect!=null)this._unselect(pevt);
			}
		}
	
		//Properties
		public function  get select():Function
		{
			return this._select;
		}
		public function set select(select:Function):void
		{
			this._select=select;
		}
		public function  get unselect():Function
		{
			return this._unselect;
		}
		public function set unselect(unselect:Function):void
		{
			this._unselect=unselect;
		}
		public function  get layer():VectorLayer
		{
			return this._layer;
		}
		public function set layer(layer:VectorLayer):void
		{
			this._layer=layer;
		}
		
		public function  get hover():Boolean
		{
			return this._hover;
		}
		public function set hover(hover:Boolean):void
		{
			this._hover=hover;
		}
		
		public function  get lastfeature():VectorFeature
		{
			return this._lastfeature;
		}
		public function set lastfeature(lastfeature:VectorFeature):void
		{
			this._lastfeature=lastfeature;
		}
		
		public function  get currentfeature():VectorFeature
		{
			return this._currentfeature;
		}
		public function set currentfeature(currentfeature:VectorFeature):void
		{
			this._currentfeature=currentfeature;
		}
		
		
	}
}