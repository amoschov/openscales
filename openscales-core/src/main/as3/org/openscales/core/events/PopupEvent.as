package org.openscales.core.events
{
	import org.openscales.core.popup.Popup;
	
	/**
	 * Event related to a popup.
	 * 
	 * TODO : add event dispatch in code
	 */
	public class PopupEvent extends OpenScalesEvent
	{
		/**
		 * Popup concerned by the event.
		 */
		private var _popup:Popup = null;
		
		public static const POPUP_OPEN:String="openscales.popupopen";
		
		public static const POPUP_CLOSE:String="openscales.popupclose";

		public function PopupEvent(type:String, popup:Popup, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._popup = popup;
			super(type, bubbles, cancelable);
		}
		
		public function get popup():Popup {
			return this._popup;
		}
		
		public function set popup(popup:Popup):void {
			this._popup = popup;	
		}
		
	}
}