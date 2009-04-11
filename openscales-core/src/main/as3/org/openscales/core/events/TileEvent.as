package org.openscales.core.events
{
	import org.openscales.core.tile.Tile;
	
	/**
	 * TODO : add event dispatch in code
	 */
	public class TileEvent extends OpenScalesEvent
	{
		private var _tile:Tile = null;
		
		public static const TILE_LOAD_START:String="openscales.loadstart";
		
		public static const TILE_LOAD_END:String="openscales.loadend";

		
		public function TileEvent(type:String, tile:Tile, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._tile = tile;
			super(type, bubbles, cancelable);
		}
		
	}
}