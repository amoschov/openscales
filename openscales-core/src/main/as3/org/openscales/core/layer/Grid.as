package org.openscales.core.layer
{
	import flash.display.Loader;
	import flash.events.EventDispatcher;

	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.layer.params.AbstractParams;
	import org.openscales.core.layer.params.IHttpParams;
	import org.openscales.core.tile.ImageTile;
	import org.openscales.core.tile.Tile;

	/**
	 * Base class for layers that use a lattice of tiles.
	 *
	 * @author Bouiaw
	 */
	public class Grid extends HTTPRequest
	{

		private var _grid:Array = null;

		private var _singleTile:Boolean = false;

		private var _ratio:Number = 1.5;

		private var _numLoadingTiles:int = 0;

		private var _origin:Pixel = null;

		private var _tileSize:Size = null;

		private var _buffer:Number;

		private const CACHE_SIZE:int = 256;

		private var cachedTiles:HashMap = null;
		private var cachedTilesUrl:Array = null;
		private var cptCached:int = 0;


		/**
		 * Create a new grid layer
		 *
		 * @param name
		 * @param url
		 * @param params
		 * @param isBaseLayer
		 * @param visible
		 * @param projection
		 * @param proxy
		 */
		public function Grid(name:String, url:String, params:IHttpParams = null, isBaseLayer:Boolean = false, 
			visible:Boolean = true, projection:String = null, proxy:String = null) {

			//TOdo delete url and params after osmparams work
			super(name, url, params, isBaseLayer, visible, projection, proxy);

			this.grid = new Array();

			this.buffer = 1;

			cachedTiles = new HashMap();
			cachedTilesUrl = new Array(CACHE_SIZE);
		}

		override public function destroy(newBaseLayer:Boolean = true):void {
			this.clearGrid();
			this.grid = null;
			super.destroy(); 
		}

		/**
		 * Go through and remove all tiles from the grid, calling
		 *    destroy() on each of them to kill circular references
		 */
		public function clearGrid():void {
			if (this.grid) {
				for(var iRow:int=0; iRow < this.grid.length; iRow++) {
					var row:Array = this.grid[iRow];
					for(var iCol:int=0; iCol < row.length; iCol++) {
						var tile:Tile = row[iCol];
						this.removeTileMonitoringHooks(tile);
						tile.destroy();
					}
				}
				this.grid = [];
			}
		}

		/**
		 * Methodd to cache a tile
		 */
		public function addTileCache(url:String,loader:Loader):void {
			//We check if there's space in the cache
			if(cachedTiles.size() < CACHE_SIZE) {
				cachedTiles.put(url,loader);
				cachedTilesUrl[cptCached] = url;
			}
			//Otherwise, we remove from the cache the older cached tile
			else {
				var oldUrl:String = cachedTilesUrl[cptCached];
				cachedTiles.remove(oldUrl);
				cachedTilesUrl[cptCached] = url;
				cachedTiles.put(url,loader);
			}
			cptCached++; if(cptCached == CACHE_SIZE) cptCached = 0;
		}

		/**
		 * Method to get a cached tile by its url
		 */
		public function getTileCache(url:String):Loader {

			var loader:Loader = cachedTiles.getValue(url);

			return loader;
		}

		/**
		 * Create a clone of this layer
		 *
		 * @param obj
		 *
		 * @return An exact clone
		 */
		override public function clone(obj:Object):Object {
			if (obj == null) {
				obj = new Grid(this.name,
					this.url,
					this.params);
			}

			obj = super.clone([obj]);

			obj.grid = new Array();

			return obj;
		}

		override public function set map(map:Map):void {
			super.map = map;
			if (this.tileSize == null) {
				this.tileSize = map.tileSize;
			}
		}

		/**
		 * This function is called whenever the map is moved. All the moving
		 * of actual 'tiles' is done by the map, but moveTo's role is to accept
		 * a bounds and make sure the data that bounds requires is pre-loaded.
		 *
		 * @param bounds
		 * @param zoomChanged
		 * @param dragging
		 */
		override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false,resizing:Boolean=false):void {

			super.moveTo(bounds, zoomChanged, dragging,resizing);

			if (bounds == null) {
				bounds = this.map.extent;
			}

			var forceReTile:Boolean = !this.grid.length || zoomChanged;

			var tilesBounds:Bounds = this.getTilesBounds();            

			if (this.singleTile) {

				if ( forceReTile || 
					(!dragging && !tilesBounds.containsBounds(bounds))) {
					this.initSingleTile(bounds);
				}
			} else {
				if (forceReTile || !tilesBounds.containsBounds(bounds, true)) {
					this.initGriddedTiles(bounds);
				} else {
					this.moveGriddedTiles(bounds);
				}
			}

		}

		/**
		 * Check if we are in singleTile mode and if so, set the size as a ratio
		 *     of the map size
		 *
		 * @param size
		 */
		public function set tileSize(size:Size):void {
			if (this.singleTile) {
				var size:Size = this.map.size;
				size.h = int(size.h * this.ratio);
				size.w = int(size.w * this.ratio);
			} 
			this._tileSize = size;	
		}

		public function get tileSize():Size {
			return this._tileSize;
		}		


		/**
		 * Return the bounds of the tile grid.
		 *
		 * @return A Bounds object representing the bounds of all the currently loaded tiles
		 */
		public function getTilesBounds():Bounds {
			var bounds:Bounds = null; 

			if (this.grid.length) {
				var bottom:int = this.grid.length - 1;
				var bottomLeftTile:Tile = this.grid[bottom][0];

				var right:int = this.grid[0].length - 1; 
				var topRightTile:Tile = this.grid[0][right];

				bounds = new Bounds(bottomLeftTile.bounds.left, 
					bottomLeftTile.bounds.bottom,
					topRightTile.bounds.right, 
					topRightTile.bounds.top);

			}   
			return bounds;
		}

		/**
		 * Initialization singleTile
		 *
		 * @param bounds
		 */
		public function initSingleTile(bounds:Bounds):void {
			var center:LonLat = bounds.centerLonLat;
			var tileWidth:Number = bounds.width * this.ratio;
			var tileHeight:Number = bounds.height * this.ratio;

			var tileBounds:Bounds = 
				new Bounds(center.lon - (tileWidth/2),
				center.lat - (tileHeight/2),
				center.lon + (tileWidth/2),
				center.lat + (tileHeight/2));

			var ul:LonLat = new LonLat(tileBounds.left, tileBounds.top);
			var px:Pixel = this.map.getLayerPxFromLonLat(ul);

			if (!this.grid.length) {
				this.grid[0] = [];
			}

			var tile:Tile = this.grid[0][0];
			if (!tile) {
				tile = this.addTile(tileBounds, px);
				tile.draw();

				this.grid[0][0] = tile;
			} else {
				tile.moveTo(tileBounds, px);
			}           

			this.removeExcessTiles(1,1);
		}

		public function initGriddedTiles(bounds:Bounds):void {

			var viewSize:Size = this.map.size;
			var minRows:Number = Math.ceil(viewSize.h/this.tileSize.h) + 
				Math.max(1, 2 * this.buffer);
			var minCols:Number = Math.ceil(viewSize.w/this.tileSize.w) +
				Math.max(1, 2 * this.buffer);

			var extent:Bounds = this.maxExtent;
			var resolution:Number = this.map.resolution;
			var tilelon:Number = resolution * this.tileSize.w;
			var tilelat:Number = resolution * this.tileSize.h;

			var offsetlon:Number = bounds.left - extent.left;
			var tilecol:Number = Math.floor(offsetlon/tilelon) - this.buffer;
			var tilecolremain:Number = offsetlon/tilelon - tilecol;
			var tileoffsetx:Number = -tilecolremain * this.tileSize.w;
			var tileoffsetlon:Number = extent.left + tilecol * tilelon;

			var offsetlat:Number = bounds.top - (extent.bottom + tilelat);  
			var tilerow:Number = Math.ceil(offsetlat/tilelat) + this.buffer;
			var tilerowremain:Number = tilerow - offsetlat/tilelat;
			var tileoffsety:Number = -tilerowremain * this.tileSize.h;
			var tileoffsetlat:Number = extent.bottom + tilerow * tilelat;

			tileoffsetx = Math.round(tileoffsetx); // heaven help us
			tileoffsety = Math.round(tileoffsety);

			this._origin = new Pixel(tileoffsetx, tileoffsety);

			var startX:Number = tileoffsetx; 
			var startLon:Number = tileoffsetlon;

			var rowidx:int = 0;

			do {
				var row:Array = this.grid[rowidx++];
				if (!row) {
					row = [];
					this.grid.push(row);
				}

				tileoffsetlon = startLon;
				tileoffsetx = startX;
				var colidx:int = 0;

				do {
					var tileBounds:Bounds = 
						new Bounds(tileoffsetlon, 
						tileoffsetlat, 
						tileoffsetlon + tilelon,
						tileoffsetlat + tilelat);

					var x:Number = tileoffsetx;
					x -= int(this.map.layerContainer.x);

					var y:Number = tileoffsety;
					y -= int(this.map.layerContainer.y);

					var px:Pixel = new Pixel(x, y);
					var tile:Tile = row[colidx++];
					if (!tile) {
						tile = this.addTile(tileBounds, px);
						row.push(tile);
					} else {
						tile.moveTo(tileBounds, px, false);
					}

					tileoffsetlon += tilelon;       
					tileoffsetx += this.tileSize.w;
				} while ((tileoffsetlon <= bounds.right + tilelon * this.buffer) || colidx < minCols)  

				tileoffsetlat -= tilelat;
				tileoffsety += this.tileSize.h;
			} while((tileoffsetlat >= bounds.bottom - tilelat * this.buffer) || rowidx < minRows)

			//shave off exceess rows and colums
			this.removeExcessTiles(rowidx, colidx);

			//now actually draw the tiles
			this.spiralTileLoad();
		}

		/**
		 *   Starts at the top right corner of the grid and proceeds in a spiral
		 *    towards the center, adding tiles one at a time to the beginning of a
		 *    queue.
		 *
		 *   Once all the grid's tiles have been added to the queue, we go back
		 *    and iterate through the queue (thus reversing the spiral order from
		 *    outside-in to inside-out), calling draw() on each tile.
		 */
		private function spiralTileLoad():void {
			var tileQueue:Array = new Array();

			var directions:Array = ["right", "down", "left", "up"];

			var iRow:int = 0;
			var iCell:int = -1;
			var direction:int = 0;
			var directionsTried:int = 0;

			while( directionsTried < directions.length) {

				var testRow:int = iRow;
				var testCell:int = iCell;

				switch (directions[direction]) {
					case "right":
						testCell++;
						break;
					case "down":
						testRow++;
						break;
					case "left":
						testCell--;
						break;
					case "up":
						testRow--;
						break;
				} 

				// if the test grid coordinates are within the bounds of the 
				//  grid, get a reference to the tile.
				var tile:ImageTile = null;
				if ((testRow < this.grid.length) && (testRow >= 0) &&
					(testCell < this.grid[0].length) && (testCell >= 0)) {
					tile = this.grid[testRow][testCell];
				}

				if ((tile != null) && (!tile.queued)) {
					//add tile to beginning of queue, mark it as queued.
					tileQueue.push(tile);
					tile.queued = true;

					//restart the directions counter and take on the new coords
					directionsTried = 0;
					iRow = testRow;
					iCell = testCell;
				} else {
					//need to try to load a tile in a different direction
					direction = (direction + 1) % 4;
					directionsTried++;
				}
			} 

			// now we go through and draw the tiles in forward order
			for(var i:int=tileQueue.length-1; i >= 0; i--) {
				tile = tileQueue[i];
				tile.draw();
				//mark tile as unqueued for the next time (since tiles are reused)
				tile.queued = false;       
			}
		}

		public function addTile(bounds:Bounds, position:Pixel):Tile {
			return null;
		}


		public function removeTileMonitoringHooks(tile:Tile):void {
		/*this.removeEventListener(TileEvent.TILE_LOAD_START, tile.onLoadStart);
		 this.removeEventListener(TileEvent.TILE_LOAD_END, tile.onLoadEnd);*/
		}

		public function moveGriddedTiles(bounds:Bounds):void {

			var buffer:Number = this.buffer || 1;
			while (true) {
				var tlLayer:Pixel = this.grid[0][0].position;
				var tlViewPort:Pixel = 
					this.map.getMapPxFromLayerPx(tlLayer);
				if (tlViewPort.x > -this.tileSize.w * (buffer - 1)) {
					this.shiftColumn(true);
				} else if (tlViewPort.x < -this.tileSize.w * buffer) {
					this.shiftColumn(false);
				} else if (tlViewPort.y > -this.tileSize.h * (buffer - 1)) {
					this.shiftRow(true);
				} else if (tlViewPort.y < -this.tileSize.h * buffer) {
					this.shiftRow(false);
				} else {
					break;
				}
			};
			if (this.buffer == 0) {
				for (var r:int=0, rl:int=this.grid.length; r<rl; r++) {
					var row:Array = this.grid[r];
					for (var c:int=0, cl:int=row.length; c<cl; c++) {
						var tile:Tile = row[c];
						if (!tile.drawn && 
							tile.bounds.intersectsBounds(bounds, false)) {
							tile.draw();
						}
					}
				}
			}
		}


		/**
		 * Shifty grid work
		 *
		 * @param prepend if true, prepend to beginning.
		 *                          if false, then append to end
		 */
		private function shiftRow(prepend:Boolean):void {
			var modelRowIndex:int = (prepend) ? 0 : (this.grid.length - 1);
			var modelRow:Array = this.grid[modelRowIndex];

			var resolution:Number = this.map.resolution;
			var deltaY:Number = (prepend) ? -this.tileSize.h : this.tileSize.h;
			var deltaLat:Number = resolution * -deltaY;

			var row:Array = (prepend) ? this.grid.pop() : this.grid.shift();

			for (var i:int=0; i < modelRow.length; i++) {
				var modelTile:Tile = modelRow[i];
				var bounds:Bounds = modelTile.bounds.clone();
				var position:Pixel = modelTile.position.clone();
				bounds.bottom = bounds.bottom + deltaLat;
				bounds.top = bounds.top + deltaLat;
				position.y = position.y + deltaY;
				row[i].moveTo(bounds, position);
			}

			if (prepend) {
				this.grid.unshift(row);
			} else {
				this.grid.push(row);
			}
		}

		/**
		 * Shift grid work in the other dimension
		 *
		 * @param prepend if true, prepend to beginning.
		 *                          if false, then append to end
		 */
		private function shiftColumn(prepend:Boolean):void {
			var deltaX:Number = (prepend) ? -this.tileSize.w : this.tileSize.w;
			var resolution:Number = this.map.resolution;
			var deltaLon:Number = resolution * deltaX;

			for (var i:int=0; i<this.grid.length; i++) {
				var row:Array = this.grid[i];
				var modelTileIndex:int = (prepend) ? 0 : (row.length - 1);
				var modelTile:Tile = row[modelTileIndex];

				var bounds:Bounds = modelTile.bounds.clone();
				var position:Pixel = modelTile.position.clone();
				bounds.left = bounds.left + deltaLon;
				bounds.right = bounds.right + deltaLon;
				position.x = position.x + deltaX;

				var tile:Tile = prepend ? this.grid[i].pop() : this.grid[i].shift()
				tile.moveTo(bounds, position);
				if (prepend) {
					this.grid[i].unshift(tile);
				} else {
					this.grid[i].push(tile);
				}
			}
		}

		/**
		 * When the size of the map or the buffer changes, we may need to
		 *     remove some excess rows and columns.
		 *
		 * @param rows Maximum number of rows we want our grid to have.
		 * @param colums Maximum number of columns we want our grid to have.
		 */
		public function removeExcessTiles(rows:int, columns:int):void {
			while (this.grid.length > rows) {
				var row:Array = this.grid.pop();
				for (var i:int=0, l:int=row.length; i<l; i++) {
					var tile:Tile = row[i];
					this.removeTileMonitoringHooks(tile)
					tile.destroy();
				}
			}

			while (this.grid[0].length > columns) {
				for (i=0, l=this.grid.length; i<l; i++) {
					row = this.grid[i];
					tile = row.pop();
					this.removeTileMonitoringHooks(tile);
					tile.destroy();
				}
			}
		}

		/**
		 * For singleTile layers, this will set a new tile size according to the
		 * dimensions of the map pane.
		 */
		override public function onMapResize():void {
			if (this.singleTile) {
				this.clearGrid();
				this.tileSize = null;
				this.initSingleTile(this.map.extent);
			}			
		}

		/**
		 * Returns The tile bounds for a layer given a pixel location.
		 *
		 * @param viewPortPx The location in the viewport.
		 *
		 * @return Bounds of the tile at the given pixel location.
		 */
		public function getTileBounds(viewPortPx:Pixel):Bounds {
			var maxExtent:Bounds = this.maxExtent;
			var resolution:Number = this.resolution;
			var tileMapWidth:Number = resolution * this.tileSize.w;
			var tileMapHeight:Number = resolution * this.tileSize.h;
			var mapPoint:LonLat = this.getLonLatFromMapPx(viewPortPx);
			var tileLeft:Number = maxExtent.left + (tileMapWidth *
				Math.floor((mapPoint.lon -
				maxExtent.left) /
				tileMapWidth));
			var tileBottom:Number = maxExtent.bottom + (tileMapHeight *
				Math.floor((mapPoint.lat -
				maxExtent.bottom) /
				tileMapHeight));
			return new Bounds(tileLeft, tileBottom,
				tileLeft + tileMapWidth,
				tileBottom + tileMapHeight);
		}

		//Getters and Setters
		override public function get imageSize():Size {
			return (this._imageSize || this.tileSize); 
		}

		public function get grid():Array {
			return this._grid;
		}

		public function set grid(value:Array):void {
			this._grid = value;
		}

		public function get singleTile():Boolean {
			return this._singleTile;
		}

		public function set singleTile(value:Boolean):void {
			this._singleTile = value;
		}

		public function get ratio():Number {
			return this._ratio;
		}

		public function set ratio(value:Number):void {
			this._ratio = value;
		}

		public function get numLoadingTiles():int {
			return this._numLoadingTiles;
		}

		public function set numLoadingTiles(value:int):void {
			this._numLoadingTiles = value;
		}

		/**
		 * Used only when in gridded mode, this specifies the number of
		 * extra rows and colums of tiles on each side which will
		 * surround the minimum grid tiles to cover the map.
		 */
		public function get buffer():Number {
			return this._buffer; 
		}

		public function set buffer(value:Number):void {
			this._buffer = value; 
		}

	}
}

