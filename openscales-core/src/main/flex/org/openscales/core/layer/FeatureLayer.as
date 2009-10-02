package org.openscales.core.layer
{
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
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
		
		override public function calculateInRange():Boolean {
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
			this.graphics.drawRect(0,0,this.map.width,this.map.height);
			this.width = this.map.width;
			this.height = this.map.height;

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
			if(_drawOnMove) {
				this.drawFeatures();
			}
		}

		/**
		 * Add Features to the layer.
		 *
		 * @param features array
		 */
		public function addFeatures(features:Array):void {
			for (var i:int = 0; i < features.length; i++) {
				this.addFeature(features[i]);
			}
		}

		/**
		 * Add Feature to the layer.
		 *
		 * @param feature The feature to add
		 */
		public function addFeature(feature:Feature):void {

			feature.layer = this;
			
			/* if(map)
				this.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_PRE_INSERT, feature));
			else
				Trace.warning("Warning : no FEATURE_PRE_INSERT dispatched because map event dispatcher is not defined"); */
			
			this.addChild(feature);

			/* if(map)
				this.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_INSERT, feature));
			else
				Trace.warning("Warning : no FEATURE_INSERT dispatched because map event dispatcher is not defined"); */
		}

		public function removeFeatures(features:Array):void {
			for (var i:int = 0; i < features.length; i++) {
				this.removeFeature(features[i]);
			}
		}

		public function removeFeature(feature:Feature):void {

			for(var j:int = 0;j<this.numChildren;j++)
			{
				if(this.getChildAt(j) == feature)
					this.removeChildAt(j);
			}
			if (Util.indexOf(this.selectedFeatures, feature) != -1){
				Util.removeItem(this.selectedFeatures, feature);
			}
		}

		//Getters and setters
		public function get features():Array {
			var featureArray:Array = new Array();

			for(var i:int = 0;i<this.numChildren;i++)
			{
				if(this.getChildAt(i) is Feature)
				{
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

