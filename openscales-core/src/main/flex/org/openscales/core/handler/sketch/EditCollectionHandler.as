package org.openscales.core.handler.sketch
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.mouse.FeatureClickHandler;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.style.Style;

	public class EditCollectionHandler extends AbstractEditHandler
	{
		/**
		 * index of the feature currently drag in the geometry collection
		 * 
		 * */
		protected var indexOfFeatureCurrentlyDrag:int=-1;
		
		
		//This singleton represents the point under the mouse during the dragging operation
		public static var _pointUnderTheMouse:PointFeature=null;
		/**
		 * This tolerance is to discern Virtual vertices from point under the mouse
		 * */
		 private var _tolerance:Number=8;
		
		public function EditCollectionHandler(map:Map=null, active:Boolean=false, layerToEdit:VectorLayer=null, featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null)
		{
			super(map, active, layerToEdit, featureClickHandler,drawContainer);
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
					if(this._featureClickHandler!=null){
						this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_START,this._layerToEdit));	
						this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
					}			
		 	return true;
		 }
		  override public function editionModeStop():Boolean{
		  	if(this._featureClickHandler!=null)
		 	this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);	
		 	return true;
		 } 
		 
		 /**
		 * drag vertice start function
		 * 
		 * */
		 override public function dragVerticeStart(event:FeatureEvent):void{
			var vectorfeature:PointFeature=event.feature as PointFeature;
			if(vectorfeature!=null){
				vectorfeature.startDrag();
				indexOfFeatureCurrentlyDrag=IsRealVertice(vectorfeature);
				if(indexOfFeatureCurrentlyDrag==-1) indexOfFeatureCurrentlyDrag=vectorfeature.getSegmentsIntersection(vectorfeature.editionFeatureParentGeometry as Collection);
				if(vectorfeature!=EditCollectionHandler._pointUnderTheMouse)this._featureCurrentlyDrag=vectorfeature;
				else this._featureCurrentlyDrag=null;
				//we add the new mouseEvent move and remove the previous
				this.map.addEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryFeature);
				this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
			}
			
		 }
		override  public function dragVerticeStop(event:FeatureEvent):VectorFeature{
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
		 			else parentGeometry.addComponent(newVertice,indexOfFeatureCurrentlyDrag);
		 			if(this._featureClickHandler!=null){
		 				//Vertices update
		 				this._layerToEdit.removeFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 				vectorfeature.editionFeatureParent.RefreshEditionVertices();
		 				this._layerToEdit.addFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 				this._featureClickHandler.addControledFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 				
		 				//we add the new mouseEvent move and remove the previous
		 				this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
		 				this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
		 				EditCollectionHandler._pointUnderTheMouse=null;
		 				this._featureCurrentlyDrag=null;
		 				this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
						EditCollectionHandler._pointUnderTheMouse=null;
		 				this._layerToEdit.redraw();
		 			}
		 		}
		 	}
		 	this.map.removeEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryFeature);
		 	this._featureCurrentlyDrag=null;
		 	this._drawContainer.graphics.clear();
		 	return null;
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
		 	this.map.removeEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryFeature);
		 	this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
			EditCollectionHandler._pointUnderTheMouse=null;
		 	this._drawContainer.graphics.clear();
		 	
		 }
		 //Point deleting
		 override public function featureDoubleClick(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
		 	var index:int=IsRealVertice(vectorfeature);
		 	if(index!=-1){
		 		
		 		vectorfeature.editionFeatureParentGeometry.removeComponent(vectorfeature.editionFeatureParentGeometry.componentByIndex(index));
		 		if(this._featureClickHandler!=null){
		 		//Vertices update
		 			this._layerToEdit.removeFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 			vectorfeature.editionFeatureParent.createEditionVertices();
		 			this._layerToEdit.addFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 			this._featureClickHandler.addControledFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 			this._layerToEdit.redraw();
		 		}
		 	}
		 	this.map.removeEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryFeature);
		 	this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
			EditCollectionHandler._pointUnderTheMouse=null;
		 	this._drawContainer.graphics.clear();
		 }
		 public function createPointUndertheMouse(evt:FeatureEvent):void{
		 	var vectorfeature:VectorFeature=evt.feature as VectorFeature;
		 	
		 	if(vectorfeature.layer==_layerToEdit && vectorfeature!=null && vectorfeature.geometry is Collection){
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
					//we delete the previous point
					if(EditCollectionHandler._pointUnderTheMouse!=null){
						this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
						if(this._featureClickHandler!=null) this._featureClickHandler.removeControledFeature(EditCollectionHandler._pointUnderTheMouse);
						this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
						EditCollectionHandler._pointUnderTheMouse=null;
						this._layerToEdit.redraw();
					}
					if(drawing){
						var lonlat:LonLat=this.map.getLonLatFromLayerPx(px);	
						var PointGeomUnderTheMouse:Point=new Point(lonlat.lon,lonlat.lat);
						
						//There is always a component because the mouse is over the component
						//consequently we use the first
						//we find the collection which directly have a point as component
						/* var testCollection:Geometry=vectorfeature.geometry;
						var parentTmpPoint:Geometry;
						var parentArray:Array=new Array();
						while(testCollection is Collection)
						{
							parentTmpPoint=testCollection;
							parentArray=testCollection;
							testCollection=(testCollection as Collection).componentByIndex(0);
						} */		
							//isTmpFeatureUnderTheMouse attributes use to specify type of temporary feature
							EditCollectionHandler._pointUnderTheMouse=new PointFeature(PointGeomUnderTheMouse as Point,null,Style.getDefaultCircleStyle(),true/*,parentTmpPoint as Collection*/);	
							EditCollectionHandler._pointUnderTheMouse.layer=this._layerToEdit;
							findPointUnderMouseCollection(vectorfeature.geometry,EditCollectionHandler._pointUnderTheMouse);
							
						if(EditCollectionHandler._pointUnderTheMouse.editionFeatureParentGeometry!=null){
							EditCollectionHandler._pointUnderTheMouse.editionFeatureParent=vectorfeature;
							this._layerToEdit.addFeature(EditCollectionHandler._pointUnderTheMouse);	
							if(this._featureClickHandler!=null)this._featureClickHandler.addControledFeature(EditCollectionHandler._pointUnderTheMouse);
						}
						else EditCollectionHandler._pointUnderTheMouse=null;
					}
		 	}
		 }
		 
		 protected function drawTemporaryFeature(event:MouseEvent):void{
		 	
		 }
		 
		 private function findPointUnderMouseCollection(vectorfeatureGeometry:Geometry,pointUnderTheMouse:PointFeature):void{
		 			for (var i:int=0;i<(vectorfeatureGeometry as Collection).componentsLength;i++){
		 				var geometry:Geometry=(vectorfeatureGeometry as Collection).componentByIndex(i);
		 				if(geometry is Collection){
		 					//we test if we have a Linestring or a linearring which extends LinesTRING because 
		 					//there are the basics components of MultiLineString or MultiPolygon
		 					if(!(geometry is LineString)){
		 						findPointUnderMouseCollection(geometry,pointUnderTheMouse);
		 					}
		 					else{
		 						if(pointUnderTheMouse.getSegmentsIntersection(geometry as Collection)!=-1){
		 							pointUnderTheMouse.editionFeatureParentGeometry=geometry as Collection;
		 							break;
		 						}
		 					}
		 				}
		 				else{
		 					 pointUnderTheMouse.editionFeatureParentGeometry=vectorfeatureGeometry as Collection;
		 					 break;
		 				}
		 			} 
		 	
		 	
		 }
		 
	}
}