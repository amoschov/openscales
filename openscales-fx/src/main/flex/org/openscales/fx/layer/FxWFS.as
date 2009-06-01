package org.openscales.fx.layer
{
	import org.openscales.proj4as.ProjProjection;
	
	import flash.display.DisplayObject;
	
	import org.openscales.core.feature.Style;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.ogc.WFS;
	import org.openscales.fx.feature.FxStyle;

	public class FxWFS extends FxLayer
	{
		private var _url:String;
		
		private var _params:Object;
		
		private var _style:Style;
		
		private var _minZoomLevel:Number;
		
		private var _isBaseLayer:Boolean;
		
		private var _projection:String;
		
		
		public function FxWFS()
		{
			super();
			this._params = new Object();
			this._isBaseLayer = false;
		}
		
		override public function init():void {
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			for(var i:int=0; i < this.rawChildren.numChildren ; i++) {
				var child:DisplayObject = this.rawChildren.getChildAt(i);
				if(child is FxStyle) {
					this._style = (child as FxStyle).style;
				}
			}
		}
		
		override public function getInstance():Layer {
			this._layer = new WFS("", this._url, this._params, this._isBaseLayer, true, this._projection);
			if (this._style != null)
				(this._layer as WFS).style = this._style;
				
			this._layer.minZoomLevel = this._minZoomLevel;
						
			return this._layer;
		}
				
		public function set url(value:String):void {
	    	this._url = value;
	    }
	    
	    public function set params(value:Object):void {
	    	this._params = value;
	    }
		
		public function set typename(value:String):void {
	    	this._params.typename = value;
	    }
	    
	    public function set srs(value:String):void {
	    	if (value != null) {
	    		this._params.SRS = value;
	    		this._projection = value;
	    	}	    	
	    }
	    
	    public function set version(value:String):void {
	    	this._params.VERSION = value;
	    }
	    
	    override public function set minZoomLevel(value:Number):void {
	    	this._minZoomLevel = value;
	    }
	    
	    override public function set isBaseLayer(value:Boolean):void {
	    	this._isBaseLayer = value;
	    }
	    
	}
}