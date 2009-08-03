package org.openscales.core.feature {
	import flash.display.Bitmap;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.layer.Layer;

	/**
	 * A Marker is an graphical element localized by a LonLat
	 *
	 * As Marker extends Feature, markers are generally added to FeatureLayer
	 */
	public class Marker extends Feature {
		/**
		 * Marker constructor
		 */
		public function Marker(layer:Layer=null, lonlat:LonLat=null, data:Object=null) {
			super(layer, lonlat, data);
		}

		/**
		 * Boolean used to know if that marker has been draw. This is used to draw markers only
		 *  when all the map and layer stuff are ready
		 */
		private var _drawn:Boolean=false;

		/**
		 * The image that will be drawn at the feature localization
		 */
		[Embed(source="/org/openscales/core/img/marker-blue.png")]
		private var _image:Class;

		/**
		 * Draw the marker
		 */
		override public function draw():void {
			if (!this._drawn) {
				super.draw();
				var marker:Bitmap=new this._image();
				var px:Pixel=this.layer.map.getLayerPxFromLonLat(this.lonlat);
				marker.x=px.x - marker.width / 2;
				marker.y=px.y - marker.height / 2;
				this.addChild(marker);
				this._drawn=true;
			}
		}

		public function get image():Class {
			return this._image;
		}

		public function set image(value:Class):void {
			this._image=value;
		}
	}
}

