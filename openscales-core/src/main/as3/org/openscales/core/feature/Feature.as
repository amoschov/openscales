package org.openscales.core.feature {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.SpriteCursorEvent;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.popup.Anchored;
	import org.openscales.core.popup.Popup;


	/**
	 * Features is a geolocalized graphical element.
	 * It is generally subclassed to customized how it is displayed.
	 * They have an ‘attributes’ property, which is the data object.
	 */
	public class Feature extends Sprite {


		/**
		 * Constructor class
		 *
		 * @param layer The layer containing the feature.
		 * @param lonlat The lonlat position of the feature.
		 * @param data
		 */
		public function Feature(layer:Layer=null, lonlat:LonLat=null, data:Object=null) {
			this.layer=layer;
			this.lonlat=lonlat;
			if (data != null) {
				this.data=data;
			} else {
				this.data=new Object();
			}

			this.attributes=new Object();
			if (data) {
				this.attributes=Util.extend(this.attributes, data);
			}

		}

		/**
		 * Attributes usually generated from data parsing or user input
		 */
		private var _attributes:Object=null;

		/**
		 * Raw data that represent this feature. For exemple, this could contains the
		 * GML data for WFS features
		 *
		 * TODO : specify where we can specify if data are kept or not, in order to
		 * minimize memory consumption (GML use a lot of memory)
		 */
		private var _data:Object=null;

		/**
		 * The layer where this feature belong. Should be a LayerFeature or inherited classes.
		 */
		private var _layer:Layer=null;

		/**
		 * The geolocalized position of this feature, will be used to know where
		 * this feature should be drawn. Please not that lonlat getter and setter
		 * may be override in inherited classes to use other attributes to determine
		 * the position (for exemple the geometry)
		 */
		private var _lonlat:LonLat=null;

		/**
		 * The popup that will be displayed after a click on this feature
		 */
		private var _popup:Popup=null;

		/**
		 * Is this feature selected ?
		 */
		private var _selected:Boolean=false;

		/**
		 * Events Management
		 *
		 */
		public function onMouseHover(pevt:MouseEvent):void {
			this.buttonMode=true;
			this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_OVER, this));
		}

		public function onMouseMove(pevt:MouseEvent):void {
			this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEMOVE, this));
		}

		public function onMouseOut(pevt:MouseEvent):void {
			this.buttonMode=false;
			this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_OUT, this));
		}

		public function get attributes():Object {
			return this._attributes;
		}

		public function set attributes(value:Object):void {
			this._attributes=value;
		}

		/**
		 * Creates a popup for the feature
		 *
		 * @param closeBox
		 * @return The created popup
		 */
		public function createPopup(closeBox:Boolean=true):Popup {
			if (this.lonlat != null) {

				this.popup=new Anchored(this.lonlat, this.data.popupBackground, this.data.popupBorder, this.data.popupSize, this.data.popupContentHTML, this, closeBox);

				this.popup.feature=this;
			}
			return this.popup;
		}

		public function get data():Object {
			return this._data;
		}

		public function set data(value:Object):void {
			this._data=value;
		}

		/**
		 * Method to destroy a the feature instance.
		 */
		public function destroy():void {
			this.layer=null;
			this.name=null;
			this.lonlat=null;
			this.data=null;

			if (this.popup != null) {
				this.destroyPopup();
				this.popup=null;
			}
		}

		/**
		 * Destroys the popup
		 */
		public function destroyPopup():void {
			this.popup.feature=null;
			this.popup.destroy();
			this.popup=null;
		}

		/**
		 * The function allow to customize the display of this feature.
		 * Inherited Feature classes usually override this function.
		 */
		public function draw():void {
			this.graphics.clear();
		}

		public function get layer():Layer {
			return this._layer;
		}

		public function set layer(value:Layer):void {
			this._layer=value;
			if (this._layer != null) {
				this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseHover);
				this.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
				this.addEventListener(MouseEvent.CLICK, this.onMouseClick);
				this.addEventListener(MouseEvent.DOUBLE_CLICK, this.onMouseDoubleClick);
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				this.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
				this.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);

				/* this._layer.map.addEventListener(SpriteCursorEvent.SPRITECURSOR_HIDE_HAND, hideHand);
				this._layer.map.addEventListener(SpriteCursorEvent.SPRITECURSOR_SHOW_HAND, showHand); */ 
			}
		}

		public function get lonlat():LonLat {
			return this._lonlat;
		}

		public function set lonlat(value:LonLat):void {
			this._lonlat=value;
		}

		public function onMouseClick(pevt:MouseEvent):void {
			this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_CLICK, this, pevt.ctrlKey));
		}

		public function onMouseDoubleClick(pevt:MouseEvent):void {
			this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DOUBLECLICK, this));
		}

		public function onMouseDown(pevt:MouseEvent):void {
			/* this.buttonMode=true; */
			this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEDOWN, this));
		}

		public function onMouseUp(pevt:MouseEvent):void {
			/* this.buttonMode=false; */
			this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEUP, this, pevt.ctrlKey));
		}

		/**
		 * Determines if the feature is visible on the screen
		 */
		public function onScreen():Boolean {
			var onScreen:Boolean=false;
			if ((this.layer != null) && (this.layer.map != null)) {
				var screenBounds:Bounds=this.layer.map.extent;
				onScreen=screenBounds.containsLonLat(this.lonlat);
			}
			return onScreen;
		}

		public function get popup():Popup {
			return this._popup;
		}

		public function set popup(value:Popup):void {
			this._popup=value;
		}

		public function get selected():Boolean {
			return this._selected;
		}

		public function set selected(value:Boolean):void {
			this._selected=value;
		}

		public function get top():Number {
			if (this.layer && layer.map && this.layer.map.extent)
				return this.layer.map.extent.top / this.layer.map.resolution;
			else
				return NaN;
		}
		
		public function get left():Number {
			if (this.layer && layer.map && this.layer.map.extent)
				return -this.layer.map.extent.left / this.layer.map.resolution;
			else
				return NaN;
		}

		private function hideHand(event:SpriteCursorEvent):void {
			this.useHandCursor=false;
		}

		private function showHand(event:SpriteCursorEvent):void {
			this.useHandCursor=true;
		}
		
	}
}


