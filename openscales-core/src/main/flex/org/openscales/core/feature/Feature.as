package org.openscales.core.feature {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Trace;
	import org.openscales.core.Util;
	import org.openscales.basetypes.Bounds;
	import org.openscales.basetypes.LonLat;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.filter.ElseFilter;
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.Point;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Symbolizer;


	/**
	 * Features is a geolocalized graphical element.
	 * It is generally subclassed to customized how it is displayed.
	 * They have an ‘attributes’ property, which is the data object.
	 */
	public class Feature extends Sprite {

		private var _geometry:Geometry = null;
		private var _state:String = null;
		private var _style:Style = null;
		private var _originalStyle:Style = null;

		/**
		 * To know if the vector feature is editable when its
		 * vector layer is in edit mode
		 **/
		private var _isEditable:Boolean = false;


		/**
		 * Attributes usually generated from data parsing or user input
		 */
		private var _attributes:Object = null;

		/**
		 * Raw data that represent this feature. For exemple, this could contains the
		 * GML data for WFS features
		 *
		 * TODO : specify where we can specify if data are kept or not, in order to
		 * minimize memory consumption (GML use a lot of memory)
		 */
		private var _data:Object = null;

		/**
		 * The layer where this feature belong. Should be a LayerFeature or inherited classes.
		 */
		private var _layer:Layer = null;

		/**
		 * The geolocalized position of this feature, will be used to know where
		 * this feature should be drawn. Please not that lonlat getter and setter
		 * may be override in inherited classes to use other attributes to determine
		 * the position (for exemple the geometry)
		 */
		private var _lonlat:LonLat = null;

		/**
		 * Is this feature selected ?
		 */
		private var _selected:Boolean = false;


		/**
		 * Constructor class
		 *
		 * @param layer The layer containing the feature.
		 * @param lonlat The lonlat position of the feature.
		 * @param data
		 */
		public function Feature(geom:Geometry=null, data:Object=null, style:Style=null, isEditable:Boolean=false) {
			if (data != null) {
				this._data = data;
			} else {
				this._data = new Object();
			}

			this._attributes = new Object();
			if (data) {
				this._attributes = Util.extend(this._attributes, data);
			}

			this._geometry = geom;
			this._state = null;
			this._attributes = new Object();
			if (data) {
				this.attributes = Util.extend(this._attributes, data);
			}
			this._style = style ? style : null;

			this._isEditable = isEditable;
		}

		/**
		 * Events Management
		 *
		 */
		public function onMouseHover(pevt:MouseEvent):void {
			this.buttonMode = true;
			this._layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_OVER, this));
		}

		public function onMouseMove(pevt:MouseEvent):void {
			this._layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEMOVE, this));
		}

		public function onMouseOut(pevt:MouseEvent):void {
			this.buttonMode = false;
			this._layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_OUT, this));
		}

		public function registerListeners():void {
			this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseHover);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			this.addEventListener(MouseEvent.CLICK, this.onMouseClick);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, this.onMouseDoubleClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
		}

		public function unregisterListeners():void {
			this.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseHover);
			this.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			this.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK, this.onMouseDoubleClick);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
		}

		public function get attributes():Object {
			return this._attributes;
		}

		public function set attributes(value:Object):void {
			this._attributes = value;
		}

		public function get data():Object {
			return this._data;
		}

		public function set data(value:Object):void {
			this._data = value;
		}

		/**
		 * Method to destroy a the feature instance.
		 */
		public function destroy():void {
			this._attributes = null;
			this._data = null;
			this._layer = null;
			this._lonlat = null;
			this._geometry = null;
			this.unregisterListeners();
		}

		/**
		 * To obtain feature clone
		 * */
		public function clone():Feature {
			return null;
		}

		/**
		 * The function allow to customize the display of this feature.
		 * Inherited Feature classes usually override this function.
		 */
		public function draw():void {

			this.graphics.clear();
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}

			var style:Style;
			if (this._style == null) {
				// FIXME : Ugly thing done here
				style = (this.layer as FeatureLayer).style;
			} else {
				style = this._style;
			}

			// Storage variables to handle the rules to render if no rule applied to the feature
			var rendered:Boolean = false;
			var elseRules:Array = [];

			for each (var rule:Rule in style.rules) {
				// If a filter is set and no rule matches the filter skip the rule
				if (rule.filter != null) {
					if (rule.filter is ElseFilter) {
						elseRules.push(rule);
						continue;
					} else if (!rule.filter.matches(this)) {
						continue;
					}
				}
				this.renderRule(rule);
				rendered = true;
			}

			if (!rendered) {
				for each (var elseRule:Rule in elseRules) {
					this.renderRule(elseRule);
				}
			}
		}

		public function get layer():Layer {
			return this._layer;
		}

		public function set layer(value:Layer):void {
			this._layer = value;
			if (this._layer != null) {
				registerListeners();
			}
		}

		public function get lonlat():LonLat {
			var value:LonLat = null;
			if (this._geometry != null) {
				value = this._geometry.bounds.centerLonLat;   
			}
			return value;
		}

		public function onMouseClick(pevt:MouseEvent):void {
			this._layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_CLICK, this, pevt.ctrlKey));
		}

		public function onMouseDoubleClick(pevt:MouseEvent):void {
			this._layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DOUBLECLICK, this));
		}

		public function onMouseDown(pevt:MouseEvent):void {
			this._layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEDOWN, this));
		}

		public function onMouseUp(pevt:MouseEvent):void {
			this._layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEUP, this, pevt.ctrlKey));
		}

		/**
		 * Determines if the feature is visible on the screen
		 */
		public function onScreen():Boolean {
			var onScreen:Boolean = false;
			if ((this._layer != null) && (this._layer.map != null)) {
				var screenBounds:Bounds = this._layer.map.extent;
				onScreen = screenBounds.containsLonLat(this.lonlat);
			}
			return onScreen;
		}

		public function get selected():Boolean {
			return this._selected;
		}

		public function set selected(value:Boolean):void {
			this._selected = value;
		}

		public function get top():Number {
			if (this._layer)
				return this._layer.extent.top / this._layer.map.resolution;
			else
				return NaN;
		}

		public function get left():Number {
			if (this.layer)
				return -this._layer.extent.left / this._layer.map.resolution;
			else
				return NaN;
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
			if (this.geometry) {
				atPoint = this._geometry.atPoint(lonlat, toleranceLon, toleranceLat);
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
				switch (this._state) {
					case State.UNKNOWN:
					case State.DELETE:
						this._state = value;
						break;
					case State.UPDATE:
					case State.INSERT:
						break;
				}
			} else if (value == State.INSERT) {
				switch (this._state) {
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

		protected function renderRule(rule:Rule):void {
			var symbolizer:Symbolizer;
			var symbolizers:Array;
			var j:uint;
			var symbolizersCount:uint = rule.symbolizers.length;
			for (j = 0; j < symbolizersCount; ++j) {
				symbolizer = rule.symbolizers[j];
				if (this.acceptSymbolizer(symbolizer)) {
					symbolizer.configureGraphics(this.graphics, this);
					this.executeDrawing(symbolizer);
				}
			}
		}

		protected function acceptSymbolizer(symbolizer:Symbolizer):Boolean {
			return true;
		}

		protected function executeDrawing(symbolizer:Symbolizer):void {
			Trace.log("Feature.executeDrawing");
		}

		


		/**
		 * To know if the vector feature is editable when its
		 * vector layer is in edit mode
		 **/
		public function get isEditable():Boolean {
			return this._isEditable;
		}

		/**
		 * @private
		 * */
		public function set isEditable(value:Boolean):void {
			this._isEditable = value;

		}

		static public function compatibleFeatures(features:Vector.<Feature>):Boolean {
			if ((!features) || (features.length == 0) || (!features[0]) || (!(features[0] is Feature))) {
				return false;
			}
			var firstFeatureClassName:String = getQualifiedClassName(features[0]);
			for each (var feature:Feature in features) {
				if ((!(feature is Feature)) || (getQualifiedClassName(feature) != firstFeatureClassName)) {
					return false;
				}
			}
			return true;
		}

	}
}


