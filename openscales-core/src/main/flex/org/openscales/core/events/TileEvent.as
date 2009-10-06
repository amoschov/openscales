package org.openscales.core.events
{
	import org.openscales.core.tile.Tile;
	
	/**
	 * Event related to a tile
	 */
	public class TileEvent extends OpenScalesEvent
	{
		/**
		 * Layer concerned by the event.
		 */
		private var _tile:Tile = null;

		/**
		 * Event type dispatched when a layer is added to the map.
		 */ 
		public static const TILE_LOAD_COMPLETE:String="openscales.tileloadcomplete";


		public function TileEvent(type:String, tile:Tile, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_tile = tile;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * tile concerned by the event.
		 */
		public function get tile():Tile {
			return this._tile;
		}				
	}
}