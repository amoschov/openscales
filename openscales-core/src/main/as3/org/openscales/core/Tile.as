package org.openscales.core
{
	import flash.display.Sprite;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.event.Events;

	public class Tile extends Sprite
	{
		
		public var EVENT_TYPES:Array = ["loadstart", "loadend", "reload"];
		public var events:Events = null;
		public var id:String = null;
		public var layer:Layer = null;
		public var url:String = null;
		public var bounds:Bounds = null;
		public var size:Size = null;
		public var drawn:Boolean = false;
		public var postBody:Object = null;
		public var BBOX:Bounds = null;
		public var onLoadStart:Function = null;
		public var onLoadEnd:Function = null;
		
		public function Tile(layer:Layer, position:Pixel, bounds:Bounds, url:String, size:Size, params:Object = null):void {
			this.layer = layer;
	        this.position = position;
	        this.bounds = bounds;
	        this.url = url;
	        this.size = size;
	        if (params != null) {
	        	this.postBody = params.postBody;
	        	this.BBOX = params.BBOX;
	        }

	        this.id = Util.createUniqueID("Tile_");
	        
	        this.events = new Events(this, null, this.EVENT_TYPES);
		}
		
		public function destroy():void {
			this.layer = null;
	        this.bounds = null;
	        this.size = null;
	        this.position = null;
	        
	        this.events.destroy();
	        this.events = null;
		}
		
		public function draw():Boolean {
	        this.clear();
        	return ((this.layer.displayOutsideMaxExtent
                || (this.layer.maxExtent
                    && this.bounds.intersectsBounds(this.layer.maxExtent, false)))
                && !(this.layer.buffer == 0
                     && !this.bounds.intersectsBounds(this.layer.map.extent, false)));
		}
		
		public function moveTo(bounds:Bounds, position:Pixel, redraw:Boolean = true):void {
	
	        this.clear();
	        this.bounds = bounds.clone();
	        this.position = position.clone();
	        this.url = this.layer.getURL(this.bounds);
	        if (redraw) {
	            this.draw();
	        }	
		}
		
		public function clear():void {
			this.drawn = false;
		}
		
		public function getBoundsFromBaseLayer(position:Pixel):Bounds {
			var topLeft:LonLat = this.layer.map.getLonLatFromLayerPx(position); 
	        var bottomRightPx:Pixel = position.clone();
	        bottomRightPx.x += this.size.w;
	        bottomRightPx.y += this.size.h;
	        var bottomRight:LonLat = this.layer.map.getLonLatFromLayerPx(bottomRightPx); 
	        if (topLeft.lon > bottomRight.lon) {
	            if (topLeft.lon < 0) {
	                topLeft.lon = -180 - (topLeft.lon+180);
	            } else {
	                bottomRight.lon = 180+bottomRight.lon+180;
	            }        
	        }
	        bounds = new Bounds(topLeft.lon, bottomRight.lat, bottomRight.lon, topLeft.lat);  
	        return bounds;
		}
		
		public function get position():Pixel
		{
			return new Pixel(this.x, this.y);
		}
		public function set position(value:Pixel):void
		{
			if(value) {
				this.x = value.x;
				this.y = value.y;
			}
		}
		
	}
}