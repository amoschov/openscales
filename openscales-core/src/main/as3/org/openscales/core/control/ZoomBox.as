package org.openscales.core.control
{
	import flash.display.Sprite;
	
	import org.openscales.core.Control;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.handler.Box;

	public class ZoomBox extends Control
	{
		
		public var ctype:int = Control.TYPE_TOOL;

    	public var out:Boolean = false;
    	
    	public function ZoomBox(options:Object = null):void {
    		
    	}
    	
    	override public function draw(toSuper:Boolean = false):void {
    		this.handler = new Box( this,
                            {done: this.zoomBox}, {keyMask: this.keyMask} );
            
    	}
    	
    	public function zoomBox(position:*):void {
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
	                var zoomFactor:Number = Math.min((this.map.size.h / pixHeight),
	                    (this.map.size.w / pixWidth));
	                var extent:Bounds = map.getExtent();
	                var center:LonLat = this.map.getLonLatFromPixel(
	                    position.getCenterPixel());
	                var xmin:Number = center.lon - (extent.getWidth()/2)*zoomFactor;
	                var xmax:Number = center.lon + (extent.getWidth()/2)*zoomFactor;
	                var ymin:Number = center.lat - (extent.getHeight()/2)*zoomFactor;
	                var ymax:Number = center.lat + (extent.getHeight()/2)*zoomFactor;
	                bounds = new Bounds(xmin, ymin, xmax, ymax);
	            }
	            this.map.zoomToExtent(bounds);
	        } else { // it's a pixel
	            if (!this.out) {
	                this.map.setCenter(this.map.getLonLatFromPixel(position),
	                               this.map.zoom + 1);
	            } else {
	                this.map.setCenter(this.map.getLonLatFromPixel(position),
	                               this.map.zoom - 1);
	            }
	        }
    	}
    			
	}
}