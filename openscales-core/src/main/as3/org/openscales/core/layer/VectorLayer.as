package org.openscales.core.layer
{
	import flash.utils.getQualifiedClassName;

	import org.openscales.core.Map;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.proj4as.Proj4as;
	import org.openscales.proj4as.ProjPoint;
	import org.openscales.proj4as.ProjProjection;

	/**
	 * Instances of Vector are used to render vector data from a variety of sources.
	 */
	public class VectorLayer extends FeatureLayer
	{


		private var _style:Style = null;

		private var _geometryType:String = null;

		private var _temporaryProjection:ProjProjection = null;

		public function VectorLayer(name:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
			projection:String = null, proxy:String = null) {

			super(name,isBaseLayer, visible, projection, proxy);
			this.style = new Style();
			this._temporaryProjection = this.projection;

			// For better performances
			this.cacheAsBitmap = true;
		}

		override public function destroy(setNewBaseLayer:Boolean = true):void {
			super.destroy();  
			this.geometryType = null;
		}

		private function checkProjection(evt:LayerEvent = null):void {
			//we don't have to change the projection because 
			//the layers keep the starting resolution 
			
			
		/*	if (this.features.length > 0 && this.map != null && this._temporaryProjection.srsCode != this.map.projection.srsCode) {
				for each (var f:VectorFeature in this.features) {
					f.geometry.transform(this._temporaryProjection, this.map.projection);
				}
				var resProj:ProjPoint = new ProjPoint(this.minResolution, this.maxResolution);
				resProj = Proj4as.transform(this._temporaryProjection, map.projection, resProj);
				this.minResolution = resProj.x;
				this.maxResolution = resProj.y;
				this._temporaryProjection = map.projection;
				this.redraw();
			}*/
		}

		override public function set map(map:Map):void {
			super.map = map;
			this.map.addEventListener(LayerEvent.BASE_LAYER_CHANGED, this.checkProjection);
			checkProjection();
		} 

		/**
		 * Add Feature to the layer.
		 *
		 * @param feature The feature to add
		 */
		override public function addFeature(feature:Feature):void {
			var vectorfeature:VectorFeature = (feature as VectorFeature);
			if (this.geometryType &&
				!(getQualifiedClassName(vectorfeature.geometry) == this.geometryType)) {
				var throwStr:String = "addFeatures : component should be an " + 
					getQualifiedClassName(this.geometryType);
				throw throwStr;
			}

			if (this.map != null && this.map.projection != null && this.projection != null && 
				getQualifiedClassName(this).split("::")[1] != "WFS" && this.projection.srsCode != this.map.projection.srsCode) {
				//vectorfeature.geometry.transform(this.projection, this.map.projection);
			}

			if (!vectorfeature.style) {
				vectorfeature.style = this.style;
			}

			super.addFeature(vectorfeature);
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

		override public function set projection(value:ProjProjection):void {
			super.projection = value;
			var f:VectorFeature;

			if (this.features.length > 0 && this.map != null && this.map.projection != null &&
				this.projection.srsCode != this.map.projection.srsCode) {
				for each (f in this.features) {
					f.geometry.transform(this.projection, this.map.projection);
				}
			}
		}

	}
}

