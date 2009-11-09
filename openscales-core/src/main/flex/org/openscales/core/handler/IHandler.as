package org.openscales.core.handler {
	import org.openscales.core.Map;

	/**
	 * A Handler is used to handle user actions on the map related to mouse,
	 * keyboard or sketch
	 */
	public interface IHandler{

		/**
		 * The map that is controlled by this handler
		 */
		function get map():Map;

		function set map(value:Map):void;

		/**
		 * Usually used to register or unregister event listeners
		 */
		function get active():Boolean;

		function set active(value:Boolean):void;
	}
}

