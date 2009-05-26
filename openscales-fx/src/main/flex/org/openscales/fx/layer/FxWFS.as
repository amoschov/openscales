package org.openscales.fx.layer
{
	import com.gradoservice.proj4as.ProjProjection;
	
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
		
		private var _projection:ProjProjection;
		
		
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
			this._layer = new WFS("", this._url, this._params);
			if (this._style != null)
				(this._layer as WFS).style = this._style;
			this._layer.isBaseLayer = this._isBaseLayer;
			this._layer.minZoomLevel = this._minZoomLevel;
			this._layer.projection = this._projection;
						
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
	    	this._params.SRS = value;
	    	if (value != null) {
	    		this._projection = new ProjProjection(value);
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