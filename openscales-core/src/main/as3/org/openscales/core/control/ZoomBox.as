package org.openscales.core.control
{
	import flash.display.Sprite;
	
	import org.openscales.core.control.Control;
	import org.openscales.commons.basetypes.Bounds;
	import org.openscales.commons.basetypes.LonLat;
	import org.openscales.commons.basetypes.Pixel;
	import org.openscales.core.handler.Box;

	public class ZoomBox extends Control
	{
		
		public var ctype:int = Control.TYPE_TOOL;

    	public var out:Boolean = false;
    	
    	public function ZoomBox(options:Object = null):void {
    		
    	}
    	
    	override public function draw():void {
    		var box:Box = new Box( this, {keyMask: this.keyMask} );
    		box.done = this.zoomBox;
    		this.handler = box;
            
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
	                var extent:Bounds = map.extent;
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