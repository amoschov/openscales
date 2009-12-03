package org.openscales.core.layer
{
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.style.Style;
	import org.openscales.proj4as.ProjProjection;
	
	/**
	 * Layer that display features stored as child element
	 */
	public class FeatureLayer extends Layer
	{
		/**
		 * displayProjection is the projection of feature on the map
		 * for performance reason ,the feature of layer are reprojected 
		 */
		private var _displayProjection:ProjProjection = null;

		private var _featuresBbox:Bounds = null;

		private var _style:Style = null;
		
		private var _geometryType:String = null;
		
		private var _selectedFeatures:Array = null;
		
		private var _isInEditionMode:Boolean=false;
	
		public function FeatureLayer(name:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
									projection:String = null, proxy:String = null)
		{
			super(name, isBaseLayer, visible, projection, proxy);
			this._displayProjection = this.projection.clone();
			this.featuresBbox = new Bounds();
			this.style = new Style();
			//this.geometryType = ;
			this.selectedFeatures = new Array();
		}

		override public function destroy(setNewBaseLayer:Boolean = true):void {
			super.destroy();  
			this.clear();
			this._displayProjection = null;
			this.style = null;
			this.geometryType = null;
			this.selectedFeatures = null;
		}
		
		// Clear layer and children graphics
		override public function clear():void {
			this.graphics.clear();
			var child:Sprite = null;
			for(var i:int=0; i<this.numChildren;i++) {
				child = this.getChildAt(i) as Sprite;
				if(child) {
					child.graphics.clear();
				}
			}
		}
		
		private function updateCurrentProjection(evt:LayerEvent = null):void {
			if ((this.map) && (this.map.baseLayer) && (this._displayProjection.srsCode != this.map.baseLayer.projection.srsCode)) {
				if(this.features.length > 0){	
				  for each (var f:Feature in this.features) {
					f.geometry.transform(this._displayProjection, this.map.baseLayer.projection);
				  }
				  this._displayProjection = this.map.baseLayer.projection.clone();
				  this.redraw();
				}
				else{
					this._displayProjection = this.map.baseLayer.projection.clone();
				}
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

		/**
		 * Add Features to the layer.
		 *
		 * @param features array
		 */
		public function addFeatures(features:Array):void {
			var fevt:FeatureEvent = null;
			
			// Dispatch an event before the features are added
			if(this.map){
				fevt = new FeatureEvent(FeatureEvent.FEATURE_PRE_INSERT, null);
				fevt.features = features;
				this.map.dispatchEvent(fevt);
			}
			
			for (var i:int = 0; i < features.length; i++) {
				this.addFeature(features[i], false);
			}

			// Dispatch an event with all the features added
			if (this.map) {
				fevt = new FeatureEvent(FeatureEvent.FEATURE_INSERT, null);
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
			var fevt:FeatureEvent = null;
			// Check if the feature may be added to this layer
			var vectorfeature:Feature = (feature as Feature);
			if (this.geometryType &&
				(getQualifiedClassName(vectorfeature.geometry) != this.geometryType)) {
				var throwStr:String = "addFeatures : component should be an " + 
					getQualifiedClassName(this.geometryType);
				throw throwStr;
			}
			
			// If needed dispatch a PRE_INSERT event before the feature is added
			if (dispatchFeatureEvent && this.map) {
				fevt = new FeatureEvent(FeatureEvent.FEATURE_PRE_INSERT, feature);
				this.map.dispatchEvent(fevt);
			}
			
			// Add the feature to the layer
			feature.layer = this;
			this.addChild(feature);
			// If needed, dispatch an event with the feature added
			if (dispatchFeatureEvent && this.map) {
				fevt = new FeatureEvent(FeatureEvent.FEATURE_INSERT, feature);
				this.map.dispatchEvent(fevt);
			}
		}
		
		override public function reset():void {
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
		
		override protected function draw():void {
			this.cacheAsBitmap = false;
			for each (var feature:Feature in this.features){
				feature.draw();
			}
			this.cacheAsBitmap = true;
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

	}
}
