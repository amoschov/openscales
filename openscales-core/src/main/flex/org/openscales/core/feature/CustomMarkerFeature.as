package org.openscales.core.feature
{
	import flash.display.DisplayObject;
	
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Style;
	
	/**
	 * A CustomMarker is an graphical (extends DisplayObject) localized by a LonLat
	 * 
	 * As CustomMarker extends Feature, markers are generally added to FeatureLayer
	 */
	public class CustomMarkerFeature extends PointFeature {
		
		private var _clip:DisplayObject;
		private var _xOffset:Number;
		private var _yOffset:Number;
		
		/**
		 * @desc Constructor
		 * This will be deprecated in the following releases
		 * @param clip the DisplayObject to display
		 * @param geom the location of the marker (default null)
		 * @param data data (default null)
		 * @param style style (default null)
		 * @param xOffset Offset allowing marker position adjustment following the X axis (default 0)
		 * @param yOffset Offset allowing marker position adjustment following the Y axis (default 0)
		 */
		public function CustomMarkerFeature(clip:DisplayObject, geom:Point=null, data:Object=null, style:Style=null, xOffset:Number=0, yOffset:Number=0) {
			super(geom, data, style);
			_clip = clip;
			_xOffset = xOffset;
			_yOffset = yOffset;
			this.addChild(_clip);
		}
		
		override public function draw():void {
			// we compute the location of the marker
			var x:Number;
			var y:Number;
			var resolution:Number = this.layer.map.resolution;
			var dX:int = -int(this.layer.map.layerContainer.x) + this.left;
			var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			x = dX + _xOffset - (_clip.width/2) + point.x / resolution;
			y = dY + _yOffset - _clip.height - point.y / resolution;
			_clip.x = x;
			_clip.y = y;
		}
		
	}
}