package org.openscales.core.control
{
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.layer.VectorLayer;
	public class SelectFeature extends Control
	{
		private var _select:Function=null;
		private var _unselect:Function=null;
		private var _layer:VectorLayer;
		private var _lastfeature:VectorFeature=null;
		private var _currentfeature:VectorFeature=null;
		//Accept hover or not
		private var _hover:Boolean=true;
		
		public function SelectFeature(layer:VectorLayer,options:Object)
		{
			super();
			this.select=options.select;
			this.unselect=options.unselect;
			if(options.hover is Boolean) this.hover=options.hover;
			this.layer=layer;
		}
		
		public  function activate():void
		{
			if(!this.active)
			{
				this.active=true;
				this.map.addEventListener(FeatureEvent.FEATURE_OVER,this.select);
				this.map.addEventListener(FeatureEvent.FEATURE_OUT,this.unselect);
			}
			
		}
		public function deactivate():void
		{
			this.active=false;
			this.removeEventListener(FeatureEvent.FEATURE_OVER,this.select);
			this.removeEventListener(FeatureEvent.FEATURE_OUT,this.unselect);
		}

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