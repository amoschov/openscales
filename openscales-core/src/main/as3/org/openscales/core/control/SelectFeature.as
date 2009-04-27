package org.openscales.core.control
{
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.layer.VectorLayer;
	
	public class SelectFeature extends Control
	{
		private var _select:Function=null;
		private var _unselect:Function=null;
		private var _layer:VectorLayer;
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
				this.map.addEventListener(FeatureEvent.FEATURE_HOVER,this.Onhover);
			}
			
		}
		public function deactivate():void
		{
			this.active=false;
			this.removeEventListener(FeatureEvent.FEATURE_HOVER,this.Onhover);
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
		
		
		
		
		
		
		private function Onhover(pevt:FeatureEvent):void
		{
			if(pevt.vectorfeature.layer==this.layer && this.hover) 
			{
				if(pevt.isselect) this.select(pevt);
				else this.unselect(pevt);				
			}
			
		}
	}
}