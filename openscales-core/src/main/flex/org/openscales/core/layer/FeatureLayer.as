package org.openscales.core.layer
{
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.Feature;

	public class FeatureLayer extends Layer
	{
		private var _featuresBbox:Bounds = null;

		private var _selectedFeatures:Array = null;
		
		protected var _drawOnMove:Boolean = true;

		public function FeatureLayer(name:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
			projection:String = null, proxy:String = null)
		{
			super(name, isBaseLayer, visible, projection, proxy);
			this.selectedFeatures = new Array();
			this.featuresBbox = new Bounds();

		}
		
		override public function get inRange():Boolean {
			return true;
		}

		override public function destroy(setNewBaseLayer:Boolean = true):void {
			super.destroy();  
			this.clear();
			this.selectedFeatures = null;
		}

		override public function set map(map:Map):void {
			super.map = map;
			// Ugly trick due to the fact we can't set the size of and empty Sprite
			if (map) {
				this.graphics.drawRect(0,0,map.width,map.height);
				this.width = map.width;
				this.height = map.height;
			}

		}

		override public function onMapResize():void {
			this.drawFeatures();
		}
		
		public function drawFeatures():void {
			this.graphics.clear();
			this.cacheAsBitmap = false;
			for each (var feature:Feature in this.features){
				feature.draw();
			}
			this.cacheAsBitmap = true;
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
			if (_drawOnMove) {
				this.drawFeatures();
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

		public function clear():void {
			while (this.numChildren > 0) {
				this.removeChildAt(this.numChildren-1);
			}
		}

	}
}
