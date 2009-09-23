package org.openscales.core.tile
{
	import com.gskinner.motion.GTweeny;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.layer.Grid;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.ogc.WMS;
	import org.openscales.core.request.DataRequest;

	/**
	 * Image tile are used for example in WMS-C layers to display an image
	 * part of the Grid layer.
	 */
	public class ImageTile extends Tile
	{
		private var _attempt:Number = 0;

		private var _queued:Boolean = false;

		private var _request:DataRequest = null;
		
		private var _loaders:Array = new Array();

		public function ImageTile(layer:Layer, position:Pixel, bounds:Bounds, url:String, size:Size) {
			super(layer, position, bounds, url, size);

			// otherwise you'll get seams between tiles :(
			this.cacheAsBitmap = false;

		}

		override public function destroy():void {
			this.clear();

			while (numChildren > 0) {
				var child:DisplayObject = removeChildAt(0);
				var wr:LoaderWrapper = _loaders.shift();
				
				if (child is Loader) {
					try {
						//Loader(child).unload();
						
						if(wr.loader != child as Loader)
						{
							Trace.error("loader and wrapper not the same");
						}
						
						wr.removeRef();
					}
					catch (error:Error) {
						Trace.error("Error when unloading tile " + this.url);
					}
				}
			}
			
			if(this.layer.contains(this))
				this.layer.removeChild(this);

			super.destroy();
		}

		/**
		 * Check that a tile should be drawn, and draw it.
		 *
		 * @return Always returns true.
		 */
		override public function draw():Boolean {

			//this.clear();

			if (this.layer != this.layer.map.baseLayer) {
				if(_drawPosition != null)
					this.bounds = this.getBoundsFromBaseLayer(_drawPosition);
				else
					this.bounds = this.getBoundsFromBaseLayer(position);
			}
			//if (!super.draw()) {
			//	return false;    
			//}
			if(!withinMapBounds()) {
				return false;    
			}
			if(this.url == null) {
				this.url = this.layer.getURL(this.bounds);
			}

			var cachedLoader:LoaderWrapper = null;	

			//If the tile (loader) was already loaded and is in the cache, we draw it
			if (this.layer is Grid && (cachedLoader=(this.layer as Grid).getTileCache(this.url)) != null)
				drawLoader(cachedLoader,true);
			else {        	
				if(_request)
					_request.destroy();			     
				_request = new DataRequest(this.url, onTileLoadEnd, this.layer.proxy, this.layer.security, onTileLoadError);
			}
			return true;
		}

		public function onTileLoadEnd(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var loader:Loader = loaderInfo.loader as Loader;
			drawLoader(new LoaderWrapper(loader), false);
		}

		/**
		 * Method to draw the loader (recetly loaded or cached)
		 *
		 * @param loader The loader to draw
		 * @param cached Cached loader or not
		 */
		private function drawLoader(loader:LoaderWrapper, cached:Boolean):void {

			if(this.layer) {
				

				if(_drawPosition != null)
				{/*
					var diff:Pixel = this.position.clone();
					diff.add(-_drawPosition.x, -_drawPosition.y);
					
					if(this.numChildren > 0)
					{
						this.getChildAt(0).x = diff.x;
						this.getChildAt(0).y = diff.y;
					}*/
					this.position = _drawPosition;
					_drawPosition = null;
				}

				this.addChild(loader.loader);
				loader.addRef();
				_loaders.push(loader);
				

				// Tween tile effect 
				if(!this.layer.contains(this))
					this.layer.addChild(this);
				
				if(Map.tween && !(this.layer is WMS)) {
					var tw:GTweeny = new GTweeny(this, 0.3, {alpha:1});
					tw.addEventListener(Event.COMPLETE, removeReference, false, 0, true);
					//removeReference(null);
				} else {
					removeReference(null);
					this.alpha = 1;
				} 
				

				
				this.drawn = true;

				//We put the loader into the cache if it's a recently loaded
				if (this.layer is Grid && !cached)
					(this.layer as Grid).addTileCache(loader.loader.name,loader);
			}
		}
		
		private function removeReference(event:Event):void
		{
			var al:Number = this.alpha;
			
			if(numChildren > 1)
				clear();
				
			this.alpha = al;
		}

		public function onTileLoadError(event:IOErrorEvent):void
		{

			if (++this._attempt > this.layer.map.IMAGE_RELOAD_ATTEMPTS) {
				Trace.error("Error when loading tile " + this.url);
				return;
			}

			// retry load
			Trace.info("Retry " + this._attempt + " tile " + this.url);
			this.url = this.layer.getURL(this.bounds);
			this.draw();
		}

		/**
		 *  Clear the tile of any bounds/position-related data
		 */
		override public function clear():void {
			super.clear();
			this.alpha = 0;

			if(_request)
				_request.destroy();	

			if (this.numChildren >0)
			{
				var d:DisplayObject = this.removeChildAt(0);
				var wr:LoaderWrapper = _loaders.shift();
				if(wr.loader != d)
				{
					Trace.error("DisplayObject not same as Loader in LoaderWrapper.");
				}
				wr.removeRef();
			}
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

