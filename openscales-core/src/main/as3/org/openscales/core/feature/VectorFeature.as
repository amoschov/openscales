package org.openscales.core.feature
{
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.geometry.Geometry;

	/**
	 * Vector features use the Geometry classes as geometry description.
	 * They have an ‘attributes’ property, which is the data object, and a ‘style’ property.
	 */
	public class VectorFeature extends Feature
	{

		private var _geometry:Geometry = null;
		private var _state:String = null;    
		private var _style:Style = null;	    
		private var _originalStyle:Style = null;

		/**
		 * VectorFeature constructor
		 *
		 * @param geometry The feature's geometry
		 * @param data
		 * @param style The feature's style
		 */
		public function VectorFeature(geometry:Geometry = null, data:Object = null, style:Style = null) {
			super(null, null, data);
			this.lonlat = null;
			this.geometry = geometry;
			if (this.geometry && this.geometry.id)
				this.name = this.geometry.id;
			this.state = null;
			this.attributes = new Object();
			if (data) {
				this.attributes = Util.extend(this.attributes, data);
			}
			this.style = style ? style : null;
		}

		/**
		 * Destroys the VectorFeature
		 */
		override public function destroy():void {
			if (this.layer) {
				this.layer = null;
			}

			this.geometry = null;
			//super.destroy();
		}

		/**
		 * Determines if the feature is placed at the given point with a certain tolerance (or not).
		 *
		 * @param lonlat The given point
		 * @param toleranceLon The longitude tolerance
		 * @param toleranceLat The latitude tolerance
		 */
		public function atPoint(lonlat:LonLat, toleranceLon:Number, toleranceLat:Number):Boolean {
			var atPoint:Boolean = false;
			if(this.geometry) {
				atPoint = this.geometry.atPoint(lonlat, toleranceLon, 
					toleranceLat);
			}
			return atPoint;
		}

		public function get geometry():Geometry {
			return this._geometry;
		}

		public function set geometry(value:Geometry):void {
			this._geometry = value;
		}

		public function get state():String {
			return this._state;
		}

		public function set state(value:String):void {

			if (value == State.UPDATE) {
				switch (this.state) {
					case State.UNKNOWN:
					case State.DELETE:
						this._state = value;
						break;
					case State.UPDATE:
					case State.INSERT:
						break;
				}
			} else if (value == State.INSERT) {
				switch (this.state) {
					case State.UNKNOWN:
						break;
					default:
						this._state = value;
						break;
				}
			} else if (value == State.DELETE) {
				switch (this.state) {
					case State.INSERT:
						break;
					case State.DELETE:
						break;
					case State.UNKNOWN:
					case State.UPDATE:
						this._state = value;
						break;
				}
			} else if (value == State.UNKNOWN) {
				this._state = value;
			}
		}

		public function get style():Style {
			return this._style;
		}

		public function set style(value:Style):void {
			this._style = value;
		}

		public function get originalStyle():Style {
			return this._originalStyle;
		}

		public function set originalStyle(value:Style):void {
			this._originalStyle = value;
		}

		override public function draw():void {
			super.draw();

			// Apply style
			if (style.isFilled) {
				this.graphics.beginFill(style.fillColor, style.fillOpacity);
			} else {
				this.graphics.endFill();
			}

			if (style.isStroked) {
				this.graphics.lineStyle(style.strokeWidth, style.strokeColor, style.strokeOpacity, false, "normal", style.strokeLinecap);
			}

		}

	}
}

