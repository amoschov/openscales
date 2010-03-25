package org.openscales.core.tile
{
	import flash.display.Sprite;
	
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.events.TileEvent;
	import org.openscales.core.layer.Grid;
	import org.openscales.core.layer.Layer;

	/**
	 *  A tile maybe a single tile (for example in WMS or WFS) or part of a Grid
	 *  like in WMS-C. It is a graphical Sprite that use the draw function to
	 *  display itself.
	 */
	public class Tile extends Sprite
	{

		private var _layer:Layer = null;
		private var _url:String = null;
		private var _bounds:Bounds = null;
		private var _size:Size = null;
		private var _drawn:Boolean = false;
		private var _onLoadStart:Function = null;
		private var _onLoadEnd:Function = null;
		private var _loading:Boolean = false;
		protected var _drawPosition:Pixel = null;

		public function Tile(layer:Layer, position:Pixel, bounds:Bounds, url:String, size:Size) {
			this.layer = layer;
			this.position = position;
			this.bounds = bounds;
			this.url = url;
			this.size = size;       
		}

		public function destroy():void {
			this.layer = null;
			this.bounds = null;
			this.size = null;
			this.position = null;

		}


		/**
		 * Clear whatever is currently in the tile, then return whether or not
		 *     it should actually be re-drawn.
		 *
		 * @return Whether or not the tile should actually be drawn.
		 */
		public function draw():Boolean {
			this.clear();
			return withinMapBounds();
		}
		
		public function withinMapBounds():Boolean
		{
			return (((this.layer.maxExtent
				&& this.bounds.intersectsBounds(this.layer.maxExtent, false)))
				&& !((this.layer as Grid != null) && ((this.layer as Grid).buffer == 0)
				&& !this.bounds.intersectsBounds(this.layer.map.extent, false)));
		}
		
		public function moveTo(bounds:Bounds, position:Pixel, redraw:Boolean = true):void 
		{
			this.bounds = bounds.clone();
			
			_drawPosition = position.clone();
			this.url = this.layer.getURL(this.bounds);
			
			if (redraw) 
			{
				this.draw();
			}	
		}
		/**/
		/**
		 * Reposition the tile.
		 *
		 * @param bounds
		 * @param position
		 * @param redraw
		 */
		public function clearAndMoveTo(bounds:Bounds, position:Pixel, redraw:Boolean = true):void
		{
			this.clear();
			this.bounds = bounds.clone();
			this.position = position.clone();
			_drawPosition = null;
			this.url = this.layer.getURL(this.bounds);
			if (redraw) {
				this.draw();
			}	
		}

		public function clear():void {
			this.drawn = false;
		}

		/**
		 * Take the pixel locations of the corner of the tile, and pass them to
		 *     the base layer and ask for the location of those pixels
		 *
		 * @param position
		 *
		 * @return bounds
		 */
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

		//Getters and Setters
		public function get layer():Layer {
			return this._layer;
		}

		public function set layer(value:Layer):void {
			this._layer = value;
		}

		public function get url():String {
			return this._url;
		}

		public function set url(value:String):void {
			this._url = value;
		}

		public function get bounds():Bounds {
			return this._bounds;
		}

		public function set bounds(value:Bounds):void {
			this._bounds = value;
		}

		public function get size():Size {
			return this._size;
		}

		public function set size(value:Size):void {
			this._size = value;
		}

		public function get drawn():Boolean {
			return this._drawn;
		}

		public function set drawn(value:Boolean):void {
			this._drawn = value;
		}

		public function get onLoadStart():Function {
			return this._onLoadStart;
		}

		public function set onLoadStart(value:Function):void {
			this._onLoadStart = value;
		}

		public function get onLoadEnd():Function {
			return this._onLoadEnd;
		}

		public function set onLoadEnd(value:Function):void {
			this._onLoadEnd = value;
		}

		/**
		 * Whether or not the tile is loading
		 */
		public function get loadComplete():Boolean {
			return !this._loading;
		}
		
		/**
		 * Used to set loading status of tile
		 */
		protected function set loading(value:Boolean):void {
			if (value == true && this._loading == false) {
				this._loading = value;
				// to inform layer that loading of tile has been started
				this.layer.dispatchEvent(new TileEvent(TileEvent.TILE_LOAD_START,this));
			}	

			if (value == false && this._loading == true) {
				this._loading = value;
				// to inform layer that loading of tile has been ended				
				this.layer.dispatchEvent(new TileEvent(TileEvent.TILE_LOAD_END,this));		
			}		
		}
	}
}

