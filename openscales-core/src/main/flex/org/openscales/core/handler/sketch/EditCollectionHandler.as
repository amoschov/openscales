package org.openscales.core.handler.sketch
{
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.mouse.FeatureClickHandler;
	import org.openscales.core.layer.VectorLayer;

	public class EditCollectionHandler extends AbstractEditHandler
	{
		public function EditCollectionHandler(map:Map=null, active:Boolean=false, layerToEdit:VectorLayer=null, featureClickHandler:FeatureClickHandler=null)
		{
			super(map, active, layerToEdit, featureClickHandler);
			this.featureClickHandler=featureClickHandler;
		}
		override public function editionModeStart():Boolean{
		 	for each(var vectorFeature:VectorFeature in this._layerToEdit.features){	
					if(/*vectorFeature.isEditable && */vectorFeature.geometry is Collection){
						
						//Clone or not
						
						vectorFeature.createEditionVertices();
						this._layerToEdit.addFeatures(vectorFeature.editionFeaturesArray);
						if(this._featureClickHandler!=null){
						this._featureClickHandler.addControledFeatures(vectorFeature.editionFeaturesArray);
						
						}
					}
				}
					if(this._featureClickHandler!=null)this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_START,this._layerToEdit));				
		 	return true;
		 }
		 override public function editionModeStop():Boolean{
		 	return true;
		 }
		 override public function dragVerticeStart(event:FeatureEvent):void{
			var vectorfeature:PointFeature=event.feature as PointFeature;
			if(vectorfeature!=null){
				vectorfeature.startDrag();
				//drawTemporaryFeature()
				
			}
			
		 }
		override  public function dragVerticeStop(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
		 	if(vectorfeature!=null){
		 		vectorfeature.stopDrag();
		 		var parentGeometry:Collection=vectorfeature.editionFeatureParentGeometry as Collection;
		 		var index:Number=-1;		
				var componentLength:Number=parentGeometry.componentsLength;
		 		if(parentGeometry!=null){
		 			var lonlat:LonLat=this.map.getLonLatFromLayerPx(new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY));			
		 			var newVertice:Point=new Point(lonlat.lon,lonlat.lat);
		 			index=IsRealVertice(vectorfeature);
		 			if(index!=-1) parentGeometry.replaceComponent(index,newVertice);
		 			if(this._featureClickHandler!=null){
		 				//Vertices update
		 				this._layerToEdit.removeFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 				vectorfeature.editionFeatureParent.RefreshEditionVertices();
		 				this._layerToEdit.addFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 				this._featureClickHandler.addControledFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 				this._layerToEdit.redraw();
		 			}
		 		}
		 	}
		 }
		 
		  /**
		 * To know if a dragged point is a under the mouse or is a vertice
		 * if it's a point returns its index else returns -1
		 * */
		 private function IsRealVertice(vectorfeature:PointFeature):Number{
		 	//new point to add		
					var index:Number=0;		
					var componentLength:Number=(vectorfeature.editionFeatureParentGeometry as Collection).componentsLength;
					var geom:Point=vectorfeature.geometry as Point;
					for(index=0;index<componentLength;index++){		
						var editionfeaturegeom:Point=(vectorfeature.editionFeatureParentGeometry as Collection).componentByIndex(index) as Point;
						if((vectorfeature.geometry as Point).x==editionfeaturegeom.x && (vectorfeature.geometry as Point).y==editionfeaturegeom.y) break;
					}
					if(index<componentLength) return index;
					else return -1;
		 }
		 
		 override public function featureClick(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
		 	
		 }
		 //Point deleting
		 override public function featureDoubleClick(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
		 	var index:int=IsRealVertice(vectorfeature);
		 	if(index!=-1){
		 		
		 		vectorfeature.editionFeatureParentGeometry.removeComponent(vectorfeature.geometry);
		 		if(this._featureClickHandler!=null){
		 		//Vertices update
		 			this._layerToEdit.removeFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 			vectorfeature.editionFeatureParent.createEditionVertices();
		 			this._layerToEdit.addFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 			this._featureClickHandler.addControledFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 			this._layerToEdit.redraw();
		 		}
		 	}
		 }
		 protected function drawTemporaryFeature():void{
		 	
		 }
		 
		 protected function endDrawTemporaryFeature():void{
		 	
		 }
	}
}