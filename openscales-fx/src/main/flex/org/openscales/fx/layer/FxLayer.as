package org.openscales.fx.layer
{
	import mx.core.Container;
	
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
	    
	    override public function set visible(value:Boolean):void {
	    	if(this.layer != null)
	    		this.layer.visible = value;
	    }
		
	}
}