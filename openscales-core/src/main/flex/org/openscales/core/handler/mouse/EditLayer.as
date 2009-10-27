package org.openscales.core.handler.mouse
{
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.style.Style;

	public class EditLayer extends Handler
	{
		
		
		/**
		 * The layer concerned by the Modification
		 * */
		private var _layerToEdit:VectorLayer=null;
		/**
		 * point under the mouse during the edit operation
		 * */
		private var _pointUnderTheMouse:PointFeature=null;
		
		/**
		 * This tolerance is to discern Virtual vertices from point under the mouse
		 * */
		 private var _tolerance:Number=5;
		/**
		 * This handler is used to edit feature on a VectorLayer
		 * @param map Map Object
		 * @param layer : The layer concerned by the Modification
		 * @param active: This boolean activates the vector layer
		 * */
		public function EditLayer(map:Map=null, layer:VectorLayer=null,active:Boolean=false)
		{
			super(map, active);
			this._layerToEdit=layer;
			if(this.active && this._layerToEdit!=null) {
				this._layerToEdit.inEditionMode=true;
				EditionModeStart();
			}
		}
		//Edition Mode Start
		private function EditionModeStart():Boolean{
			if(_layerToEdit !=null)
			{
				//We create an editable clone for all existant vector feature
				for each(var vectorFeature:VectorFeature in this._layerToEdit.features){	
					if(vectorFeature.isEditable && !(vectorFeature is PointFeature)){
						var clonefeature:VectorFeature=vectorFeature.getEditableClone();
						//old vectorfeature is hidden
						vectorFeature.visible=false;
						this._layerToEdit.addFeature(clonefeature);
						clonefeature.createEditionVertices();
						this._layerToEdit.addFeatures(clonefeature.editionFeaturesArray);
						this._layerToEdit.redraw();			
					}			
					}
				this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);	
				this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_START,this._layerToEdit));				
				return true;
			}
				return false;			
		}
		//End of edition mode
		private function EditionModeStop():Boolean{
			if(_layerToEdit !=null)
			{
				this..map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_END,this._layerToEdit));
				this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
				for each(var vectorFeature:VectorFeature in this._layerToEdit.features){	
					if(vectorFeature.isEditionFeature)
					{
						this._layerToEdit.removeFeature(vectorFeature);
					}
				}
				this._layerToEdit.redraw();
				return true;
			}
				return false;			
		}
		
		override protected function registerListeners():void{
			this.map.addEventListener(FeatureEvent.EDITION_POINT_FEATURE_DRAG_START,editionPointDragStart);
			this.map.addEventListener(FeatureEvent.EDITION_POINT_FEATURE_DRAG_STOP,editionPointDragStop);
			EditionModeStart();
		}
		
		override protected function unregisterListeners():void {
			this.map.removeEventListener(FeatureEvent.EDITION_POINT_FEATURE_DRAG_START,editionPointDragStart);
			this.map.removeEventListener(FeatureEvent.EDITION_POINT_FEATURE_DRAG_STOP,editionPointDragStop);
			EditionModeStop();
		}
		 /**
		 * This function create the point under the mouse
		 * */	
		 private function createPointUndertheMouse(evt:FeatureEvent):void{
		 		var vectorfeature:VectorFeature=evt.feature as VectorFeature;
		 		//Vector feature is not null and belong to the target layer
		 		if(vectorfeature != null && Util.indexOf(this._layerToEdit.features,vectorfeature)!=-1 && vectorfeature.isEditable){
					this.map.buttonMode=true;
					var px:Pixel=new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY);
					//drawing equals false if the mouse is too close from Virtual vertice
					var drawing:Boolean=true;
					for each(var feature:VectorFeature in vectorfeature.editionFeaturesArray){
						var tmpPx:Pixel=this.map.getLayerPxFromLonLat(new LonLat((feature.geometry as Point).x,(feature.geometry as Point).y));
						if(Math.abs(tmpPx.x-px.x)<this._tolerance && Math.abs(tmpPx.y-px.y)<this._tolerance)
						{
							drawing=false;
							break;
						}
					}
					if(drawing){
						var lonlat:LonLat=this.map.getLonLatFromLayerPx(px);	
						var PointGeomUnderTheMouse:Point=new Point(lonlat.lon,lonlat.lat);
						//we delete the point under the mouse  from layer and from tmpVertices Array
						if(this._pointUnderTheMouse!=null)
						{
							this._layerToEdit.removeFeature(this._pointUnderTheMouse);
						}
					
						//There is always a component because the mouse is over the component
						//consequently we use the first
						//we find the collection which directly have a point as component
						var testCollection:Geometry=vectorfeature.geometry;
						var parentTmpPoint:Geometry;
						while(testCollection is Collection)
						{
							parentTmpPoint=testCollection;
							testCollection=(testCollection as Collection).componentByIndex(0);
						}
					
						var style:Style = Style.getDefaultCircleStyle();		
						//isTmpFeatureUnderTheMouse attributes use to specify type of temporary feature
						this._pointUnderTheMouse=new PointFeature(PointGeomUnderTheMouse as Point,null,Style.getDefaultCircleStyle(),true,parentTmpPoint as Collection);	
						this._pointUnderTheMouse.editionFeatureParent=vectorfeature;
						this._layerToEdit.addFeature(this._pointUnderTheMouse);	
					}			
			}
		 }
		 
		 private function editionPointDragStart(evt:FeatureEvent):void{
		 	var vectorfeature:VectorFeature=evt.feature as VectorFeature;
		 		//Vector feature is not null and belong to the target layer
		 		if(vectorfeature != null && Util.indexOf(this._layerToEdit.features,vectorfeature)!=-1){
		 			
		 		}
		 }
		 private function editionPointDragStop(evt:FeatureEvent):void{
		 	var vectorfeature:PointFeature=evt.feature as PointFeature;
		 		//Vector feature is not null and belong to the target layer
		 		if(vectorfeature != null && Util.indexOf(this._layerToEdit.features,vectorfeature)!=-1){
		 			//new point to add
					var lonlat:LonLat=this.map.getLonLatFromLayerPx(new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY));			
					var newVertice:Point=new Point(lonlat.lon,lonlat.lat);
					var index:Number=0;		
					var componentLength:Number=(vectorfeature.editionFeatureParentGeometry as Collection).componentsLength;
					var geom:Point=vectorfeature.geometry as Point;
					for(index=0;index<componentLength;index++){		
						var editionfeaturegeom:Point=(vectorfeature.editionFeatureParentGeometry as Collection).componentByIndex(index) as Point;
						if((vectorfeature.geometry as Point).x==editionfeaturegeom.x && (vectorfeature.geometry as Point).y==editionfeaturegeom.y) break;
					}
					var IsPointUnderTheMouse:Boolean=!(vectorfeature.editionFeatureParentGeometry as Collection).replaceComponent(index,newVertice);
					if(IsPointUnderTheMouse){
						 index=this._pointUnderTheMouse.getSegmentsIntersection(vectorfeature.editionFeatureParentGeometry as Collection);
						(vectorfeature.editionFeatureParentGeometry as Collection).addComponent(newVertice,index);	
					}	
					//we get the temporary edition parent which is parent of the edition feature
					var editionfeatureparent:VectorFeature=vectorfeature.editionFeatureParent;
					editionfeatureparent.RefreshEditionVertices();
					this._layerToEdit.removeFeature(this._pointUnderTheMouse);
					this._pointUnderTheMouse=null;
					this._layerToEdit.addFeatures(editionfeatureparent.editionFeaturesArray);
					this._layerToEdit.redraw();		
		 		}
		 }
		 /**
		 * To record Modification
		 * */	 
		 public function RecordModification():void{
		 	/*for each(var feature:VectorFeature in this._layerToEdit){
		 		if(!feature.isEditionFeature){
		 			//We will use this vector next time to backup for example
		 			if(feature.editionFeaturesArray!=null)
		 			{
		 				this._layerToEdit.removeFeature(feature);
		 				feature=feature.editionFeaturesArray[0] as VectorFeature;
		 				feature.isEditionFeature=false;
		 			} 
		 		}
		 	
		 	}*/
		 }
		//getters && setters
		/**
		 * The layer concerned by the Modification
		 * */
		 public function get layerToEdit():VectorLayer{
		 	return this._layerToEdit;
		 }
		 /**
		 * @private
		 * */
		 public function set layerToEdit(value:VectorLayer):void{
		 	 this._layerToEdit=value;
		 }
		 
	}
}