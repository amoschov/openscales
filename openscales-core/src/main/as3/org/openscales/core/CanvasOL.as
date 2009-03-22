package org.openscales.core
{
	import mx.containers.Canvas;

	public class CanvasOL extends Canvas
	{
		
		public var _eventCacheID:String = null;
		public var offsets:Object = null;
		public var style:Object = new Object();
		public var offsetWidth:Number = 0;
		public var offsetHeight:Number = 0;
		public var viewRequestID:int = 0;
		public var map:Object = null;
		public var zIndex:int;
		public var action:String = null;
		public var slideFactor:int;
		public var viewBox:Object = null;
		public var attributes:Object = new Object();
		public var _featureId:String = null;
		public var _geometryClass:String = null;
		public var _style:Object = new Object();
		public var _options:Object = new Object();
		public var type:String = null;
		public var classNameOL:String = null;
		public var feature:Feature = null;
		public var popup:PopupOL = null;
		public var context:Object = null;
		public var flIcon:Icon;
		
	}
}