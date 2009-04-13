package org.openscales.fx.layer
{
	import flash.display.DisplayObject;
	
	import org.openscales.core.layer.WFS;
	import org.openscales.fx.feature.FxStyle;

	public class FxWFS extends FxLayer
	{
		public function FxWFS()
		{
			super();
		}
		
		override public function init():void {
			this._layer = new WFS("", "", new Object());
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			for(var i:int=0; i < this.rawChildren.numChildren ; i++) {
				var child:DisplayObject = this.rawChildren.getChildAt(i);
				if(child is FxStyle) {
					(this.layer as WFS).style = (child as FxStyle).style;
				}
			}
		}
		
		public function set url(value:String):void {
	    	if(this.layer != null)
	    		(this.layer as WFS).url = value;
	    }
	    
	    public function set params(value:Object):void {
	    	if(this.layer != null)
	    		(this.layer as WFS).params = value;
	    }
		
		public function set typename(value:String):void {
	    	if(this.layer != null)
	    		(this.layer as WFS).params.typename = value;
	    }
	    
	    public function set srs(value:String):void {
	    	if(this.layer != null)
	    		(this.layer as WFS).params.SRS = value;
	    }
	    
	    public function set version(value:String):void {
	    	if(this.layer != null)
	    		(this.layer as WFS).params.VERSION = value;
	    }
	    
	}
}