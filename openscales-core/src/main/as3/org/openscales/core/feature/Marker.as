package org.openscales.core.feature {
	import flash.display.Bitmap;
	
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;

	/**
	 * A Marker is an graphical element localized by a LonLat
	 *
	 * As Marker extends Feature, markers are generally added to FeatureLayer
	 */
	public class Marker extends PointFeature {
		/**
		 * Marker constructor
		 */
		public function Marker(geom:Point=null, data:Object=null, style:Style=null) {
			super(geom,data,style);		
		}

		/**
		 * Boolean used to know if that marker has been draw. This is used to draw markers only
		 *  when all the map and layer stuff are ready
		 */
		private var _drawn:Boolean = false;
		
		/**
		 * The image that will be drawn at the feature localization
		 */
		[Embed(source="/org/openscales/core/img/marker-blue.png")]
		private var _image:Class;

		/**
		 * Draw the marker
		 */
		override public function draw():void {
			super.draw();
			
			if (!this._drawn) {
				// Eventually remove old stuff
				while (this.numChildren>0) {
					this.removeChildAt(0);
				}
				this.addChild(new this._image());
				this._drawn=true;
			}
			var marker:Bitmap = this.getChildAt(0) as Bitmap;
			if(marker != null) {
				//var px:Pixel=this.layer.map.getLayerPxFromLonLat(this.lonlat);
				var px:Pixel=this.getLayerPxFromPoint(point);
				this.x=px.x - marker.width / 2;
				this.y=px.y - marker.height / 2;
			} else {
				trace("No marker found !");
			}
				
		}

		public function get image():Class {
			return this._image;
		}

		public function set image(value:Class):void {
			this._image=value;
			this._drawn = false;
			
		}
	}
}

