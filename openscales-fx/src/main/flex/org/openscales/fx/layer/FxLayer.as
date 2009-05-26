package org.openscales.fx.layer
{
	import mx.core.Container;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.layer.Layer;

	public class FxLayer extends Container
	{
		protected var _layer:Layer;
			
		public function FxLayer()
		{
			this.init();
			super();
		}
		
		public function init():void {
			
		}
				
		public function get layer():Layer {
			return this._layer;
		}
		
		public function getInstance():Layer {
			return this._layer;
		}
		
		public function set isBaseLayer(value:Boolean):void {
	    	if(this.layer != null)
	    		this.layer.isBaseLayer = value;
	    }
	    
	    public function set minZoomLevel(value:Number):void {
	    	if(this.layer != null)
	    		this.layer.minZoomLevel = value;
	    }
	    
	    public function set minResolution(value:Number):void {
	    	if(this.layer != null)
	    		this.layer.minResolution = value;
	    }
	    
	    public function set maxResolution(value:Number):void {
	    	if(this.layer != null)
	    		this.layer.maxResolution = value;
	    }
	    
	    public function set numZoomLevels(value:Number):void {
	    	if(this.layer != null)
	    		this.layer.numZoomLevels = value;
	    }
	    
	    public function set maxExtent(value:String):void {
	    	if(this.layer != null)
	    		this.layer.maxExtent = Bounds.getBoundsFromString(value);
	    }
	    
	    override public function set visible(value:Boolean):void {
	    	if(this.layer != null)
	    		this.layer.visible = value;
	    }
		
	}
}