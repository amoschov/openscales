package org.openscales.core.tile
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.openscales.core.event.OpenScalesEvent;
	import org.openscales.core.Layer;
	import org.openscales.core.Tile;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	
	public class Image extends Tile
	{
		public var queued:Boolean = false;
		
		public function Image(layer:Layer, position:Pixel, bounds:Bounds, url:String, size:Size):void {
			super(layer, position, bounds, url, size);
			
			// otherwise you'll get seams between tiles :(
			this.cacheAsBitmap = true;
		}
		
		override public function destroy():void {
	        OpenScalesEvent.stopObservingElement(Event.COMPLETE, this);
	        OpenScalesEvent.stopObservingElement(IOErrorEvent.IO_ERROR, this);
			
			while (numChildren > 0) {
	    		var child:DisplayObject = removeChildAt(0);
	    		if (child is Loader) {
	    			try {
	    				Loader(child).unload();
	    			}
	    			catch (error:Error) {
	    				trace("Error when unloading tile " + this.url);
	    			}
	    		}
	    	}
	    	graphics.clear();

	        super.destroy();
		}
		
		override public function draw():Boolean {
		    if (this.layer != this.layer.map.baseLayer) {
	            this.bounds = this.getBoundsFromBaseLayer(this.position);
	        }
	        if (!super.draw()) {
	            return false;    
	        }
	        
	        this.url = this.layer.getURL(this.bounds);
	        	
	        this.x = this.position.x;
			this.y = this.position.y;
	        
	        var tileLoader:Loader = new Loader();
	        tileLoader.load(new URLRequest(this.url));
	        tileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTileLoadEnd, false, 0, true);
			tileLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onTileLoadError, false, 0, true);
			
	        return true;
		}
		
		public function onTileLoadEnd(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var loader:Loader = loaderInfo.loader as Loader;
			this.addChild(loader);
            this.alpha=1;
			this.layer.addChild(this);
			this.drawn = true;
		}
		
		private function onTileLoadError(event:IOErrorEvent):void
		{
			trace("Error when loading tile " + this.url);

		}
		
		override public function clear():void {
			super.clear();
	        this.alpha = 0.0;
        }
		
		
	}
}