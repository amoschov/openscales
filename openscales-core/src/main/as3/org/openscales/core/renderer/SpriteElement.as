package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import org.openscales.core.feature.Style;

	/**
	 * Sprite element used by the Sprite Renderer.
	 */
	public class SpriteElement extends Sprite
	{
		
		private var _style:Style = null;
		private var _featureId:String = null;
		private var _options:Object = new Object();
		private var _geometryClass:String = null;
		private var _attributes:Object = new Object();
		
		public function get style():Style {
			return this._style;
		}
		
		public function set style(value:Style):void {
			this._style = value;
		}
		
		public function get featureId():String {
			return this._featureId;
		}
		
		public function set featureId(value:String):void {
			this._featureId = value;
		}
		
		public function get options():Object {
			return this._options;
		}
		
		public function set options(value:Object):void {
			this._options = value;
		}
		
		public function get geometryClass():String {
			return this._geometryClass;
		}
		
		public function set geometryClass(value:String):void {
			this._geometryClass = value;
		}
		
		public function get attributes():Object {
			return this._attributes;
		}
		
		public function set attributes(value:Object):void {
			this._attributes = value;
		}
		
		
	}
}