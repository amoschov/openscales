package org.openscales.core.feature {
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.marker.DisplayObjectMarker;
	import org.openscales.core.style.symbolizer.PointSymbolizer;

	/**
	 * A Marker is an graphical element localized by a LonLat
	 *
	 * As Marker extends Feature, markers are generally added to FeatureLayer
	 */
	public class Marker extends PointFeature {

		private var _graphic:DisplayObjectMarker;

		/**
		 * Marker constructor
		 */
		public function Marker(geom:Point=null, data:Object=null, style:Style=null) {
			super(geom, data, style, false);

			this._graphic = new DisplayObjectMarker(this._image, -8, -16, 16);
			var rule:Rule = new Rule();
			var symbolizer:PointSymbolizer = new PointSymbolizer(this._graphic);
			rule.symbolizers.push(symbolizer);
			this.style = new Style();
			this.style.rules.push(rule);
		}

		/**
		 * Boolean used to know if that marker has been draw. This is used to draw markers only
		 *  when all the map and layer stuff are ready
		 */
		private var _drawn:Boolean = false;

		/**
		 * The image that will be drawn at the feature localization
		 */
		[Embed(source="/assets/images/marker-blue.png")]
		private var _image:Class;

		public function get image():Class {
			return this._image;
		}

		public function set image(value:Class):void {
			this._image = value;
			this._drawn = false;

		}

		/**
		 * To obtain feature clone
		 * */
		override public function clone():Feature {
			var geometryClone:Geometry = this.geometry.clone();
			var MarkerClone:Marker = new Marker(geometryClone as Point, null, this.style);
			return MarkerClone;

		}
	}
}

