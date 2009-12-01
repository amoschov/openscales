package org.openscales.core.handler.feature
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.style.Style;


	/**
	 * This class is a handler used for Collection(Linestring Polygon MultiPolygon etc..) modification
	 * don't use it use EditPathHandler if you want to edit a LineString or a MultiLineString
	 * or EditPolygon 
	 * */
	public class AbstractEditCollectionHandler extends AbstractEditHandler
	{
		/**
		 * index of the feature currently drag in the geometry collection
		 * 
		 * */
		protected var indexOfFeatureCurrentlyDrag:int=-1;
		
		/**
		 * This singleton represents the point under the mouse during the dragging operation
		 * */
		public static var _pointUnderTheMouse:PointFeature=null;
		/**
		 * This tolerance is to discern Virtual vertices from point under the mouse
		 * */
		 private var _detectionTolerance:Number=2;
		
		/**
		 * This class is a handler used for Collection(Linestring Polygon MultiPolygon etc..) modification
	 	* don't use it use EditPathHandler if you want to edit a LineString or a MultiLineString
	 	* or EditPolygon 
	 	* */
		public function AbstractEditCollectionHandler(map:Map=null, active:Boolean=false, layerToEdit:FeatureLayer=null, featureClickHandler:org.openscales.core.handler.feature.FeatureClickHandler=null,drawContainer:Sprite=null,isUsedAlone:Boolean=true)
		{
			super(map, active, layerToEdit, featureClickHandler,drawContainer,isUsedAlone);
			this.featureClickHandler=featureClickHandler;
		}
		
		 /**
		 * @inheritDoc 
		 * */
		  override public function editionModeStop():Boolean{
		  	//if the handler is used alone we remove the listener
		  	if(_isUsedAlone)
		 	this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);		 	
		 	super.editionModeStop();
		 	return true;
		 } 
		 
		 /**
		 * @inheritDoc 
		 * */
		 override public function dragVerticeStart(vectorfeature:PointFeature):void{
			if(vectorfeature!=null){
				//We start to drag the vector feature
				vectorfeature.startDrag();
				//We see if the feature already belongs to the edited vector feature
				indexOfFeatureCurrentlyDrag=IsRealVertice(vectorfeature);
				//else it's a point under the mouse so we find the segement it belongs to
				if(indexOfFeatureCurrentlyDrag==-1) indexOfFeatureCurrentlyDrag=vectorfeature.getSegmentsIntersection(vectorfeature.editionFeatureParentGeometry as Collection);
				if(vectorfeature!=AbstractEditCollectionHandler._pointUnderTheMouse)this._featureCurrentlyDrag=vectorfeature;
				else this._featureCurrentlyDrag=null;
				//we add the new mouseEvent move and remove the previous
				this.map.addEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryFeature);
				 if(_isUsedAlone)this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
			}
			
		 }
		 /**
		 * @inheritDoc 
		 * */
		override  public function dragVerticeStop(vectorfeature:PointFeature):void{
		 	if(vectorfeature!=null){
		 		//We stop the drag 
		 		vectorfeature.stopDrag();
		 		var parentGeometry:Collection=vectorfeature.editionFeatureParentGeometry as Collection;
		 		var index:Number=-1;		
				var componentLength:Number=parentGeometry.componentsLength;
		 		if(parentGeometry!=null){
		 			var lonlat:LonLat=this.map.getLonLatFromLayerPx(new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY));			
		 			var newVertice:Point=new Point(lonlat.lon,lonlat.lat);
		 			//if it's a real vertice of the feature
		 			index=IsRealVertice(vectorfeature);
		 			
		 			if(index!=-1) parentGeometry.replaceComponent(index,newVertice);
		 			else parentGeometry.addComponent(newVertice,indexOfFeatureCurrentlyDrag);
		 			displayVisibleVirtualVertice(vectorfeature.editionFeatureParent);	 				
		 		}
		 	}
		 	//we add the new mouseEvent move and remove the MouseEvent on the draw Temporary feature
		 	this._layerToEdit.removeFeature(AbstractEditCollectionHandler._pointUnderTheMouse);	
		 	if(_isUsedAlone)this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
		 	this.map.removeEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryFeature);
		 	this._featureCurrentlyDrag=null;
		 	//We remove the point under the mouse if it was dragged
		 	if(AbstractEditCollectionHandler._pointUnderTheMouse!=null){
		 		this._layerToEdit.removeFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
		 		this._featureClickHandler.removeControledFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
		 		AbstractEditCollectionHandler._pointUnderTheMouse=null;
		 	}
		 	this._drawContainer.graphics.clear();
		 	this._layerToEdit.redraw();
		 }
		 
		  /**
		 * To know if a dragged point is a under the mouse or is a vertice
		 * if it's a point returns its index else returns -1
		 * @private
		 * */
		 private function IsRealVertice(vectorfeature:PointFeature):Number{
		 	
					var index:Number=0;		
					var componentLength:Number=(vectorfeature.editionFeatureParentGeometry as Collection).componentsLength;
					var geom:Point=vectorfeature.geometry as Point;
					//for each components of the geometry we see if the point belong to it
					for(index=0;index<componentLength;index++){		
						var editionfeaturegeom:Point=(vectorfeature.editionFeatureParentGeometry as Collection).componentByIndex(index) as Point;
						if((vectorfeature.geometry as Point).x==editionfeaturegeom.x && (vectorfeature.geometry as Point).y==editionfeaturegeom.y) break;
					}
					if(index<componentLength) return index;
					else return -1;
		 }
		 /**
		 * @inheritDoc 
		 * */
		 override public function featureClick(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
		 	//We remove listeners and tempoorary point
		 	//This is a bug we redraw the layer with new vertices for the impacted feature
		 	//The click is considered as a bug for the moment	 	
		 	 displayVisibleVirtualVertice(vectorfeature.editionFeatureParent);
		 	this._layerToEdit.removeFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
			if(_isUsedAlone) this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
		 	this.map.removeEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryFeature);
		 	this._featureCurrentlyDrag=null;
		 	//we remove it
		 	if(AbstractEditCollectionHandler._pointUnderTheMouse!=null){
		 		this._layerToEdit.removeFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
		 		AbstractEditCollectionHandler._pointUnderTheMouse=null;
		 	}
		 	this._drawContainer.graphics.clear();
		 	this._layerToEdit.redraw();
		 }
		 /**
		 * @inheritDoc 
		 * */
		 override public function featureDoubleClick(event:FeatureEvent):void{
		 	
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
		 	var index:int=IsRealVertice(vectorfeature);
		 	
		 	if(index!=-1){	 		
		 		vectorfeature.editionFeatureParentGeometry.removeComponent(vectorfeature.editionFeatureParentGeometry.componentByIndex(index));
		 		 displayVisibleVirtualVertice(vectorfeature.editionFeatureParent);
		 	}
		 	//we delete the point under the mouse 
		 	this._layerToEdit.removeFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
		 	if(_isUsedAlone) this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
		 	this.map.removeEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryFeature);
		 	this._featureCurrentlyDrag=null;
		 	if(AbstractEditCollectionHandler._pointUnderTheMouse!=null){
		 		this._layerToEdit.removeFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
		 		AbstractEditCollectionHandler._pointUnderTheMouse=null;
		 	}
		 	this._drawContainer.graphics.clear();
		 	this._layerToEdit.redraw();
		 }
		 
		 /**
		 * Create a virtual vertice under the mouse 
		 * */
		 public function createPointUndertheMouse(evt:FeatureEvent):void{
		 	var vectorfeature:Feature=evt.feature as Feature;
		 	
		 	if(vectorfeature!=null && vectorfeature.layer==_layerToEdit && vectorfeature.geometry is Collection){
		 		vectorfeature.buttonMode=false; 
		 		var px:Pixel=new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY);
				//drawing equals false if the mouse is too close from Virtual vertice
				var drawing:Boolean=true;
					for each(var feature:Feature in vectorfeature.editionFeaturesArray){
						var tmpPx:Pixel=this.map.getLayerPxFromLonLat(new LonLat((feature.geometry as Point).x,(feature.geometry as Point).y));
						if(Math.abs(tmpPx.x-px.x)<10 && Math.abs(tmpPx.y-px.y)<10)
						{
							drawing=false;
							break;
						}
					}
					if(drawing){
						layerToEdit.map.buttonMode=true;
						var lonlat:LonLat=this.map.getLonLatFromLayerPx(px);
						var PointGeomUnderTheMouse:Point=new Point(lonlat.lon,lonlat.lat);	
						if(AbstractEditCollectionHandler._pointUnderTheMouse!=null)
						AbstractEditCollectionHandler._pointUnderTheMouse.geometry=PointGeomUnderTheMouse;
						else {
						AbstractEditCollectionHandler._pointUnderTheMouse=new PointFeature(PointGeomUnderTheMouse,null,Style.getDefaultCircleStyle(),true);
						this._featureClickHandler.addControledFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
						}
						if(AbstractEditCollectionHandler._pointUnderTheMouse.layer==null) layerToEdit.addFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
						AbstractEditCollectionHandler._pointUnderTheMouse.editionFeatureParentGeometry=null;
						//We find the segment the point under the mouse belongs to
							findPointUnderMouseCollection(vectorfeature.geometry,AbstractEditCollectionHandler._pointUnderTheMouse);
						if(AbstractEditCollectionHandler._pointUnderTheMouse.editionFeatureParentGeometry!=null){
								AbstractEditCollectionHandler._pointUnderTheMouse.editionFeatureParent=vectorfeature;
								AbstractEditCollectionHandler._pointUnderTheMouse.visible=true;
						}
						else AbstractEditCollectionHandler._pointUnderTheMouse.visible=false;
						layerToEdit.redraw();	
					}
					else {
						AbstractEditCollectionHandler._pointUnderTheMouse.visible=false;
						layerToEdit.redraw();
						layerToEdit.map.buttonMode=false;				
					}
		 	}
		 }
		 /**
		 * To draw the temporaries feature during drag Operation
		 * */
		 protected function drawTemporaryFeature(event:MouseEvent):void{
		 	
		 }
		 /**
		 * To find at which segments of a collection the point under the mouse belongs to
		 * @private
		 * */
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
		 						if(pointUnderTheMouse.getSegmentsIntersection(geometry as Collection,this._detectionTolerance)!=-1){
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
		 
		 //getters && setters
		 /**
		 * Tolerance used for detecting  point
		 * */
		 public function get detectionTolerance():Number{
		 	return this._detectionTolerance;
		 }
		 public function set detectionTolerance(value:Number):void{	 	
		 	 this._detectionTolerance=value;
		 }
		 
	}
}