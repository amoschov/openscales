package org.openscales.core.layer
{
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.style.Style;
	import org.openscales.proj4as.ProjProjection;
	
	public class FeatureLayer extends Layer
	{
		private var _currentProjection:ProjProjection = null;

		private var _featuresBbox:Bounds = null;

		private var _style:Style = null;
		
		private var _geometryType:String = null;
		
		private var _selectedFeatures:Array = null;
		
		private var _isInEditionMode:Boolean=false;
		
		protected var _drawOnMove:Boolean = true;

		public function FeatureLayer(name:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
									projection:String = null, proxy:String = null)
		{
			super(name, isBaseLayer, visible, projection, proxy);
			this._currentProjection = this.projection.clone();
			this.featuresBbox = new Bounds();
			this.style = new Style();
			//this.geometryType = ;
			this.selectedFeatures = new Array();
		}

		override public function destroy(setNewBaseLayer:Boolean = true):void {
			super.destroy();  
			this.clear();
			this._currentProjection = null;
			this.style = null;
			this.geometryType = null;
			this.selectedFeatures = null;
		}
		
		// Clear layer and children graphics
		public function clear():void {
			this.graphics.clear();
			var child:Sprite = null;
			for(var i:int=0; i<this.numChildren;i++) {
				child = this.getChildAt(i) as Sprite;
				if(child) {
					child.graphics.clear();
				}
			}
		}
		
		// FixMe: why is it necessary to do that ?
		// It should be managed at the Layer.as level for all the types of sublayer
		override public function get inRange():Boolean {
			return true;
		}
		
		private function updateCurrentProjection(evt:LayerEvent = null):void {
			if ((this.features.length > 0) && (this.map)
				&& (this._currentProjection.srsCode != this.map.baseLayer.projection.srsCode)) {
				for each (var f:Feature in this.features) {
					f.geometry.transform(this._currentProjection, this.map.baseLayer.projection);
				}
				this._currentProjection = this.map.baseLayer.projection.clone();
				this.redraw();
			}
		}

		override public function set map(map:Map):void {
			if (this.map != null) {
				this.map.removeEventListener(LayerEvent.BASE_LAYER_CHANGED, this.updateCurrentProjection);
			}
			super.map = map;
			if (this.map != null) {
				updateCurrentProjection();
				this.map.addEventListener(LayerEvent.BASE_LAYER_CHANGED, this.updateCurrentProjection);
				// Ugly trick due to the fact we can't set the size of and empty Sprite
				this.graphics.drawRect(0,0,map.width,map.height);
				this.width = map.width;
				this.height = map.height;
			}
		}

		override public function onMapResize():void {
			this.redraw();
		}

		/**
		 *  Reset the vector so that it once again is lined up with
		 *   the map. Notify the renderer of the change of extent, and in the
		 *   case of a change of zoom level (resolution), have the
		 *   renderer redraw features.
		 *
		 * @param bounds
		 * @param zoomChanged
		 * @param dragging
		 */
		override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false,resizing:Boolean=false):void {
			super.moveTo(bounds, zoomChanged, dragging,resizing);
			if (! this.visible) {
				this.clear();
				return;
			}
			
			if (_drawOnMove) {
				this.redraw();
			}
		}

		/**
		 * Add Features to the layer.
		 *
		 * @param features array
		 */
		public function addFeatures(features:Array):void {
			this.graphics.clear();
			this.cacheAsBitmap = false;
			for (var i:int = 0; i < features.length; i++) {
				this.addFeature(features[i], false);
			}
			this.cacheAsBitmap = true;
			// Dispatch an event with all the features added
			if (this.map) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_INSERT, null);
				fevt.features = features;
				this.map.dispatchEvent(fevt);
			}
		}

		/**
		 * Add Feature to the layer.
		 *
		 * @param feature The feature to add
		 */
		public function addFeature(feature:Feature, dispatchFeatureEvent:Boolean=true):void {
			// Check if the feature may be added to this layer
			var vectorfeature:Feature = (feature as Feature);
			if (this.geometryType &&
				(getQualifiedClassName(vectorfeature.geometry) != this.geometryType)) {
				var throwStr:String = "addFeatures : component should be an " + 
					getQualifiedClassName(this.geometryType);
				throw throwStr;
			}
			// Add the feature to the layer
			feature.layer = this;
			this.addChild(feature);
			if (this.map) {
				feature.draw();
			}
			// If needed, dispatch an event with the feature added
			if (dispatchFeatureEvent && this.map) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_INSERT, feature);
				this.map.dispatchEvent(fevt);
			}
		}
		
		public function removeAllFeatures():void {
			var features:Array = this.features;
			for (var i:int = 0; i < features.length; i++) {
				this.removeFeature(features[i], false);
			}
			// Dispatch an event with all the features removed
			if (this.map) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_DELETING, null);
				fevt.features = features;
				this.map.dispatchEvent(fevt);
			}
		}
		
		public function removeFeatures(features:Array):void {
			for (var i:int = 0; i < features.length; i++) {
				this.removeFeature(features[i], false);
			}
			// Dispatch an event with all the features removed
			if (this.map) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_DELETING, null);
				fevt.features = features;
				this.map.dispatchEvent(fevt);
			}
		}

		public function removeFeature(feature:Feature, dispatchFeatureEvent:Boolean=true):void {
			for(var j:int = 0;j<this.numChildren;j++) {
				if (this.getChildAt(j) == feature)
					this.removeChildAt(j);
			}
			if (Util.indexOf(this.selectedFeatures, feature) != -1){
				Util.removeItem(this.selectedFeatures, feature);
			}
			// If needed, dispatch an event with the feature added
			if (dispatchFeatureEvent && this.map) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_DELETING, feature);
				this.map.dispatchEvent(fevt);
			}
		}

		//Getters and setters
		public function get features():Array {
			var featureArray:Array = new Array();
			for(var i:int = 0;i<this.numChildren;i++) {
				if(this.getChildAt(i) is Feature) {
					featureArray.push(this.getChildAt(i));
				}
			}
			return featureArray;
		}

		public function get featuresBbox():Bounds {
			return this._featuresBbox;
		}

		public function set featuresBbox(value:Bounds):void {
			this._featuresBbox = value;
		}

		public function get selectedFeatures():Array {
			return this._selectedFeatures;
		}

		public function set selectedFeatures(value:Array):void {
			this._selectedFeatures = value;
		}
		
		public function get style():Style {
			return this._style;
		}
		
		public function set style(value:Style):void {
			this._style = value;
		}
		
		public function get geometryType():String {
			return this._geometryType;
		}
		
		public function set geometryType(value:String):void {
			this._geometryType = value;
		}
		
		public function get inEditionMode():Boolean {
			return this._isInEditionMode;
		}
		
		public function set inEditionMode(value:Boolean):void {
			this._isInEditionMode = value;
		}
		
		override public function redraw():Boolean {
			this.cacheAsBitmap = false;
			this.clear();
			if (this.visible) {
				for each (var feature:Feature in this.features){
					feature.draw();
				}
			}
			this.cacheAsBitmap = true;
			return true;
		}

	}
}
