package org.openscales.core.handler.feature.draw
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.feature.FeatureClickHandler;
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
		 * This tolerance is used to manage the point on the segments
		 * */
		 private var _detectionTolerance:Number=2;
		 /**
		 * This tolerance is used to discern Virtual vertices from point under the mouse
		 * */
		 private var _ToleranceVirtualReal:Number=10;
		/**
		 * We use a timer to manage the mouse out of a feature
		 */
		private var _timer:Timer = new Timer(1000,1);
		/**
		 * To know if we displayed the virtual vertices of collection feature or not
		 **/
		 private var _displayedVirtualVertices:Boolean=true;
		/**
		 * This class is a handler used for Collection(Linestring Polygon MultiPolygon etc..) modification
	 	* don't use it use EditPathHandler if you want to edit a LineString or a MultiLineString
	 	* or EditPolygon 
	 	* */
		public function AbstractEditCollectionHandler(map:Map=null, active:Boolean=false, layerToEdit:FeatureLayer=null, featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null,isUsedAlone:Boolean=true)
		{
			super(map, active, layerToEdit, featureClickHandler,drawContainer,isUsedAlone);
			this.featureClickHandler=featureClickHandler;
			this._timer.addEventListener(TimerEvent.TIMER, deletepointUnderTheMouse);
		}
		/**
		 * This function is used for Polygons edition mode starting
		 * 
		 * */
		override public function editionModeStart():Boolean{
		 	for each(var vectorFeature:Feature in this._layerToEdit.features){	
					if(vectorFeature.isEditable && vectorFeature.geometry is Collection){			
						//Clone or not
						if(displayedVirtualVertices)displayVisibleVirtualVertice(vectorFeature);
					}
				}
					if(_isUsedAlone){
						this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_START,this._layerToEdit));	
						this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
					}			
		 	return true;
		 }
		
		 /**
		 * @inheritDoc 
		 * */
		  override public function editionModeStop():Boolean{
		  	//if the handler is used alone we remove the listener
		  	if(_isUsedAlone)
		 	this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
		 	this._timer.removeEventListener(TimerEvent.TIMER, deletepointUnderTheMouse);		 	
		 	super.editionModeStop();
		 	return true;
		 } 
		 
		 /**
		 * @inheritDoc 
		 * */
		 override public function dragVerticeStart(vectorfeature:PointFeature):void{
			if(vectorfeature!=null){
					var parentFeature:Feature=findVirtualVerticeParent(vectorfeature);
		 			if(parentFeature && parentFeature.geometry is Collection){
					//We start to drag the vector feature
					vectorfeature.startDrag();
					//We see if the feature already belongs to the edited vector feature
					indexOfFeatureCurrentlyDrag=findIndexOfFeatureCurrentlyDrag(vectorfeature);
					if(vectorfeature!=AbstractEditCollectionHandler._pointUnderTheMouse)this._featureCurrentlyDrag=vectorfeature;
					else this._featureCurrentlyDrag=null;
					//we add the new mouseEvent move and remove the previous
					_timer.stop();
					this.map.addEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryFeature);
				 	if(_isUsedAlone)this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
		 			}
			}
			
		 }
		 /**
		 * @inheritDoc 
		 * */
		override  public function dragVerticeStop(vectorfeature:PointFeature):void{
		 	if(vectorfeature!=null){
		 		//We stop the drag 
		 		vectorfeature.stopDrag();
		 		//var parentGeometry:Collection=vectorfeature.editionFeatureParentGeometry as Collection;
		 		var parentFeature:Feature=findVirtualVerticeParent(vectorfeature);
		 		if(parentFeature && parentFeature.geometry is Collection){
		 			var parentGeometry:Collection=editionFeatureParentGeometry(vectorfeature,parentFeature.geometry as Collection);
					var componentLength:Number=parentGeometry.componentsLength;
					this._layerToEdit.removeFeature(vectorfeature);
					this._featureClickHandler.removeControledFeature(vectorfeature);
		 			if(parentGeometry!=null){
		 				var lonlat:LonLat=this.map.getLonLatFromLayerPx(new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY));			
		 				var newVertice:Point=new Point(lonlat.lon,lonlat.lat);
		 				//if it's a real vertice of the feature
		 				if(vectorfeature!=AbstractEditCollectionHandler._pointUnderTheMouse) parentGeometry.replaceComponent(indexOfFeatureCurrentlyDrag,newVertice);
		 				else parentGeometry.addComponent(newVertice,indexOfFeatureCurrentlyDrag);
		 				if(displayedVirtualVertices)displayVisibleVirtualVertice(findVirtualVerticeParent(vectorfeature as PointFeature));	
		 			} 				
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
		 	vectorfeature=null;
		   _timer.stop();
		   //vectorfeature.editionFeatureParent.draw();
		 	this._layerToEdit.redraw();
		 }
		 
		 /**
		 * @inheritDoc 
		 * */
		 override public function featureClick(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
		 	//We remove listeners and tempoorary point
		 	//This is a bug we redraw the layer with new vertices for the impacted feature
		 	//The click is considered as a bug for the moment	 	
		 	 if(displayedVirtualVertices)displayVisibleVirtualVertice(findVirtualVerticeParent(vectorfeature as PointFeature));
		 	this._layerToEdit.removeFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
		 	this._layerToEdit.removeFeature(vectorfeature);
		 	this._featureClickHandler.removeControledFeature(vectorfeature);
		 	vectorfeature=null;
			if(_isUsedAlone) this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
		 	this.map.removeEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryFeature);
		 	this._featureCurrentlyDrag=null;
		 	//we remove it
		 	if(AbstractEditCollectionHandler._pointUnderTheMouse!=null){
		 		this._layerToEdit.removeFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
		 		AbstractEditCollectionHandler._pointUnderTheMouse=null;
		 	}
		 	this._drawContainer.graphics.clear();
		 	_timer.stop();
		 	this._layerToEdit.redraw();
		 }
		 /**
		 * @inheritDoc 
		 * */
		 override public function featureDoubleClick(event:FeatureEvent):void{
		 	
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
		 	
		 	var parentFeature:Feature=findVirtualVerticeParent(vectorfeature);
		 	if(parentFeature && parentFeature.geometry is Collection){
		 	var parentGeometry:Collection=editionFeatureParentGeometry(vectorfeature,parentFeature.geometry as Collection);
		 	var index:int=IsRealVertice(vectorfeature,parentGeometry);
		 	
		 	if(index!=-1){	 		
		 		 parentGeometry.removeComponent(parentGeometry.componentByIndex(index));
		 		 if(displayedVirtualVertices)displayVisibleVirtualVertice(findVirtualVerticeParent(vectorfeature as PointFeature));
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
		 	_timer.stop();
		 	this._layerToEdit.redraw();
		 	}
		 }
		 
		 /**
		 * This function is used to manage the mouse when the mouse is out of the feature
		 * */
		 public function onFeatureOut(evt:FeatureEvent):void{	 	
		 	_timer.start();
		 }
		 private function deletepointUnderTheMouse(evt:TimerEvent):void{
		 	//we hide the point under the mouse
		 
		   if(AbstractEditCollectionHandler._pointUnderTheMouse!=null)	AbstractEditCollectionHandler._pointUnderTheMouse.visible=false;
		 	_timer.stop();
		 }
		 /**
		 * Create a virtual vertice under the mouse 
		 * */
		 public function createPointUndertheMouse(evt:FeatureEvent):void{
		 	var vectorfeature:Feature=evt.feature as Feature;		 	
		 	if(vectorfeature!=null && vectorfeature.layer==_layerToEdit && vectorfeature.geometry is Collection){
		 		_timer.stop();
		 		vectorfeature.buttonMode=false; 
		 		var px:Pixel=new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY);
				//drawing equals false if the mouse is too close from Virtual vertice
				var drawing:Boolean=true;
					for(var i:int=0;i<_editionFeatureArray.length;i++){
						var feature:Feature=_editionFeatureArray[i][0] as Feature;
						if(feature!=null && feature!=AbstractEditCollectionHandler._pointUnderTheMouse &&  vectorfeature==_editionFeatureArray[i][1]){
						var tmpPx:Pixel=this.map.getLayerPxFromLonLat(new LonLat((feature.geometry as Point).x,(feature.geometry as Point).y));
						if(Math.abs(tmpPx.x-px.x)<this._ToleranceVirtualReal && Math.abs(tmpPx.y-px.y)<this._ToleranceVirtualReal)
						{
							drawing=false;
							break;
						}
					}
				}
					if(drawing){
						layerToEdit.map.buttonMode=true;
						var lonlat:LonLat=this.map.getLonLatFromLayerPx(px);
						var PointGeomUnderTheMouse:Point=new Point(lonlat.lon,lonlat.lat);	
						if(AbstractEditCollectionHandler._pointUnderTheMouse!=null){
						AbstractEditCollectionHandler._pointUnderTheMouse.geometry=PointGeomUnderTheMouse;
						}
						else {
						AbstractEditCollectionHandler._pointUnderTheMouse=new PointFeature(PointGeomUnderTheMouse,null,Style.getDefaultCircleStyle());
						this._featureClickHandler.addControledFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
						}
						if(AbstractEditCollectionHandler._pointUnderTheMouse.layer==null) {
							layerToEdit.addFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
							 _editionFeatureArray.push(new Array(AbstractEditCollectionHandler._pointUnderTheMouse,vectorfeature));
						}
						
					 	if(findIndexOfFeatureCurrentlyDrag(AbstractEditCollectionHandler._pointUnderTheMouse)!=-1){ 
							AbstractEditCollectionHandler._pointUnderTheMouse.visible=true;
						 } 
						else AbstractEditCollectionHandler._pointUnderTheMouse.visible=false;
						layerToEdit.redraw();	
					}
					else {
						if(AbstractEditCollectionHandler._pointUnderTheMouse!=null)
						{
							AbstractEditCollectionHandler._pointUnderTheMouse.visible=false;
							layerToEdit.redraw();
							layerToEdit.map.buttonMode=false;		
						}		
					}
		 	}
		 }
		 /**
		 * To draw the temporaries feature during drag Operation
		 * */
		 protected function drawTemporaryFeature(event:MouseEvent):void{
		 	
		 }
	
		 override public function refreshEditedfeatures(event:MapEvent=null):void{
		 	if(AbstractEditCollectionHandler._pointUnderTheMouse){
		 		this._layerToEdit.removeFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
		 		this._featureClickHandler.removeControledFeature(AbstractEditCollectionHandler._pointUnderTheMouse);
		 		AbstractEditCollectionHandler._pointUnderTheMouse=null;
		 	}
		 	_layerToEdit.redraw();
		 }
		 /**
		 * To find the index of feature currently dragged in it's geometry parent array
		 * @param vectorfeature:PointFeature the dragged feature
		 * */
		 public function findIndexOfFeatureCurrentlyDrag(vectorfeature:PointFeature):Number{
		 	var parentFeature:Feature=findVirtualVerticeParent(vectorfeature);
		 var parentgeometry:Collection=editionFeatureParentGeometry(vectorfeature,parentFeature.geometry as Collection);
		 	if(parentFeature && parentFeature.geometry && parentFeature.geometry is Collection){
		 		if(vectorfeature==AbstractEditCollectionHandler._pointUnderTheMouse){
		 			return vectorfeature.getSegmentsIntersection(parentgeometry);
		 		}
		 		else return IsRealVertice(vectorfeature,parentgeometry);
		 	}
		 	return -1;
		 }
		 /**
		 * To know if a dragged point is a under the mouse or is a vertice
		 * if it's a point returns its index else returns -1
		 * @private
		 * */
		 private function IsRealVertice(vectorfeature:PointFeature,parentgeometry:Collection):Number{
		 	
		 				if(parentgeometry){
							var index:Number=0;		
								var geom:Point=vectorfeature.geometry as Point;
							//for each components of the geometry we see if the point belong to it
							for(index=0;index<parentgeometry.componentsLength;index++){		
								var editionfeaturegeom:Point=parentgeometry.componentByIndex(index) as Point;
								if((vectorfeature.geometry as Point).x==editionfeaturegeom.x && (vectorfeature.geometry as Point).y==editionfeaturegeom.y) break;
							}
							if(index<parentgeometry.componentsLength) return index;
						}
		 			return -1;
		 }
		 /**
		 * This function find a parent Geometry of an edition feature
		 * @param point
		 * */
		 public function editionFeatureParentGeometry(point:PointFeature,parentGeometry:Collection):Collection{
			if(point && parentGeometry){
				if(parentGeometry){
					var i:int;
					if(parentGeometry.componentsLength==0) return null;
					else{
					 if(parentGeometry.componentByIndex(0) is Point){
						for(i=0;i<parentGeometry.componentsLength;i++){
							if((point.geometry as Point).equals(parentGeometry.componentByIndex(i) as Point)){
								return parentGeometry;
							}	
						}
					}
					else{
						for(i=0;i<parentGeometry.componentsLength;i++){
							var geomParent:Collection=editionFeatureParentGeometry(point,parentGeometry.componentByIndex(i) as Collection);
							if(geomParent!=null){
								return geomParent;
							}
						}
					} 
					return parentGeometry.componentByIndex(0) as Collection;
				}
				}
			}
			return null;
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
		 /**
		 * To know if we displayed the virtual vertices of collection feature or not
		 **/
		 public function get displayedVirtualVertices():Boolean{
		 	return this._displayedVirtualVertices;
		 }
		 /**
		 * @private
		 * */
		 public function set displayedVirtualVertices(value:Boolean):void{
		 	if(value!=this._displayedVirtualVertices){
		 		this._displayedVirtualVertices=value;
		 		refreshEditedfeatures();
		 	}
		 }
		 
		 
	}
}