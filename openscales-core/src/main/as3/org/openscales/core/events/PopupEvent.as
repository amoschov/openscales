package org.openscales.core.events
{
	import org.openscales.core.popup.Popup;
	import org.openscales.core.tile.Tile;
	
	/**
	 * TODO : add event dispatch in code
	 */
	public class PopupEvent extends OpenScalesEvent
	{
		private var _popup:Popup = null;
		
		public static const POPUP_OPEN:String="openscales.popupopen";
		
		public static const POPUP_CLOSE:String="openscales.popupclose";

		public function PopupEvent(type:String, popup:Popup, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._popup = popup;
			super(type, bubbles, cancelable);
		}
		
	}
}