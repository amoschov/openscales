package org.openscales.core.layer
{
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.style.Style;
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
		
		/**
		 *To know if the vector layer is in edition mode 
		 **/
		private var _isInEditionMode:Boolean=false;
		
		
		public function VectorLayer(name:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
			projection:String = null, proxy:String = null) {

			super(name,isBaseLayer, visible, projection, proxy);
			this.style = new Style();
			this._temporaryProjection = this.projection;
		}

		override public function destroy(setNewBaseLayer:Boolean = true):void {
			super.destroy();  
			this.geometryType = null;
		}

		private function checkProjection(evt:LayerEvent = null):void {
			
		if (this.features.length > 0 && this.map != null && this._temporaryProjection.srsCode != this.map.baseLayer.projection.srsCode) {
				for each (var f:VectorFeature in this.features) {
					f.geometry.transform(this._temporaryProjection, this.map.baseLayer.projection);
				}
				this._temporaryProjection = map.baseLayer.projection;
				this.redraw();
			}
		}

		override public function set map(map:Map):void {
			super.map = map;
			 if(map != null){ 
				this.map.addEventListener(LayerEvent.BASE_LAYER_CHANGED, this.checkProjection);
				checkProjection();
			 } 
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
		}
		/**
		 * To know if the layer is in edition mode
		 * */
		public function get IsInEditionMode():Boolean{
			return this._isInEditionMode;
		}
		/**
		 * @private
		 * */
		public function set isInEditionMode(value:Boolean):void{
			this._isInEditionMode=value;
		}
		
		
	}
}

