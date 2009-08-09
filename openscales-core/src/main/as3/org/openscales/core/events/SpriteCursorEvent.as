package org.openscales.core.events
{
	/**
	 * Event related to sprite cursors
	 */
	public class SpriteCursorEvent extends OpenScalesEvent
	{		

		public static const SPRITECURSOR_SHOW_HAND:String="openscales.showhand";		
		public static const SPRITECURSOR_HIDE_HAND:String="openscales.hidehand";

		public function SpriteCursorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}

