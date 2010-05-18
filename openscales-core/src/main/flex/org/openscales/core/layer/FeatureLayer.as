package org.openscales.core.layer
{
	import flash.display.DisplayObject;
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

		private var _selectedFeatures:Vector.<String> = null;

		private var _isInEditionMode:Boolean=false;

		private var _featuresID:Vector.<String> = new Vector.<String>();

		public function FeatureLayer(name:String)
		{
			super(name);
			this._displayProjection = this.projection.clone();
			this.featuresBbox = new Bounds();
			this.style = new Style();
			this.geometryType = null;
			this.selectedFeatures = new Vector.<String>();
		}

		override public function destroy():void {
			super.destroy();  
			this.reset();
			this._displayProjection = null;
			this.style = null;
			this.geometryType = null;
			this.selectedFeatures = null;
			this.featuresBbox = null;
		}

		// Clear layer and children graphics
		override public function clear():void {
			var child:Sprite = null;
			var child2:Sprite = null;
			var numChild:int = this.numChildren;
			var i:int;
			var j:int;
			var numChild2:int;
			for(i=0; i<numChild;++i) {
				child = this.getChildAt(i) as Sprite;
				if(child) {
					child.graphics.clear();
					//Cleanup child subchilds (ex childs of pointfeatures)
					numChild2 =  child.numChildren;
					for(j=0; j<numChild2;++j){
						child2 = child.getChildAt(j) as Sprite;
						if(child2) {
							child2.graphics.clear();
						}
					}
				}
			}
			this.graphics.clear();
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
		public function addFeatures(features:Vector.<Feature>):void {
			var fevt:FeatureEvent = null;

			// Dispatch an event before the features are added
			if(this.map){
				fevt = new FeatureEvent(FeatureEvent.FEATURE_PRE_INSERT, null);
				fevt.features = features;
				this.map.dispatchEvent(fevt);
			}

			var i:int;
			var j:int = features.length
			for (i = 0; i < j; i++) {
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

			if(this._featuresID.indexOf(feature.name)!=-1)
				return;
			this._featuresID.push(feature.name);

			var fevt:FeatureEvent = null;
			// Check if the feature may be added to this layer
			var vectorfeature:Feature = feature;
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
			var i:int = this.numChildren-1;
			var deleted:Boolean = false;
			this._featuresID = new Vector.<String>();
			for(i;i>-1;i--) {
				if(this.getChildAt(i) is Feature) {
					this.removeChildAt(i);
					deleted=true;
				}
			}
			if (deleted && this.map) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_DELETING, null);
				fevt.features = features;
				this.map.dispatchEvent(fevt);
			}
		}

		override protected function draw():void {
			this.cacheAsBitmap = false;
			var j:int = this.numChildren - 1;
			var o:DisplayObject;
			for(j ; j>-1 ; --j) {
				o = this.getChildAt(j);
				if(o is Feature)
					(o as Feature).draw();
			}
			this.cacheAsBitmap = true;
		}

		public function removeFeatures(features:Vector.<Feature>):void {
			var i:int = features.length-1;
			for (i; i > -1; --i)
				this.removeFeature(features[i], false);
			// Dispatch an event with all the features removed
			if (this.map) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_DELETING, null);
				fevt.features = features;
				this.map.dispatchEvent(fevt);
			}
		}

		public function removeFeature(feature:Feature, dispatchFeatureEvent:Boolean=true):void {
			if(feature==null)
				return;
			var i:int = this._featuresID.indexOf(feature.name);
			if(i==-1)
				return;
			this._featuresID.splice(i,1);

			var j:int = this.numChildren;
			for(i = 0;i<j;++i) {
				if (this.getChildAt(i) == feature) {
					this.removeChildAt(i);
					break;
				}
			}
			i = this.selectedFeatures.indexOf(feature);
			if (i != -1){
				this.selectedFeatures.slice(i,1);
			}
			// If needed, dispatch an event with the feature added
			if (dispatchFeatureEvent && this.map) {
				var fevt:FeatureEvent = new FeatureEvent(FeatureEvent.FEATURE_DELETING, feature);
				this.map.dispatchEvent(fevt);
			}
		}

		public function get feauturesID():Vector.<String> {
			var _features:Vector.<String> = new Vector.<String>(this._featuresID.length);
			var i:uint = 0;
			var s:String;
			for each(s in this._featuresID) {
				_features[i]=s;
				++i;
			}
			return _features;
		}

		//Getters and setters
		public function get features():Vector.<Feature> {
			var _features:Vector.<Feature> = new Vector.<Feature>();
			var j:int = this.numChildren - 1;
			var o:DisplayObject;
			for(j ; j>-1 ; --j) {
				o = this.getChildAt(j)
				if(o is Feature) {
					_features.push(o);
				}
			}
			return _features;
		}

		public function get featuresBbox():Bounds {
			return this._featuresBbox;
		}

		public function set featuresBbox(value:Bounds):void {
			this._featuresBbox = value;
		}

		public function get selectedFeatures():Vector.<String> {
			return this._selectedFeatures;
		}

		public function set selectedFeatures(value:Vector.<String>):void {
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

		override public function set projection(value:ProjProjection):void {
			super.projection = value;
			this._displayProjection = this.projection.clone();
		}
	}
}
