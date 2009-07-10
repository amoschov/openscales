package org.openscales.core.tile
{
	import com.gskinner.motion.GTweeny;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.layer.Grid;
	import org.openscales.core.layer.Layer;
	
	/**
	 * Instances of OpenLayers.Tile.Image are used to manage the image tiles
	 * used by various layers.
	 */
	public class ImageTile extends Tile
	{
		private var _queued:Boolean = false;
		
		private var _tileLoader:Loader = null;
		
		public function ImageTile(layer:Layer, position:Pixel, bounds:Bounds, url:String, size:Size):void {
			super(layer, position, bounds, url, size);
			
			// otherwise you'll get seams between tiles :(
			this.cacheAsBitmap = false;
			
			_tileLoader = new Loader();
		}
		
		override public function destroy():void {
			this.clear();
			
			while (numChildren > 0) {
	    		var child:DisplayObject = removeChildAt(0);
	    		if (child is Loader) {
	    			try {
	    				Loader(child).unload();
	    			}
	    			catch (error:Error) {
	    				Trace.error("Error when unloading tile " + this.url);
	    			}
	    		}
	    	}

	        super.destroy();
		}
		
		/**
	     * Check that a tile should be drawn, and draw it.
	     * 
	     * @return Always returns true.
	     */
		override public function draw():Boolean {
			
			this.clear();
			
		    if (this.layer != this.layer.map.baseLayer) {
	            this.bounds = this.getBoundsFromBaseLayer(this.position);
	        }
	        if (!super.draw()) {
	            return false;    
	        }
	        if(this.url == null) {
	        	this.url = this.layer.getURL(this.bounds);
	        }
	        
	        var cachedLoader:Loader = null;	
	        
	        //If the tile (loader) was already loaded and is in the cache, we draw it
	        if (this.layer is Grid && (cachedLoader=(this.layer as Grid).getTileCache(this.url)) != null)
	        	drawLoader(cachedLoader,true);
	        else {
	        	//We instanciate a new Loader to avoid the cached loader loss
		        _tileLoader = new Loader();
		        	
		        //We add the proxy to the url (to avoid crossdomain issue in case of zoom tween effect (bitmapdata.draw))
		        if (this.layer.proxy != null) {
		        	var urlProxy:String = this.layer.proxy + encodeURIComponent(this.url);
		        	_tileLoader.load(new URLRequest(urlProxy));
		        }
		        else {
		        	_tileLoader.load(new URLRequest(this.url));
		        }
		        
		        _tileLoader.name=this.url;
		        _tileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTileLoadEnd, false, 0, true);
				_tileLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onTileLoadError, false, 0, true);
	        }
	        
	       
			
	        return true;
		}
		
		public function onTileLoadEnd(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var loader:Loader = loaderInfo.loader as Loader;
			drawLoader(loader, false);
		}
		
		/**
		 * Method to draw the loader (recetly loaded or cached)
		 * 
		 * @param loader The loader to draw
		 * @param cached Cached loader or not
		 */
		private function drawLoader(loader:Loader, cached:Boolean):void {
			
			if(this.layer) {

				this.addChild(loader);
				
				// Tween tile effect 
				this.layer.addChild(this);
				if(Map.tween) {
					new GTweeny(this, 0.3, {alpha:1});
				} else {
					this.alpha = 1;
				} 
				this.drawn = true;
				
				//We put the loader into the cache if it's a recently loaded
				if (this.layer is Grid && !cached)
					(this.layer as Grid).addTileCache(loader.name,loader);
			}
		}
		
		private function onTileLoadError(event:IOErrorEvent):void
		{
			Trace.error("Error when loading tile " + this.url);
		}
		
		/** 
	     *  Clear the tile of any bounds/position-related data
	     */
		override public function clear():void {
			super.clear();
	        this.alpha = 0;
	        
	        try {_tileLoader.close();}catch(e:Error){};
	        
	        _tileLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onTileLoadEnd);
	        _tileLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onTileLoadError);
	        
	        if (this.numChildren >0)
	        	this.removeChildAt(0);
	        //graphics.clear();
        }
        
        //Getters and Setters
        public function get queued():Boolean {
        	return this._queued;
        }
        
        public function set queued(value:Boolean):void {
        	this._queued = value;
        }
		
	}
}