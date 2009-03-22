package org.openscales.core.control
{
	import org.openscales.core.CanvasOL;
	import org.openscales.core.Control;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.handler.Box;
	//import edu.psu.geovista.helpers.MapHelper;

	public class SelectFeatureBox extends Control
	{
		
		public var ctype:int = Control.TYPE_TOOL;

    	public var out:Boolean = false;
    	
    	
    	public function SelectFeatureBox(options:Object = null):void {
    	}
    	
    	override public function draw(px:Pixel = null, toSuper:Boolean = false):CanvasOL {
    		this.handler = new Box( this,
                            {done: this.selectBox}, {keyMask: this.keyMask} );
            return null;
    	}
    	
    	public function selectBox(position:*):void {
    		if (position is Bounds) {
	            if (!this.out) {
	                var minXY:LonLat = this.map.getLonLatFromPixel(
	                            new Pixel(position.left, position.bottom));
	                var maxXY:LonLat = this.map.getLonLatFromPixel(
	                            new Pixel(position.right, position.top));
	                var bounds:Bounds = new Bounds(minXY.lon, minXY.lat,
	                                               maxXY.lon, maxXY.lat);
	            } else {
	                var pixWidth:Number = Math.abs(position.right-position.left);
	                var pixHeight:Number = Math.abs(position.top-position.bottom);
	                var zoomFactor:Number = Math.min((this.map.size.h / pixHeight), (this.map.size.w / pixWidth));
	                var extent:Bounds = this.map.getExtent();
	                var center:LonLat = this.map.getLonLatFromPixel(
	                    position.getCenterPixel());
	                var xmin:Number = center.lon - (extent.getWidth()/2)*zoomFactor;
	                var xmax:Number = center.lon + (extent.getWidth()/2)*zoomFactor;
	                var ymin:Number = center.lat - (extent.getHeight()/2)*zoomFactor;
	                var ymax:Number = center.lat + (extent.getHeight()/2)*zoomFactor;
	                bounds = new Bounds(xmin, ymin, xmax, ymax);
	            }
	            //this.map.zoomToExtent(bounds);
	            //mapHelper.selectByBounds(bounds);
	        } else { // it's a pixel
	        	// Do nothing in our case
	      /*      if (!this.out) {
	                this.map.setCenter(this.map.getLonLatFromPixel(position),
	                               this.map.getZoom() + 1);
	            } else {
	                this.map.setCenter(this.map.getLonLatFromPixel(position),
	                               this.map.getZoom() - 1);
	            }*/
	        }
    	}
    	
	}
}