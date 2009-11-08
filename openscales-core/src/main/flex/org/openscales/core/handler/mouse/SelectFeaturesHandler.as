package org.openscales.core.handler.mouse
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.layer.FeatureLayer;
	
	/**
	 * Select Features by clicking, by drawing a selection box or by drawing a
	 * freehand selection area.
	 * If the CTRL key is pressed, the previous selection is not cleared and the
	 * new selection is added.
	 * A click on a selected feature unselect it.
	 */
	public class SelectFeaturesHandler extends ClickHandler
	{
		/**
		 * Array of the layers to treat during a selection.
		 * If void (default), all the layers are managed.
		 */
		private var _layers:Array = new Array();
		
		/**
		 * Size in pixels of the selection buffer (default=1 so a point is a
		 * 3-side square)
		 */        
		private var _selectionBuffer:Number = 1;
		
		/**
		 * Array of the selected features.
		 */
		private var _selectedFeatures:Array = new Array();
		
		/**
		 * Callback function onOverFeature(evt:FeatureEvent):void
		 */
		private var _onOverFeature:Function = null;
		
		/**
		 * Callback function onOutFeature(evt:FeatureEvent):void
		 */
		private var _onOutFeature:Function = null;
		
		/**
		 * Callback function onSelectedFeature(evt:FeatureEvent):void
		 */
		private var _onSelectedFeature:Function = null;
		
		/**
		 * Callback function onUnselectedFeature(evt:FeatureEvent):void
		 */
		private var _onUnselectedFeature:Function = null;
		
		/**
		 * Sprite used to display the selection box.
		 */
        private var drawContainer:Sprite = new Sprite();
		
		/**
		 * Style of the selection geometry: border thin (default=1)
		 */        
		private var _selectionBorderThin:Number = 2;
		
		/**
		 * Style of the selection geometry: border color (default=0xFFCC00)
		 */        
		private var _selectionBorderColor:uint = 0xFFCC00;
		
		/**
		 * Style of the selection geometry: fill color (default=0xCC0000)
		 */        
		private var _selectionFillColor:uint = 0xCC0000;
		
		/**
		 * Style of the selection geometry: opacity (default=0.5)
		 */        
		private var _selectionFillOpacity:Number = 0.33;

		/**
		 * Constructor
		 */
		public function SelectFeaturesHandler(map:Map=null, active:Boolean=false) {
			super(map, active);
			if (this.map) {
				this.map.addChild(drawContainer);
			}
			this.click = this.selectByClick;
			this.drag = this.drawSelectionBox;
			this.drop = this.selectByBox;
		}
		
		/**
		 * Layers array getter and setter
		 */
		public function get layers():Array {
			return this._layers;
		}
		public function set layers(value:Array):void {
			if (value != null) {
				this._layers = value;
			} else {
				Trace.error("SelectFeaturesHandler - invalid layers");
			}
		}
		
		/**
		 * Selection buffer getter and setter
		 */
		public function get selectionBuffer():Number {
			return this._selectionBuffer;
		}
		public function set selectionBuffer(value:Number):void {
			this._selectionBuffer = Math.max(0,value);
		}
		
		/**
		 * Array of the selected features
		 */
		public function get selectedFeatures():Array {
			return this._selectedFeatures;
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
		 * Selection geometry's border thin getter and setter
		 */
		public function get selectionBorderThin():Number {
			return this._selectionBorderThin;
		}
		public function set selectionBorderThin(value:Number):void {
			this._selectionBorderThin = value;
		}
		
		/**
		 * Selection geometry's border color getter and setter
		 */
		public function get selectionBorderColor():uint {
			return this._selectionBorderColor;
		}
		public function set selectionBorderColor(value:uint):void {
			this._selectionBorderColor = value;
		}
		
		/**
		 * Selection geometry's fill color getter and setter
		 */
		public function get selectionFillColor():uint {
			return this._selectionFillColor;
		}
		public function set selectionFillColor(value:uint):void {
			this._selectionFillColor = value;
		}
		
		/**
		 * Selection geometry's fill opacity thin getter and setter
		 */
		public function get selectionFillOpacity():Number {
			return this._selectionFillOpacity;
		}
		public function set selectionFillOpacity(value:Number):void {
			this._selectionFillOpacity = value;
		}
		
		/**
		 * 
		 */
		override public function set map(value:Map):void {
			if (this.map) {
				this.map.removeChild(drawContainer);
			}
			super.map = value;
			if (this.map) {
				this.map.addChild(drawContainer);
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
				this.map.addEventListener(FeatureEvent.FEATURE_OVER, this.onOver);
				this.map.addEventListener(FeatureEvent.FEATURE_OUT, this.onOut);
				//this.map.addEventListener(FeatureEvent.FEATURE_CLICK, this.onClick);
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
				this.map.removeEventListener(FeatureEvent.FEATURE_OVER, this.onOver);
				this.map.removeEventListener(FeatureEvent.FEATURE_OUT, this.onOut);
				//this.map.removeEventListener(FeatureEvent.FEATURE_CLICK, this.onClick);
				this.map.removeEventListener(FeatureEvent.FEATURE_SELECTED, this.onSelected);
				this.map.removeEventListener(FeatureEvent.FEATURE_UNSELECTED, this.onUnselected);
			}
			// Listeners of the super class
			super.unregisterListeners();
		}
		
		/**
		 * If defined, use the onOverFeature callback function for all the
		 * features of the input event.
		 * @param evt the FeatureEvent
		 */
		private function onOver(evt:FeatureEvent):void {
			if (this.onOverFeature == null) {
				return;
			}
			var layersToTest:Array = (this.layers.length>0) ? this.layers : this.map.featureLayers();
			for each (var feature:VectorFeature in evt.features) {
				for each (var layer:FeatureLayer in layersToTest) {
					if (feature.layer == layer) {
						this.onOverFeature(evt);
						break;
					}
				}
			}
		}
		
		/**
		 * If defined, use the onOutFeature callback function for all the
		 * features of the input event.
		 * @param evt the FeatureEvent
		 */
		private function onOut(evt:FeatureEvent):void {
			if (this.onOutFeature == null) {
				return;
			}
			var layersToTest:Array = (this.layers.length>0) ? this.layers : this.map.featureLayers();
			for each (var feature:VectorFeature in evt.features) {
				for each (var layer:FeatureLayer in layersToTest) {
					if (feature.layer == layer) {
						this.onOutFeature(evt);
						break;
					}
				}
			}
		}
		
		/**
		 * If defined, use the onSelectedFeature callback function for all the
		 * features of the input event.
		 * @param evt the FeatureEvent
		 */
		private function onSelected(evt:FeatureEvent):void {
			if (this.onSelectedFeature == null) {
				return;
			}
			var layersToTest:Array = (this.layers.length>0) ? this.layers : this.map.featureLayers();
			for each (var feature:VectorFeature in evt.features) {
				for each (var layer:FeatureLayer in layersToTest) {
					if (feature.layer == layer) {
						this.onSelectedFeature(evt);
						break;
					}
				}
			}
		}
		
		/**
		 * If defined, use the onUnselectedFeature callback function for all the
		 * features of the input event.
		 * @param evt the FeatureEvent
		 */
		private function onUnselected(evt:FeatureEvent):void {
			if (this.onUnselectedFeature == null) {
				return;
			}
			var layersToTest:Array = (this.layers.length>0) ? this.layers : this.map.featureLayers();
			for each (var feature:VectorFeature in evt.features) {
				for each (var layer:FeatureLayer in layersToTest) {
					if (feature.layer == layer) {
						this.onUnselectedFeature(evt);
						break;
					}
				}
			}
		}
		
		/**
		 * Select all the features that contain the location clicked (the
		 * selectionBuffer is used to enlarge the selection area).
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the MouseEvent (useful for the position of MouseUp and for
		 * the status of the CTRL key)
		 */
		private function selectByClick(evt:MouseEvent):void {
			// A point and a selectionBuffer define a selection box...
			this.selectByBox(evt);
		}
		
		/**
		 * Select all the features that intersect the box drawn (the
		 * selectionBuffer is used to enlarge the selection area).
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the MouseEvent (useful for the position of MouseUp and for
		 * the status of the CTRL key)
		 */
		private function selectByBox(evt:MouseEvent):void {
			// Clear the selection drawing
			drawContainer.graphics.clear();
			// Get the selection geometry
			var sbox:Bounds = this.selectionBoxCoordinates(evt, this.selectionBuffer);
        	var sboxGeom:Geometry = (sbox) ? sbox.toGeometry() : null;
        	// Select the features that intersect the geometry
			this.selectByGeometry(sboxGeom, evt.ctrlKey);
		}
		
		/**
		 * Select all the features that intersect the freehand selection area
		 * (the selection buffer is not added).
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the MouseEvent (useful for the position of MouseUp and for
		 * the status of the CTRL key)
		 */
		/*private function selectByFreehandDrawing(evt:MouseEvent):void {
			// Clear the selection drawing
			drawContainer.graphics.clear();
			// Get the selection geometry
        	var geom:Geometry = null; // TODO
        	// Select the features that intersect the geometry
			this.selectByGeometry(geom, evt.ctrlKey);
		}*/
		
		/**
		 * Select all the features that intersect the input geometry.
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param geom the exact geometry to use for the selection (the
		 * selection buffer is not added)
		 */
		private function selectByGeometry(geom:Geometry, additiveMode:Boolean=false):void {
			// Look for all the features that intersect the selection geometry
			var featuresToSelect:Array = new Array();
			if (geom) {
				var layersToTest:Array = (this.layers.length>0) ? this.layers : this.map.featureLayers(); 
				for each (var layer:FeatureLayer in layersToTest) {
					for each (var feature:VectorFeature in layer.features) {
						if (geom.intersects(feature.geometry)) {
							featuresToSelect.push(feature);
						}
					} 
				}
			}
			// Update the selection
			select(featuresToSelect, additiveMode);
			//unselect(featuresToSelect);
		}
		
		/**
		 * Add or replace features to the current selection.
		 * The features are asserted to be in one of the layers to manage.
		 * @param featuresToSelect the array of the features to add / replace by
		 * @param additiveMode if true the input features are added to the
		 * current selection ; if false they replace it
		 */
		private function select(featuresToSelect:Array, additiveMode:Boolean=false):void {
			var feature:VectorFeature;
			// If the current selection is not void, first we restrict the
			// features of the input array to the really new selected features.
			if (this.selectedFeatures.length > 0) {
				var nsf:Array = new Array();
				var i:int, found:Boolean;
				if (additiveMode) {
					// If additive mode is selected, remove all the reselected
					// features of the input array.
					for each (feature in featuresToSelect) {
						for (i=0, found=false; (!found) && (i<this.selectedFeatures.length); i++) {
							if (feature == this.selectedFeatures[i]) {
								found = true;
							}
						}
						if (! found) {
							nsf.push(feature);
						}
					}
				} else {
					// If additive mode is not selected, remove all the current
					// selected features that are not in the input array.
					var sf:Array = new Array();
					for each (feature in this.selectedFeatures) {
						for (i=0, found=false; (!found) && (i<featuresToSelect.length); i++) {
							if (feature == featuresToSelect[i]) {
								found = true;
							}
						}
						if (found) {
							// If this currently selected feature is reselected,
							// keep it in the current selection
							sf.push(feature);
						} else {
							// Otherwise add it to the really new features to select
							nsf.push(feature);
						}
					}
					this._selectedFeatures = sf;
				}
				featuresToSelect = nsf;
			}
			// Add all the really new selected features to the selection
			for each (feature in featuresToSelect) {
				this._selectedFeatures.push(feature);
			}
			// Dispatch an FeatureEvent for all the really new selected features
			/*if (this.map && (featuresToSelect.length>0)) {
				var f:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_SELECTED, null, additiveMode);
				f.features = featuresToSelect;
				this.map.dispatchEvent(f);
			}*/
			// Log the selection modification
			Trace.info("SelectFeaturesHandler: "+featuresToSelect.length+" features (re)selected with additive mode "+((additiveMode)?"ON":"OFF")+" => "+this.selectedFeatures.length+" features selected");
		}
		
		/**
		 * Display the selection box that the user is drawing.
		 * @param evt the MouseEvent
		 */
		private function drawSelectionBox(evt:MouseEvent):void {
			// Compute the selection box (in pixels)
			var rect:Rectangle = this.selectionBoxPixels(evt);
			// Display the selection box
			drawContainer.graphics.clear();
			drawContainer.graphics.lineStyle(this.selectionBorderThin, this.selectionBorderColor);
			drawContainer.graphics.beginFill(this.selectionFillColor, this.selectionFillOpacity);
			drawContainer.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			drawContainer.graphics.endFill();
		}
		
		/**
		 * Display the selection freehand geometry that the user is drawing.
		 * @param evt the MouseEvent
		 */
		/*private function drawSelectionFreehand(evt:MouseEvent):void {
			// Compute the geometry
			var ???:??? = ; // TODO
			// Display the selection box
			drawContainer.graphics.clear();
			drawContainer.graphics.lineStyle(this.selectionBoxBorderThin, this.selectionBoxBorderColor);
			drawContainer.graphics.beginFill(this.selectionBoxFillColor, this.selectionBoxFillOpacity);
			drawContainer.graphics.drawPath(???); // TODO
			drawContainer.graphics.endFill();
		}*/
		
	}
}