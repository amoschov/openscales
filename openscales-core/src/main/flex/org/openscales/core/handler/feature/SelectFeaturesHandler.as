package org.openscales.core.handler.feature {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.MultiPointFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.geometry.Geometry;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.stroke.Stroke;
	import org.openscales.core.style.symbolizer.LineSymbolizer;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;


	/**
	 * Select Features by clicking, by drawing a selection box or by drawing a
	 * freehand selection area.
	 * If the CTRL key is pressed, the previous selection is not cleared and the
	 * new selection is added.
	 * If the SHIFT key is pressed, the previous selection is not cleared and
	 * the new selection is removed.
	 * A click on a selected feature unselect it.
	 */
	public class SelectFeaturesHandler extends ClickHandler {
		/**
		 * Array of the layers to treat during a selection.
		 * If void (default), all the layers are managed.
		 */
		private var _layers:Vector.<Layer> = new Vector.<Layer>();

		/**
		 * Array of some features that may not be selected.
		 * If void (default), all the features of the _layers are selectable.
		 */
		private var _unselectableFeatures:Vector.<Feature> = new Vector.<Feature>();

		/**
		 * Size in pixels of the selection buffer (default=2 so a point is a
		 * 5-side square)
		 */
		private var _selectionBuffer:Number = 2;

		/**
		 * Array of the selected features.
		 */
		private var _selectedFeatures:Vector.<Feature> = new Vector.<Feature>();

		/**
		 * Callback function onSelectionUpdated(features:Array):void
		 */
		private var _onSelectionUpdated:Function = null;

		/**
		 * Callback function onOverFeature(feature:Feature):void
		 */
		private var _onOverFeature:Function = null;

		/**
		 * Callback function onOutFeature(feature:Feature):void
		 */
		private var _onOutFeature:Function = null;

		/**
		 * Callback function onSelectedFeature(feature:Feature):void
		 */
		private var _onSelectedFeature:Function = null;

		/**
		 * Callback function onUnselectedFeature(feature:Feature):void
		 */
		private var _onUnselectedFeature:Function = null;

		/**
		 * Callback function selectedStyle(feature:Feature):Style
		 * The default style function used is SelectFeaturesHandler.defaultSelectedStyle
		 */
		private var _selectedStyle:Function = SelectFeaturesHandler.defaultSelectedStyle;

		/**
		 * Sprite used to display the selection box.
		 */
		private var _drawContainer:Sprite = new Sprite();

		/**
		 * Style of the selection area: border thin (default=1)
		 */
		private var _selectionAreaBorderThin:Number = 2;

		/**
		 * Style of the selection area: border color (default=0xFFCC00)
		 */
		private var _selectionAreaBorderColor:uint = 0xFFCC00;

		/**
		 * Style of the selection area: fill color (default=0xCC0000)
		 */
		private var _selectionAreaFillColor:uint = 0xCC0000;

		/**
		 * Style of the selection area: opacity (default=0.33)
		 */
		private var _selectionAreaFillOpacity:Number = 0.33;

		private var _enableClickSelection:Boolean;
		private var _enableBoxSelection:Boolean;
		private var _enableSelection:Boolean;

		/**
		 * Constructor of the handler.
		 * @param map the map associated to the handler
		 * @param active boolean defining if the handler is active or not
		 */
		public function SelectFeaturesHandler(map:Map=null, active:Boolean=false, enableClickSelection:Boolean=true, enableBoxSelection:Boolean=true, enableOverSelection:Boolean=false) {
			super(map, active);
			if (this.map) {
				this.map.addChild(_drawContainer);
			}

			this.enableClickSelection = enableClickSelection;
			this.enableBoxSelection = enableBoxSelection;
			this.enableOverSelection = enableOverSelection;

		}

		public function set enableClickSelection(value:Boolean):void {
			if (value)
				this.click = this.selectByClick;
			else
				this.click = null;
		}

		public function set enableBoxSelection(value:Boolean):void {
			if (value) {
				this.drag = this.drawSelectionBox;
				this.drop = this.selectByBox;
			} else {
				this.drag = null;
				this.drop = null;
			}
		}

		public function set enableOverSelection(value:Boolean):void {
			if (value) {
				this.onOverFeature = this.selectByOver;
				this.onOutFeature = this.unselectByOut;
			} else {
				this.onOverFeature = null;
				this.onOutFeature = null;
			}
		}

		/**
		 * Layers array getter and setter
		 */
		public function get layers():Vector.<Layer> {
			return this._layers;
		}

		public function set layers(value:Vector.<Layer>):void {
			// Assert that the input array is composed of not null FeatureLayers
			if (value == null) {
				Trace.error("SelectFeaturesHandler - invalid layers (null)");
				return;
			} else {
				var len:int = value.length;
				// Restrict the input array to the not null FeatureLayers
				if (len > 0) {
					var filteredValue:Vector.<Layer> = new Vector.<Layer>();
					for each (var l:Layer in value) {
						if ((l != null) && (l is FeatureLayer)) {
							filteredValue.push(l);
						}
					}
					value = filteredValue;
					len = value.length;
					if (len == 0) {
						Trace.error("SelectFeaturesHandler - invalid layers (none FeatureLayer)");
						return;
					}
				}
			}
			// Unselect the features attached to the removed layers. If value is
			// a void array, the new layers are all the layers of the map, so
			// there is nothing to do in this case.
			if ((len > 0) && (this.layers.length > 0) && (this.selectedFeatures.length > 0)) {
				var layer:FeatureLayer;
				var i:int=0;
				for each (layer in this.layers) {
					// Is the layer in the array of the new layers ?
					while(i<len && layer != value[i])
						i++;// nothing else to do than to increment i
					// No if i equals value.length, so unselect its features
					if (i == value.length) {
						unselectFeaturesOfLayer(layer);
					}
				}
			}
			// Update the array of the layers to treat for the selection
			this._layers = value;
		}

		/**
		 * unselectableFeatures array getter and setter
		 */
		public function get unselectableFeatures():Vector.<Feature> {
			return this._unselectableFeatures;
		}

		public function set unselectableFeatures(value:Vector.<Feature>):void {
			this._unselectableFeatures = new Vector.<Feature>();
			if ((value == null) || (value.length == 0)) {
				return
			}
			// Filter the currently selected features
			var twoArrays:Vector.<Vector.<Feature>> = this.filterUnselectableFeatures(this._selectedFeatures);
			this._selectedFeatures = twoArrays[0];
			var unselectedFeatures:Vector.<Feature> = twoArrays[1];
			// Dispatch a FEATURE_UNSELECTED event for all the unselected features
			if (this.map && (unselectedFeatures.length > 0)) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_UNSELECTED, null);
				fevt.features = unselectedFeatures;
				this.map.dispatchEvent(fevt);
			}
		}

		/**
		 * Selection buffer getter and setter
		 */
		public function get selectionBuffer():Number {
			return this._selectionBuffer;
		}

		public function set selectionBuffer(value:Number):void {
			this._selectionBuffer = Math.max(0, value);
		}

		/**
		 * On selection updated function getter and setter
		 */
		public function get onSelectionUpdated():Function {
			return this._onSelectionUpdated;
		}

		public function set onSelectionUpdated(value:Function):void {
			this._onSelectionUpdated = value;
		}

		/**
		 * On over feature function getter and setter
		 */
		public function get onOverFeature():Function {
			return this._onOverFeature;
		}

		public function set onOverFeature(value:Function):void {
			this._onOverFeature = value;
		}

		/**
		 * On out feature function getter and setter
		 */
		public function get onOutFeature():Function {
			return this._onOutFeature;
		}

		public function set onOutFeature(value:Function):void {
			this._onOutFeature = value;
		}

		/**
		 * On selected feature function getter and setter
		 */
		public function get onSelectedFeature():Function {
			return this._onSelectedFeature;
		}

		public function set onSelectedFeature(value:Function):void {
			this._onSelectedFeature = value;
		}

		/**
		 * On unselected feature function getter and setter
		 */
		public function get onUnselectedFeature():Function {
			return this._onUnselectedFeature;
		}

		public function set onUnselectedFeature(value:Function):void {
			this._onUnselectedFeature = value;
		}

		/**
		 * selectedStyle function getter and setter
		 */
		public function get selectedStyle():Function {
			return this._selectedStyle;
		}

		public function set selectedStyle(value:Function):void {
			this._selectedStyle = value;
		}

		/**
		 * Selection geometry's border thin getter and setter
		 */
		public function get selectionAreaBorderThin():Number {
			return this._selectionAreaBorderThin;
		}

		public function set selectionAreaBorderThin(value:Number):void {
			this._selectionAreaBorderThin = value;
		}

		/**
		 * Selection geometry's border color getter and setter
		 */
		public function get selectionAreaBorderColor():uint {
			return this._selectionAreaBorderColor;
		}

		public function set selectionAreaBorderColor(value:uint):void {
			this._selectionAreaBorderColor = value;
		}

		/**
		 * Selection geometry's fill color getter and setter
		 */
		public function get selectionAreaFillColor():uint {
			return this._selectionAreaFillColor;
		}

		public function set selectionAreaFillColor(value:uint):void {
			this._selectionAreaFillColor = value;
		}

		/**
		 * Selection geometry's fill opacity thin getter and setter
		 */
		public function get selectionAreaFillOpacity():Number {
			return this._selectionAreaFillOpacity;
		}

		public function set selectionAreaFillOpacity(value:Number):void {
			this._selectionAreaFillOpacity = value;
		}

		/**
		 * Array of the selected features
		 */
		public function get selectedFeatures():Vector.<Feature> {
			return this._selectedFeatures;
		}

		/**
		 * Set the map associated to the handler.
		 * The current selection is cleared and the array of the layers to treat
		 * is reset to a void array.
		 */
		override public function set map(value:Map):void {
			// Reset the selection and the array of the layers to treat
			if (this.map != value) {
				clearSelection();
				this.layers = new Vector.<Layer>();
			}
			// Update the map associated to the handler
			if (this.map) {
				this.map.removeChild(_drawContainer);
			}
			super.map = value;
			if (this.map) {
				this.map.addChild(_drawContainer);
			}
		}

		/**
		 * Add the listeners to the associated map
		 */
		override protected function registerListeners():void {
			// Listeners of the super class
			super.registerListeners();
			// Listeners of the associated map
			if (this.map) {
				this.map.addEventListener(LayerEvent.LAYER_REMOVED, this.onLayerRemoved);
				this.map.addEventListener(FeatureEvent.FEATURE_OVER, this.onOver);
				this.map.addEventListener(FeatureEvent.FEATURE_OUT, this.onOut);
				this.map.addEventListener(FeatureEvent.FEATURE_SELECTED, this.onSelected);
				this.map.addEventListener(FeatureEvent.FEATURE_UNSELECTED, this.onUnselected);
			}
		}

		/**
		 * Remove the listeners to the associated map
		 */
		override protected function unregisterListeners():void {
			// Listeners of the associated map
			if (this.map) {
				this.map.removeEventListener(LayerEvent.LAYER_REMOVED, this.onLayerRemoved);
				this.map.removeEventListener(FeatureEvent.FEATURE_OVER, this.onOver);
				this.map.removeEventListener(FeatureEvent.FEATURE_OUT, this.onOut);
				this.map.removeEventListener(FeatureEvent.FEATURE_SELECTED, this.onSelected);
				this.map.removeEventListener(FeatureEvent.FEATURE_UNSELECTED, this.onUnselected);
			}
			// Listeners of the super class
			super.unregisterListeners();
		}

		/**
		 * Unselect all the features of the input layer.
		 * @param layer the FeatureLayer removed from the layers to manage
		 */
		private function unselectFeaturesOfLayer(layer:FeatureLayer):void {
			// Look for all the selected features attached to the removed layers
			var featuresToUnselect:Vector.<Feature> = new Vector.<Feature>();
			for each (var feature:Feature in this.selectedFeatures) {
				if (feature.layer == layer) {
					featuresToUnselect.push(feature);
					break;
				}
			}
			// Remove these features of the selection
			this.unselect(featuresToUnselect);
		}

		/**
		 * Unselect all the features of the removed layer
		 * @param evt the LayerEvent that defines the layer removed from the map
		 */
		private function onLayerRemoved(evt:LayerEvent):void {
			if ((!evt) || (evt.type != LayerEvent.LAYER_REMOVED) || (!evt.layer) || (!(evt.layer is FeatureLayer))) {
				return;
			}
			unselectFeaturesOfLayer(evt.layer as FeatureLayer);
		}

		/**
		 * If defined, use the onOverFeature callback function for all the
		 * features of the input event.
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the FeatureEvent
		 */
		private function onOver(evt:FeatureEvent):void {
			if (this.onOverFeature != null) {
				this.onSomething(evt, null, this.onOverFeature);
			}
		}

		/**
		 * If defined, use the onOutFeature callback function for all the
		 * features of the input event.
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the FeatureEvent
		 */
		private function onOut(evt:FeatureEvent):void {
			if (this.onOutFeature != null) {
				this.onSomething(evt, null, this.onOutFeature);
			}
		}

		/**
		 * If defined, use the onSelectedFeature callback function for all the
		 * features of the input event.
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the FeatureEvent
		 */
		private function onSelected(evt:FeatureEvent):void {
			if ((this.setSelectedStyle != null) || (this.onSelectedFeature != null)) {
				this.onSomething(evt, this.setSelectedStyle, this.onSelectedFeature);
			}
		}

		/**
		 * If defined, use the onUnselectedFeature callback function for all the
		 * features of the input event.
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the FeatureEvent
		 */
		private function onUnselected(evt:FeatureEvent):void {
			if ((this.setSelectedStyle != null) || (this.onUnselectedFeature != null)) {
				this.onSomething(evt, this.resetStyle, this.onUnselectedFeature);
			}
		}

		/**
		 * Generic function called by all the onOver, onOut, onSelected and
		 * onUnselected functions.
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the FeatureEvent that defines the array of the features to
		 * treat
		 * @param updateStyleFeature the function to use for updating the style
		 * of the features
		 * @param onSomethingFeature the callback function to use for each of
		 * the features
		 */
		private function onSomething(evt:FeatureEvent, updateStyleFeature:Function, onSomethingFeature:Function):void {
			var i:int, layer:FeatureLayer, layersTmp:Array = new Array();

			if (this._dragging)
				return;

			for each (var feature:Feature in evt.features) {
				if (updateStyleFeature != null) {
					updateStyleFeature(feature);
				}

				if (onSomethingFeature != null) {
					onSomethingFeature(feature);
				}

				feature.draw();
			}

		}

		/**
		 * (Un)select all the features that contain the location clicked (the
		 * selectionBuffer is used to enlarge the selection area).
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the MouseEvent (useful for the position of MouseUp and for
		 * the status of the CTRL and SHIFT keys)
		 */
		private function selectByClick(p:Pixel):void {
			// A point and a selectionBuffer define a selection box...
			this.selectByBox(p);
		}

		private function selectByOver(feature:Feature):void {
			this.unselect(this.selectedFeatures);
			var v:Vector.<Feature> = new Vector.<Feature>();
			v.push(feature);
			this.select(v);
		}

		private function unselectByOut(feature:Feature):void {
			this.unselect(this.selectedFeatures);
		}

		/**
		 * (Un)select all the features that intersect the box drawn (the
		 * selectionBuffer is used to enlarge the selection area).
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the MouseEvent (useful for the position of MouseUp and for
		 * the status of the CTRL and SHIFT keys)
		 */
		private function selectByBox(p:Pixel):void {
			// Clear the selection drawing
			_drawContainer.graphics.clear();
			// Get the selection area
			var sbox:Bounds = this.selectionBoxCoordinates(p, this.selectionBuffer);
			var sboxGeom:Geometry = (sbox) ? sbox.toGeometry() : null;

			// Select the features that intersect the geometry
			this.selectByGeometry(sboxGeom, this._ctrlKey, this._shiftKey);
		}

		/**
		 * (Un)select all the features that intersect the input geometry.
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param geom the exact geometry to use for the selection (the
		 * selection buffer is not added)
		 * @param additiveMode if true the input features are added to the
		 * current selection ; if false and substractiveMode too they replace it
		 * @param substractiveMode if true and additiveMode false the input
		 * features are removed from the current selection
		 */
		private function selectByGeometry(geom:Geometry, additiveMode:Boolean=false, substractiveMode:Boolean=false):void {
			// Look for all the features that intersect the selection geometry
			var featuresToSelect:Vector.<Feature> = new Vector.<Feature>();
			if (geom) {
				var layersToTest:Vector.<Layer> = (this.layers.length > 0) ? this.layers : this.map.featureLayers;
				var layer:FeatureLayer, layersTmp:Vector.<Layer> = new Vector.<Layer>();
				// Remove invisible layers from the list of selectable layers
				for each (layer in layersToTest) {
					if (layer.displayed) {
						layersTmp.push(layer);
					}
				}
				layersToTest = layersTmp;
				// 
				for each (layer in layersToTest) {
					for each (var feature:Feature in layer.features) {
						if (geom.intersects(feature.geometry)) {
							featuresToSelect.push(feature);
						}
					}
				}
			}
			// Update the selection
			if (substractiveMode && (!additiveMode)) {
				this.unselect(featuresToSelect);
			} else {
				this.select(featuresToSelect, additiveMode);
			}
		}

		/**
		 * Add or replace features to the current selection.
		 * The features are asserted to be in one of the layers to manage.
		 * @param featuresToSelect the array of the features to add / replace by
		 * @param additiveMode if true the input features are added to the
		 * current selection ; if false they replace it
		 */
		private function select(featuresToSelect:Vector.<Feature>, additiveMode:Boolean=false):void {
			var selectionUpdated:Boolean = false;
			var removedFeatures:Vector.<Feature> = new Vector.<Feature>(); // the features to remove of the current selection
			var feature:Feature;
			var fevt:FeatureEvent;
			// If the current selection is not void, first we restrict the
			// features of the input array to the really new selected features
			// and we unselect the features that need it.
			if (this.selectedFeatures.length > 0) {
				var sf:Vector.<Feature> = new Vector.<Feature>(); // the features to keep selected
				var i:int, found:Boolean;
				if (!additiveMode) {
					// If additive mode is not selected, remove all the current
					// selected features that are not in the input array.
					for each (feature in this.selectedFeatures) {
						for (i = 0, found = false; (!found) && (i < featuresToSelect.length); i++) {
							if (feature == featuresToSelect[i]) {
								found = true;
							}
						}
						if (found) {
							// If this currently selected feature is reselected,
							// keep it in the current selection
							sf.push(feature);
						} else {
							// Otherwise add it to the features to remove
							feature.selected = false;
							removedFeatures.push(feature);
						}
					}
					// Update the array of the selected features
					this._selectedFeatures = sf;
				}
				// Remove from the input array all the reselected features
				var nsf:Vector.<Feature> = new Vector.<Feature>(); // the really new features in the input array
				for each (feature in featuresToSelect) {
					for (i = 0, found = false; (!found) && (i < this.selectedFeatures.length); i++) {
						if (feature == this.selectedFeatures[i]) {
							found = true;
						}
					}
					if (!found) {
						nsf.push(feature);
					}
				}
				featuresToSelect = nsf;
			}
			// Filter the features to select to avoid the unselectable features
			var twoArrays:Vector.<Vector.<Feature>> = this.filterUnselectableFeatures(featuresToSelect);
			featuresToSelect = twoArrays[0];
			var noselectedFeatures:Vector.<Feature> = twoArrays[1];
			// Add all the really new selected features to the selection
			for each (feature in featuresToSelect) {
				feature.selected = true;
				this._selectedFeatures.push(feature);
			}
			// Dispatch a FEATURE_UNSELECTED event for all the unselected features
			if (this.map && (removedFeatures.length > 0)) {
				fevt = new FeatureEvent(FeatureEvent.FEATURE_UNSELECTED, null, additiveMode);
				fevt.features = removedFeatures;
				this.map.dispatchEvent(fevt);
			}
			// Dispatch a FEATURE_SELECTED event for all the newly selected features
			if (this.map && (featuresToSelect.length > 0)) {
				fevt = new FeatureEvent(FeatureEvent.FEATURE_SELECTED, null, additiveMode);
				fevt.features = featuresToSelect;
				this.map.dispatchEvent(fevt);
			}
			// Log the selection modification
			Trace.log("SelectFeaturesHandler: " + featuresToSelect.length + " new features selected with additive mode " + ((additiveMode) ? "ON" : "OFF") + " and " + noselectedFeatures.length + " rejected features => " + this.selectedFeatures.length + " features selected");
			// if the selection has been updated, use the associated callback
			if (selectionUpdated && (this.onSelectionUpdated != null)) {
				this.onSelectionUpdated(this.selectedFeatures);
			}
		}

		/**
		 * Remove features from the current selection.
		 * The features are asserted to be in one of the layers to manage.
		 * @param featuresToUnselect the array of the features to remove
		 */
		private function unselect(featuresToUnselect:Vector.<Feature>):void {
			// Unselect the input features that are registred as selected
			var selectionUpdated:Boolean = false;
			var removedFeatures:Vector.<Feature> = new Vector.<Feature>(); // the features really removed from the current selection
			var feature:Feature;
			var i:int, found:Boolean;
			for each (feature in featuresToUnselect) {
				for (i = 0, found = false; (!found) && (i < this.selectedFeatures.length); i++) {
					if (feature == this.selectedFeatures[i]) {
						found = true;
						removedFeatures.push(feature);
						this.selectedFeatures.splice(i, 1);
						selectionUpdated = true;
					}
				}
				if (!found) {
					Trace.warning("unselect warning: unselected feature, nothing to do");
				}
			}
			// Dispatch a FEATURE_UNSELECTED event for all the unselected features
			if (this.map && (removedFeatures.length > 0)) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_UNSELECTED, null);
				fevt.features = removedFeatures;
				this.map.dispatchEvent(fevt);
			}
			// Log the selection modification
			Trace.log("SelectFeaturesHandler: " + removedFeatures.length + " features removed from the selection => " + this.selectedFeatures.length + " features selected");
			// if the selection has been updated, use the associated callback
			if (selectionUpdated && (this.onSelectionUpdated != null)) {
				this.onSelectionUpdated(this.selectedFeatures);
			}
		}

		/**
		 * Clear the current selection.
		 */
		public function clearSelection():void {
			var selectionUpdated:Boolean = (this.selectedFeatures.length > 0);
			// If the selection is void there is nothing to do
			if (!selectionUpdated) {
				return;
			}
			// Clear the selection
			var removedFeatures:Vector.<Feature> = this.selectedFeatures;
			this._selectedFeatures = new Vector.<Feature>();
			// Dispatch a FEATURE_UNSELECTED event for all the unselected features
			if (this.map && (removedFeatures.length > 0)) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_UNSELECTED, null);
				fevt.features = removedFeatures;
				this.map.dispatchEvent(fevt);
			}
			// Log the selection modification
			Trace.log("SelectFeaturesHandler: selection cleared of its " + removedFeatures.length + " features");
			// if the selection has been updated, use the associated callback
			if (selectionUpdated && (this.onSelectionUpdated != null)) {
				this.onSelectionUpdated(this.selectedFeatures);
			}
		}

		/**
		 * Filter the input array of features to keep only those that are not
		 * declared in the unselectableFeatures array.
		 * @param featuresToFilter the array to filter
		 * @return array of two arrays, the first contains the accepted features
		 * and the second contains the rejected features.
		 */
		private function filterUnselectableFeatures(featuresToFilter:Vector.<Feature>):Vector.<Vector.<Feature>> {
			var acceptedFeatures:Vector.<Feature> = new Vector.<Feature>();
			var rejectedFeatures:Vector.<Feature> = new Vector.<Feature>();
			var i:int, found:Boolean;
			for each (var feature:Feature in featuresToFilter) {
				for (i = 0, found = false; (!found) && (i < this.unselectableFeatures.length); i++) {
					if (feature == this.unselectableFeatures[i]) {
						found = true;
						rejectedFeatures.push(feature);
					}
				}
				if (!found) {
					acceptedFeatures.push(feature);
				}
			}
			var v:Vector.<Vector.<Feature>> = new Vector.<Vector.<Feature>>();
			v[0] = acceptedFeatures;
			v[1] = rejectedFeatures;
			return v;
		}

		/**
		 * Set the style of a selected feature depending on its type (point,
		 * multipoint, linestring, multilinestring, polygon, multipolygon).
		 * The current style is saved for a possible future reset of the style.
		 * @param feature the feature to update its style
		 */
		private function setSelectedStyle(feature:Feature):void {
			feature.originalStyle = feature.style;
			feature.style = (this.selectedStyle != null) ? this.selectedStyle(feature) : SelectFeaturesHandler.defaultSelectedStyle(feature);
		}

		/**
		 * Reset the style of a unselected feature
		 * @param feature the feature to update its style
		 */
		private function resetStyle(feature:Feature):void {
			feature.style = feature.originalStyle;
		}

		/**
		 * Display the selection box that the user is drawing.
		 * @param evt the MouseEvent
		 */
		private function drawSelectionBox(evt:MouseEvent):void {
			// Compute the selection box (in pixels)
			var rect:Rectangle = this.selectionBoxPixels(new Pixel(evt.currentTarget.mouseX, evt.currentTarget.mouseY));
			// Display the selection box
			_drawContainer.graphics.clear();
			_drawContainer.graphics.lineStyle(this.selectionAreaBorderThin, this.selectionAreaBorderColor);
			_drawContainer.graphics.beginFill(this.selectionAreaFillColor, this.selectionAreaFillOpacity);
			_drawContainer.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			_drawContainer.graphics.endFill();
		}

		/**
		 * Default style used for a selected feature.
		 * The style depends on the type of the input feature (point, multipoint,
		 * linestring, multilinestring, polygon, multipolygon).
		 */
		static public function defaultSelectedStyle(feature:Feature):Style {
			var selectedStyle:Style;
			var symbolizer:Symbolizer;
			var color:uint = 0xFFFF00;
			var opacity:Number = 0.5;
			var borderThin:int = 2;
			if (feature is PointFeature || feature is MultiPointFeature) {
				var markType:String = WellKnownMarker.WKN_SQUARE;
				var markSize:Number = 12;
				var currentMarkSymbolizer:Symbolizer = null; //feature.style.rules[0].symbolizers[0];
				if (currentMarkSymbolizer && (currentMarkSymbolizer is PointSymbolizer)) {
					var currentMark:WellKnownMarker = (currentMarkSymbolizer as PointSymbolizer).graphic as WellKnownMarker; // FixMe : How can we be sure at this point that graphic is a WellKnownMarker ?
					markType = currentMark.wellKnownName;
					markSize = currentMark.size as Number;
				}
				selectedStyle = Style.getDefaultPointStyle();
				symbolizer = new PointSymbolizer(new WellKnownMarker(markType, new SolidFill(color, opacity), new Stroke(color, borderThin), markSize));
			} else if (feature is LineStringFeature || feature is MultiLineStringFeature) {
				selectedStyle = Style.getDefaultSurfaceStyle();
				symbolizer = new LineSymbolizer(new Stroke(color, borderThin));
			} else { //if (feature is PolygonFeature || feature is MultiPolygonFeature) {
				selectedStyle = Style.getDefaultSurfaceStyle();
				symbolizer = new PolygonSymbolizer(new SolidFill(color, opacity), new Stroke(color, borderThin));
			}
			selectedStyle.rules[0] = new Rule();
			selectedStyle.rules[0].symbolizers.push(symbolizer);
			return selectedStyle;
		}

	}
}