package org.openscales.core
{
	import flash.display.Sprite;
	
	import org.openscales.core.feature.Feature;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.popup.PopupOL;

	public class SpriteOL extends Sprite
	{
		
		public var id:String = null;
		public var attributes:Object = new Object();
		public var _featureId:String = null;
		public var _geometryClass:String = null;
		public var _style:Object = new Object();
		public var _options:Object = new Object();
		public var type:String = null;
		public var classNameOL:String = null;
		public var feature:Feature = null;
		public var popup:PopupOL = null;
		public var geometry:Geometry = null;
		public var _eventCacheID:Object = null;
		
	}
}