package org.openscales.core.layer
{
	import flash.display.Bitmap;
	
	import org.openscales.core.Trace;
	import org.openscales.basetypes.Bounds;
	import org.openscales.core.basetypes.LinkedList.ILinkedListNode;
	import org.openscales.core.basetypes.LinkedList.LinkedList;
	import org.openscales.core.basetypes.LinkedList.LinkedListBitmapNode;
	import org.openscales.basetypes.LonLat;
	import org.openscales.basetypes.Pixel;
	import org.openscales.basetypes.Size;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.events.TileEvent;
	import org.openscales.core.layer.params.IHttpParams;
	import org.openscales.core.tile.ImageTile;

	/**
	 * Base class for layers that use a lattice of tiles.
	 *
	 * @author Bouiaw
	 */
	public class Grid extends HTTPRequest
	{
		private const DEFAULT_TILE_WIDTH:Number = 256;
		
		private const DEFAULT_TILE_HEIGHT:Number = 256;

		/** The grid array contains tiles **/		
		private var _grid:Vector.<Vector.<ImageTile>> = null;

		private var _singleTile:Boolean = false;

		private var _numLoadingTiles:int = 0;

		private var _origin:Pixel = null;

		private var _buffer:Number;

		protected var CACHE_SIZE:int = 64;

		private var tileCache:LinkedList = new LinkedList();
		private var cptCached:int = 0;
		
		private var _tileWidth:Number = DEFAULT_TILE_WIDTH;
		
		private var _tileHeight:Number = DEFAULT_TILE_HEIGHT;


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
		public function Grid(name:String,
							 url:String,
							 params:IHttpParams = null) {

			//TOdo delete url and params after osmparams work
			super(name, url, params);

			//this.grid = new Vector.<Vector.<Tile>>();

			this.buffer = 1;
			
			this.addEventListener(TileEvent.TILE_LOAD_END,tileLoadHandler);
			this.addEventListener(TileEvent.TILE_LOAD_START,tileLoadHandler);
		}
		
		override public function onMapZoom(e:MapEvent):void {
			// Clear pending requests after zooming in order to avoid to add
			// too many tile requests  when the user is zooming step by step
			var j:uint;
			for each(var array:Vector.<ImageTile> in this._grid)	{
				j = array.length;
				for (var i:Number = 0;i<j;i++)	{
					var tile:ImageTile = array[i];
					if (tile != null && !tile.loadComplete) {
						tile.clear();
					}
				}
			}
			super.onMapZoom(e);
		}

		override public function destroy():void {
			this.clear();
			tileCache.clear();
			this.grid = null;
			super.destroy();
		}

		/**
		 * Go through and remove all tiles from the grid, calling
		 *    destroy() on each of them to kill circular references
		 */
		override public function clear():void {
			if (this._grid && this._grid.length>0) {
				var i:uint = this._grid.length;
				var j:uint = this._grid[0].length;
				var iRow:uint;
				var iCol:uint;
				for(iRow=0; iRow < i; ++iRow) {
					var row:Vector.<ImageTile> = this._grid.pop();
					for(iCol=0; iCol < j; ++iCol) {
						var tile:ImageTile = row.pop();
						this.removeTileMonitoringHooks(tile);
						tile.destroy();						
					}
				}
				while (this.numChildren > 0)
					this.removeChildAt(0);
				this.grid = null;
			}
		}

		/**
		 * cache a tile
		 */
		public function addTileCache(node:ILinkedListNode):void {
			if(!tileCache.moveTail(node.uid)) {
				tileCache.insertTail(node);
				cptCached++;
				if(cptCached==CACHE_SIZE+1){
					tileCache.removeHead();
					cptCached--;
				}
			}
		}
		/**
		 * get a cached tile
		 */
		public function getTileCache(url:String):Bitmap {
			var node:ILinkedListNode = tileCache.getUID(url);
			if(node == null){
				return null;
			}else if(node is LinkedListBitmapNode) {
				this.addTileCache(node);
				return (node as LinkedListBitmapNode).bitmap();
			}
			return null;
		}
		
		override public function redraw(fullRedraw:Boolean = true):void {
						
			if (!displayed) {
				this.clear();
				return;
			}
			
			var bounds:Bounds = this.map.extent.clone();
			
			var forceReTile:Boolean = this._grid==null || !this._grid.length || fullRedraw;

			var tilesBounds:Bounds = this.getTilesBounds();            

			if (this.singleTile) {
				if(fullRedraw)
					this.clear();
				if ( forceReTile || !tilesBounds.containsBounds(bounds)) {
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
		
		public function set tileWidth(value:Number):void {
			this._tileWidth = value;	
		}

		public function get tileWidth():Number {
			if (this.singleTile) {
				return map.size.w;
			} 			
			return this._tileWidth;
		}
		
		public function set tileHeight(value:Number):void {
			this._tileHeight= value;	
		}

		public function get tileHeight():Number {
			if (this.singleTile) {
				return map.size.h;
			}
			return this._tileHeight;
		}	


		/**
		 * Return the bounds of the tile grid.
		 *
		 * @return A Bounds object representing the bounds of all the currently loaded tiles
		 */
		public function getTilesBounds():Bounds {
			if(this._grid == null)
				return null;
			var i:uint = this._grid.length;

			if (i>0) {
				var bottom:int = i - 1;
				var bottomLeftTile:ImageTile = this._grid[bottom][0];
				var right:int = this._grid[0].length - 1; 
				var topRightTile:ImageTile = this._grid[0][right];
				return new Bounds(bottomLeftTile.bounds.left, 
									bottomLeftTile.bounds.bottom,
									topRightTile.bounds.right, 
									topRightTile.bounds.top);
			}
			return null;
		}

		/**
		 * Initialization singleTile
		 *
		 * @param bounds
		 */
		public function initSingleTile(bounds:Bounds):void {
			var center:LonLat = bounds.centerLonLat;
			var tileWidth:Number = bounds.width;
			var tileHeight:Number = bounds.height;
			var tileBounds:Bounds =  new Bounds(center.lon - (tileWidth/2),
												center.lat - (tileHeight/2),
												center.lon + (tileWidth/2),
												center.lat + (tileHeight/2));
			var ul:LonLat = new LonLat(tileBounds.left, tileBounds.top);
			var px:Pixel = this.map.getLayerPxFromLonLat(ul);

			if(this._grid==null) {
				this._grid = new Vector.<Vector.<ImageTile>>(1);
				this._grid[0] = new Vector.<ImageTile>(1);
				this._grid[0][0] = null;
			}

			var tile:ImageTile = this._grid[0][0];
			if (!tile) {
				tile = this.addTile(tileBounds, px);
				tile.draw();
				this._grid[0][0] = tile;
			} else {
				tile.moveTo(tileBounds, px);
			}           
			this.removeExcessTiles(1,1);
		}

		/**
		 * Ititialize gridded tiles
		 * 
		 * when clearTiles == true (most of time), Tile.clearAndMoveTo is called. 
		 * This method reset tile, so produce a white flash (usefull when loading map)
		 * Actually used when zooming in / out
		 * 
		 * when clearTiles == false, Tile.moveTo is called,
		 * no white flash, but there is some problems if used for something else than modifying map extent
		 */
		public function initGriddedTiles(bounds:Bounds, clearTiles:Boolean=true):void {
			var viewSize:Size = this.map.size;
			var minRows:Number = Math.ceil(viewSize.h/this.tileHeight) + 
											Math.max(1, 2 * this.buffer);
			var minCols:Number = Math.ceil(viewSize.w/this.tileWidth) +
											Math.max(1, 2 * this.buffer);
			var extent:Bounds = this.maxExtent;
			var resolution:Number = this.map.resolution;
			var tilelon:Number = resolution * this.tileWidth;
			var tilelat:Number = resolution * this.tileHeight;
			var offsetlon:Number = bounds.left - extent.left;
			var tilecol:Number = Math.floor(offsetlon/tilelon) - this.buffer;
			var tilecolremain:Number = offsetlon/tilelon - tilecol;
			var tileoffsetx:Number = -tilecolremain * this.tileWidth;
			var tileoffsetlon:Number = extent.left + tilecol * tilelon;
			var offsetlat:Number = bounds.top - (extent.bottom + tilelat);  
			var tilerow:Number = Math.ceil(offsetlat/tilelat) + this.buffer;
			var tilerowremain:Number = tilerow - offsetlat/tilelat;
			var tileoffsety:Number = -tilerowremain * this.tileHeight;
			var tileoffsetlat:Number = extent.bottom + tilerow * tilelat;

			tileoffsetx = Math.round(tileoffsetx);
			tileoffsety = Math.round(tileoffsety);

			this._origin = new Pixel(tileoffsetx, tileoffsety);

			var startX:Number = tileoffsetx; 
			var startLon:Number = tileoffsetlon;
			var rowidx:int = 0;

			if(this._grid == null) {
				this._grid = new Vector.<Vector.<ImageTile>>();
			}
			do {
				var row:Vector.<ImageTile>;
				if(this._grid.length==rowidx) {
					row = new Vector.<ImageTile>;
					this._grid.push(row);
				} else {
					row = this._grid[rowidx];
				}
				rowidx=++rowidx;

				tileoffsetlon = startLon;
				tileoffsetx = startX;
				var colidx:int = 0;
				do {
					var tileBounds:Bounds = new Bounds(tileoffsetlon, 
														tileoffsetlat, 
														tileoffsetlon + tilelon,
														tileoffsetlat + tilelat);
					var x:Number = tileoffsetx;
					x -= int(this.map.layerContainer.x);

					var y:Number = tileoffsety;
					y -= int(this.map.layerContainer.y);

					var px:Pixel = new Pixel(x, y);
					var tile:ImageTile;
					if(row.length==colidx) {
						tile = this.addTile(tileBounds, px);
						row.push(tile);
					} else {
						tile = row[colidx];
						if(clearTiles)
							tile.clearAndMoveTo(tileBounds, px, false);
						else 
							tile.moveTo(tileBounds, px, false);
					}
					colidx=++colidx;

					tileoffsetlon += tilelon;       
					tileoffsetx += this.tileWidth;
				} while ((tileoffsetlon <= bounds.right + tilelon * this.buffer) || colidx < minCols)  

				tileoffsetlat -= tilelat;
				tileoffsety += this.tileHeight;
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
		protected function spiralTileLoad():void {
			var tileQueue:Array = new Array();
			var directions:Array = ["right", "down", "left", "up"];
			var iRow:int = 0;
			var iCell:int = -1;
			var direction:int = 0;
			var directionsTried:int = 0;

			while( directionsTried < 4) {
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
				if ((testRow < this._grid.length) && (testRow >= 0) &&
					(testCell < this._grid[0].length) && (testCell >= 0)) {
					tile = this._grid[testRow][testCell];
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

		public function addTile(bounds:Bounds, position:Pixel):ImageTile {
			return null;
		}


		public function removeTileMonitoringHooks(tile:ImageTile):void {
		}
		/**
		 * This metod is called only when mapEvent.MOVE_END is thrown
		 */
		public function moveGriddedTiles(bounds:Bounds):void {
			var buffer:Number = this.buffer || 1;
			while (true) {
				var tlLayer:Pixel = this.grid[0][0].position;
				var tlViewPort:Pixel = 
					this.map.getMapPxFromLayerPx(tlLayer);
				if (tlViewPort.x > -this.tileWidth * (buffer - 1)) {
					this.shiftColumn(true);
				} else if (tlViewPort.x < -this.tileWidth * buffer) {
					this.shiftColumn(false);
				} else if (tlViewPort.y > -this.tileHeight * (buffer - 1)) {
					this.shiftRow(true);
				} else if (tlViewPort.y < -this.tileHeight * buffer) {
					this.shiftRow(false);
				} else {
					break;
				}
			};
			if (this.buffer == 0) {
				var rl:int = this._grid.length;
				var cl:int;
				for (var r:int=0; r<rl; r++) {
					var row:Vector.<ImageTile> = this._grid[r];
					cl = row.length;
					for (var c:int=0; c<cl; ++c) {
						var tile:ImageTile = row[c];
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
			var modelRowIndex:int = (prepend) ? 0 : (this._grid.length - 1);
			var modelRow:Vector.<ImageTile> = this._grid[modelRowIndex];
			var resolution:Number = this.map.resolution;
			var deltaY:Number = (prepend) ? -this.tileHeight : this.tileHeight;
			var deltaLat:Number = resolution * -deltaY;
			var row:Vector.<ImageTile> = (prepend) ? this._grid.pop() : this._grid.shift();

			var j:uint = modelRow.length;
			for (var i:uint=0; i < j; ++i) {
				var modelTile:ImageTile = modelRow[i];
				var bounds:Bounds = modelTile.bounds.clone();
				var position:Pixel = modelTile.position.clone();
				bounds.bottom = bounds.bottom + deltaLat;
				bounds.top = bounds.top + deltaLat;
				position.y = position.y + deltaY;
				row[i].clearAndMoveTo(bounds, position);
			}

			if (prepend) {
				this._grid.unshift(row);
			} else {
				this._grid.push(row);
			}
		}

		/**
		 * Shift grid work in the other dimension
		 *
		 * @param prepend if true, prepend to beginning.
		 *                          if false, then append to end
		 */
		private function shiftColumn(prepend:Boolean):void {
			var deltaX:Number = (prepend) ? -this.tileWidth : this.tileWidth;
			var resolution:Number = this.map.resolution;
			var deltaLon:Number = resolution * deltaX;

			var j:uint = this._grid.length;
			for (var i:uint=0; i<j; ++i) {
				var row:Vector.<ImageTile> = this._grid[i];
				var modelTileIndex:int = (prepend) ? 0 : (row.length - 1);
				var modelTile:ImageTile = row[modelTileIndex];
				var bounds:Bounds = modelTile.bounds.clone();
				var position:Pixel = modelTile.position.clone();
				bounds.left = bounds.left + deltaLon;
				bounds.right = bounds.right + deltaLon;
				position.x = position.x + deltaX;
				var tile:ImageTile = prepend ? this._grid[i].pop() : this._grid[i].shift()
				tile.clearAndMoveTo(bounds, position);
				if (prepend) {
					this._grid[i].unshift(tile);
				} else {
					this._grid[i].push(tile);
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
			while (this._grid.length > rows) {
				var row:Vector.<ImageTile> = this._grid.pop();
				for (var i:int=0, l:int=row.length; i<l; i++) {
					var tile:ImageTile = row[i];
					this.removeTileMonitoringHooks(tile)
					tile.destroy();
				}
			}

			while (this._grid[0].length > columns) {
				for (i=0, l=this._grid.length; i<l; i++) {
					row = this._grid[i];
					tile = row.pop();
					this.removeTileMonitoringHooks(tile);
					tile.destroy();
				}
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
			var resolution:Number = this.map.resolution;
			var tileMapWidth:Number = resolution * this.tileWidth;
			var tileMapHeight:Number = resolution * this.tileHeight;
			var mapPoint:LonLat = this.getLonLatFromMapPx(viewPortPx);
			var tileLeft:Number = maxExtent.left + (tileMapWidth * Math.floor((mapPoint.lon - maxExtent.left) / tileMapWidth));
			var tileBottom:Number = maxExtent.bottom + (tileMapHeight * Math.floor((mapPoint.lat - maxExtent.bottom) / tileMapHeight));
			return new Bounds(tileLeft,
							  tileBottom,
							  tileLeft + tileMapWidth,
							  tileBottom + tileMapHeight);
		}
		
		private function tileLoadHandler(event:TileEvent):void	{
			switch(event.type)	{
				case TileEvent.TILE_LOAD_START:	{
					// set layer loading to true
					this.loading = true;
					break;
				}
				case TileEvent.TILE_LOAD_END:	{
					// check if there are still tiles loading
					for each(var array:Vector.<ImageTile> in this._grid)	{
						var j:uint = array.length;
						for (var i:Number = 0;i<j;i++)	{
							var tile:ImageTile = array[i];
							if (tile != null && !tile.loadComplete)
							  return;	
						}
					}
					this.loading = false;
					break;
				}
			}			
		}

		//Getters and Setters
		override public function get imageSize():Size {
			if(this._imageSize == null)
				this._imageSize = new Size(this.tileWidth, this.tileHeight);
			return new Size(this.tileWidth, this.tileHeight); 
		}

		public function get grid():Vector.<Vector.<ImageTile>> {
			return this._grid;
		}

		public function set grid(value:Vector.<Vector.<ImageTile>>):void {
			this._grid = value;
		}

		public function get singleTile():Boolean {
			return this._singleTile;
		}

		public function set singleTile(value:Boolean):void {
			this._singleTile = value;
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

