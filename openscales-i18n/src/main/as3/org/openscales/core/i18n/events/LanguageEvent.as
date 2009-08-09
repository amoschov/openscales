/**
 * @see http://code.google.com/p/andromed-as/ under MPL 1.1
 * @see http://www.ekameleon.net/vegas/docs/andromeda/events/LocalizationEvent.html
 */
package org.openscales.core.i18n.events {
	import flash.utils.getQualifiedClassName;
	import flash.events.Event;
	import org.openscales.core.i18n.Lang;
	import org.openscales.core.i18n.LocalizedProperties;

	/**
	 * the localization event for firing language changes.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class LanguageEvent extends Event {

		/**
		 * The "loadedLang" event.
		 */
		public static var LOADED_LANG:String="loadedLang";

		/**
		 * The "failedLoadingLang" event.
		 */
		public static var FAILED_LOADING_LANG:String="failedLoadingLang";

		/**
		 * The "changeLang" event.
		 */
		public static var CHANGE_LANG:String="changeLang";

		/**
		 * The event emitter.
		 * @private
		 */
		private var _emitter:LocalizedProperties;

		/**
		 * Create an Event object to pass as a parameter to event listeners.
		 *
		 * @param type The type of event.
		 * @param emitter the optional emitter of the event.
		 * @param bubbles determines whether the Event object participates in the bubbling stage of
		 *                the event flow. The default value is false.
		 * @param cancelable determines whether the Event object can be canceled. The default values
		 *                   is false.
		 */
		public function LanguageEvent(type:String, emitter:LocalizedProperties=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.emitter=emitter;
		}

		/**
		 * Build a copy of this event.
		 *
		 * @return a clone of this event.
		 */
		public override function clone():Event {
			return new LanguageEvent(this.type, this.emitter, this.bubbles, this.cancelable);
		}

		/**
		 * Return the event emitter.
		 *
		 * @return the emitter, null if none.
		 */
		public function get emitter():LocalizedProperties {
			return this._emitter;
		}

		/**
		 * Set the event emitter.
		 *
		 * @param e the emitter.
		 */
		public function set emitter(e:LocalizedProperties):void {
			this._emitter=e;
		}

		/**
		 * Return the current language of the target.
		 *
		 * @return the current language or null if none.
		 */
		public function get language():Lang {
			if (this.emitter) {
				return this.emitter.language;
			}
			return null;
		}

	}

}
