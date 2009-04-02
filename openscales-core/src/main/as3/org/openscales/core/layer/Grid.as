package org.openscales.core.layer
{
	import org.openscales.core.Map;
	import org.openscales.core.OpenScales;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.feature.Style;
	import org.openscales.core.tile.Image;
	import org.openscales.core.tile.Tile;
	
	public class Grid extends HTTPRequest
	{
		
		public var tileSizeG:Size = null;
		
		public var grid:Array = null;
		
		//public var buffer:int = 2;
		
		public var singleTile:Boolean = false;
		
		public var ratio:Number = 1.5;
		
		public var numLoadingTiles:int = 0;
		
		private var origin:Pixel = null;
		
		public var typename:String = null;
		
		public var proxy:String = null;
		
		public var style:Style = null;
		
		public function Grid(name:String = null, url:String = null, params:Object = null, options:Object = null):void {
			super(name, url, params, options);
			
			this.grid = new Array();
		}
		
		override public function destroy(newBaseLayer:Boolean = true):void {
			this.clearGrid();
	        this.grid = null;
	        this.tileSizeG = null;
	        super.destroy(); 
		}
		
		public function clearGrid():void {
			if (this.grid) {
	            for(var iRow:int=0; iRow < this.grid.length; iRow++) {
	                var row:String = this.grid[iRow];
	                for(var iCol:int=0; iCol < row.length; iCol++) {
	                    var tile:Tile = row[iCol];
	                    this.removeTileMonitoringHooks(tile);
	                    tile.destroy();
	                }
	            }
	            this.grid = [];
	        }
		}
		
		override public function clone(obj:Object):Object {
			if (obj == null) {
	            obj = new Grid(this.name,
                                this.url,
                                this.params,
                                this.options);
	        }
	
	        obj = super.clone([obj]);

	        if (this.tileSizeG != null) {
	            obj.tileSize = this.tileSize.clone();
	        }

	        obj.grid = new Array();
	
	        return obj;
		}
		
		override public function set map(map:Map):void {
			super.map = map;
	        if (this.tileSize == null) {
	            this.tileSize = map.tileSize;
	        }
		}
		
		override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false):void {
			super.moveTo(bounds, zoomChanged, dragging);
	        
	        if (bounds == null) {
	            bounds = this.map.extent;
	        }
	        if (bounds != null) {

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
		}
		
		override public function setTileSize(size:Size = null):void {
	        if (this.singleTile) {
	            var size:Size = this.map.size;
	            size.h = int(size.h * this.ratio);
	            size.w = int(size.w * this.ratio);
	        } 
	        super.setTileSize(size);	
		}
		
		private function getGridBounds():Bounds {
			var bottom:int = this.grid.length - 1;
		    var bottomLeftTile:Tile = this.grid[bottom][0];
		
		    var right:int = this.grid[0].length - 1; 
		    var topRightTile:Tile = this.grid[0][right];
		
		    return new Bounds(bottomLeftTile.bounds.left, 
		                                 bottomLeftTile.bounds.bottom,
		                                 topRightTile.bounds.right, 
		                                 topRightTile.bounds.top);
		}
		
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
		
		public function initSingleTile(bounds:Bounds):void {
	        var center:LonLat = bounds.getCenterLonLat();
	        var tileWidth:Number = bounds.getWidth() * this.ratio;
	        var tileHeight:Number = bounds.getHeight() * this.ratio;
	                                       
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
	            
	            this.addTileMonitoringHooks(tile);
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
	        
	        var extent:Bounds = this.map.maxExtent;
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
	
	        this.origin = new Pixel(tileoffsetx, tileoffsety);
	
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
	                    this.addTileMonitoringHooks(tile);
	                    row.push(tile);
	                } else {
	                    tile.moveTo(tileBounds, px, false);
	                }
	     
	                tileoffsetlon += tilelon;       
	                tileoffsetx += this.tileSize.w;
	            } while ((tileoffsetlon <= bounds.right + tilelon * this.buffer)
	                     || colidx < minCols)  
	             
	            tileoffsetlat -= tilelat;
	            tileoffsety += this.tileSize.h;
	        } while((tileoffsetlat >= bounds.bottom - tilelat * this.buffer)
	                || rowidx < minRows)
	        
	        this.removeExcessTiles(rowidx, colidx);
	
	        this.spiralTileLoad();
		}
		
		private function _initTiles():void {
			
	        var viewSize:Size = this.map.size;
	        var minRows:Number = Math.ceil(viewSize.h/this.tileSize.h) + 1;
	        var minCols:Number = Math.ceil(viewSize.w/this.tileSize.w) + 1;
	        
	        var bounds:Bounds = this.map.extent;
	        var extent:Bounds = this.map.maxExtent;
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
	        
	        tileoffsetx = Math.round(tileoffsetx);
	        tileoffsety = Math.round(tileoffsety);
	
	        this.origin = new Pixel(tileoffsetx, tileoffsety);
	
	        var startX:Number = tileoffsetx; 
	        var startLon:Number = tileoffsetlon;
	
	        var rowidx:int = 0;
	    
	        do {
	            var row:Array = this.grid[rowidx++];
	            if (!row) {
	                row = new Array();
	                this.grid.push(row);
	            }
	
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
	                var tile:Tile = row[colidx++];
	                if (!tile) {
	                    tile = this.addTile(tileBounds, px);
	                    row.push(tile);
	                } else {
	                    tile.moveTo(tileBounds, px, false);
	                }
	     
	                tileoffsetlon += tilelon;       
	                tileoffsetx += this.tileSize.w;
	            } while ((tileoffsetlon <= bounds.right + tilelon * this.buffer)
	                     || colidx < minCols)  
	             
	            tileoffsetlat -= tilelat;
	            tileoffsety += this.tileSize.h;
	        } while((tileoffsetlat >= bounds.bottom - tilelat * this.buffer)
	                || rowidx < minRows)

	        while (this.grid.length > rowidx) {
	            row = this.grid.pop();
	            for (var i:int=0, l:int=row.length; i<l; i++) {
	                row[i].destroy();
	            }
	        }

	        while (this.grid[0].length > colidx) {
	            for (i=0, l=this.grid.length; i<l; i++) {
	                row = this.grid[i];
	                tile = row.pop();
	                tile.destroy();
	            }
	        }

	        this.spiralTileLoad();
		}
		
		private function spiralTileLoad():void {
			var tileQueue:Array = new Array();
 
	        var directions:Array = ["right", "down", "left", "up"];
	
	        var iRow:int = 0;
	        var iCell:int = -1;
	        var direction:int = Util.indexOf(directions, "right");
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

	            var tile:Image = null;
	            if ((testRow < this.grid.length) && (testRow >= 0) &&
	                (testCell < this.grid[0].length) && (testCell >= 0)) {
	                tile = this.grid[testRow][testCell];
	            }
	            
	            if ((tile != null) && (!tile.queued)) {
	                tileQueue.unshift(tile);
	                tile.queued = true;

	                directionsTried = 0;
	                iRow = testRow;
	                iCell = testCell;
	            } else {
	                direction = (direction + 1) % 4;
	                directionsTried++;
	            }
	        } 

	        for(var i:int=0; i < tileQueue.length; i++) {
	            tile = tileQueue[i]
	            tile.draw();
	            tile.queued = false;       
	        }
		}
		
		public function addTile(bounds:Bounds, position:Pixel):Tile {
			return null;
		}
		
		public function addTileMonitoringHooks(tile:Tile):void {
			tile.onLoadStart = function():void {
	            //if that was first tile then trigger a 'loadstart' on the layer
	            if (this.numLoadingTiles == 0) {
	                this.events.triggerEvent("loadstart");
	            }
	            this.numLoadingTiles++;
	        };
	        this.addEventListener(MapEvent.TILE_LOAD_START, tile.onLoadStart);
	      
	        tile.onLoadEnd = function():void {
	            this.numLoadingTiles--;
	            this.events.triggerEvent("tileloaded");
	            //if that was the last tile, then trigger a 'loadend' on the layer
	            if (this.numLoadingTiles == 0) {
	                this.events.triggerEvent("loadend");
	            }
	        };
	        
	        this.addEventListener(MapEvent.TILE_LOAD_END, tile.onLoadEnd);

		}
		
		public function removeTileMonitoringHooks(tile:Tile):void {
			this.removeEventListener(MapEvent.TILE_LOAD_START, tile.onLoadStart);
			this.removeEventListener(MapEvent.TILE_LOAD_END, tile.onLoadEnd);
		}
		
		public function moveGriddedTiles(bounds:Bounds):void {
			var buffer:Number = this.buffer || 1;
	        while (true) {
	            var tlLayer:Pixel = this.grid[0][0].position;
	            var tlViewPort:Pixel = 
	                this.map.getViewPortPxFromLayerPx(tlLayer);
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
		
		override public function mergeNewParams(newArguments:Array):void {
	        super.mergeNewParams([newArguments]);
	
	        if (this.map != null) {
	            this._initTiles();
	        }
		}
		
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
		
		override public function onMapResize():void {
			if (this.singleTile) {
				this.clearGrid();
				this.setTileSize();
				this.initSingleTile(this.map.extent);
			}			
		}
		
		public function getTileBounds(viewPortPx:Pixel):Bounds {
	        var maxExtent:Bounds = this.map.maxExtent;
	        var resolution:Number = this.resolution;
	        var tileMapWidth:Number = resolution * this.tileSize.w;
	        var tileMapHeight:Number = resolution * this.tileSize.h;
	        var mapPoint:LonLat = this.getLonLatFromViewPortPx(viewPortPx);
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
		
	}
}