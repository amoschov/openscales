package org.openscales.core.handler.mouse
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
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
		 private var _tolerance:Number=8;
		 
		 /**
		 * Click handler to detect click on the feature
		 * */
		 private var _featureclickHandler:FeatureClickHandler;
		 
		 //Used for drag
		 private var _featureCurrentlyDraged:VectorFeature=null;
		 
		 private var _featurePreviouslydrawn:VectorFeature=null;
		 
		 private var _dragTimer:Timer=new Timer(200);
		 
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
		protected function EditionModeStart():Boolean{
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
						if(this._featureclickHandler==null){
							this._featureclickHandler=new FeatureClickHandler(this.map,true);
							this._featureclickHandler.doubleclick=deleteVertice;
							this._featureclickHandler.click=VerticeClickManagement;
						}
						vectorFeature.editionFeaturesArray.push(clonefeature);
						this._featureclickHandler.addControledFeatures(clonefeature.editionFeaturesArray);			
						this._featureclickHandler.active=true;
					}
					}
				
				//this._clickHandler.doubleclick=OnDoubleClick
				this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);	
				this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_START,this._layerToEdit));				
				return true;
			}
				return false;			
		}
		
		
		//End of edition mode
		protected function EditionModeStop():Boolean{
			if(_layerToEdit !=null)
			{
				this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_END,this._layerToEdit));
				this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
				for each(var vectorFeature:VectorFeature in this._layerToEdit.features){	
					if(vectorFeature.isEditionFeature)
					{
						this._layerToEdit.removeFeature(vectorFeature);
					}
					else vectorFeature.visible=true;
				}
				this._layerToEdit.redraw();
				if(this._featureclickHandler!=null) this._featureclickHandler.active=false;
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
		 protected function createPointUndertheMouse(evt:FeatureEvent):void{
		 		var vectorfeature:VectorFeature=evt.feature as VectorFeature;
		 		//Vector feature is not null and belong to the target layer
		 		if(vectorfeature != null && Util.indexOf(this._layerToEdit.features,vectorfeature)!=-1 && vectorfeature.isEditionFeature && !(vectorfeature is PointFeature)){
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
				if(this._pointUnderTheMouse!=null){
					this._layerToEdit.removeFeature(this._pointUnderTheMouse);
					this._featureclickHandler.removeControledFeature(this._pointUnderTheMouse);
					this._layerToEdit.removeFeature(this._pointUnderTheMouse);
					this._pointUnderTheMouse=null;
					this._layerToEdit.redraw();
					
				}
					if(drawing){
						var lonlat:LonLat=this.map.getLonLatFromLayerPx(px);	
						var PointGeomUnderTheMouse:Point=new Point(lonlat.lon,lonlat.lat);
						//we delete the point under the mouse  from layer and from tmpVertices Array
						
					
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
							this._pointUnderTheMouse.layer=this._layerToEdit;
						if(this._pointUnderTheMouse.getSegmentsIntersection(parentTmpPoint as Collection)!=-1){
							this._pointUnderTheMouse.editionFeatureParent=vectorfeature;
							this._layerToEdit.addFeature(this._pointUnderTheMouse);	
							this._featureclickHandler.addControledFeature(this._pointUnderTheMouse);
						}
						else {
							this._pointUnderTheMouse=null;
							this.map.buttonMode=false;
							vectorfeature.buttonMode=false;
						}
					}			
			}
		 }
		 
		 protected function editionPointDragStart(evt:FeatureEvent):void{
		 	var vectorfeature:VectorFeature=evt.feature as VectorFeature;
		 	_dragTimer.start();
		 		//Vector feature is not null and belong to the target layer
		 		if(vectorfeature != null && Util.indexOf(this._layerToEdit.features,vectorfeature)!=-1){
		 			this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);	
		 		
		 		this._featureCurrentlyDraged=vectorfeature;
		 		//drag the point in live
		 	//	this._dragTimer.addEventListener(TimerEvent.TIMER,drawTemporaryFeature);
		 		//this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,drawTemporaryFeature);
		 		}
		 }
		 
		 protected function drawTemporaryFeature(evt:TimerEvent):void{
		 	var vectorfeature:PointFeature=this._featureCurrentlyDraged as PointFeature;
		 	//Vector feature is not null and belong to the target layer
		 	if(vectorfeature != null && Util.indexOf(this._layerToEdit.features,vectorfeature)!=-1 && vectorfeature.isEditionFeature){
		 		var lonlat:LonLat=this.map.getLonLatFromLayerPx(new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY));			
		 		var newVertice:Point=new Point(lonlat.lon,lonlat.lat);
		 		var index:int=-1;
		 		if(this._featurePreviouslydrawn!=null){
		 		index=(_featurePreviouslydrawn as PointFeature).getSegmentsIntersection((_featurePreviouslydrawn as PointFeature).editionFeatureParentGeometry as Collection);
		 		if(index!=-1){
		 			(_featurePreviouslydrawn as PointFeature).editionFeatureParentGeometry.replaceComponent(index,newVertice);
		 		}	
		 		else{
		 			(_featurePreviouslydrawn as PointFeature).editionFeatureParentGeometry.addComponent(newVertice);
		 		}
		 		this._layerToEdit.redraw();
		 		}
		 		this._featurePreviouslydrawn=new PointFeature(newVertice,null,null,true,vectorfeature.editionFeatureParentGeometry);
		 		this._featurePreviouslydrawn.layer=this._layerToEdit;
		 	}
		 }
		 
		 protected function editionPointDragStop(evt:FeatureEvent):void{
		 	var vectorfeature:PointFeature=evt.feature as PointFeature;
		 		//Vector feature is not null and belong to the target layer
		 		this._dragTimer.stop();
		 		
		 		if(vectorfeature != null && Util.indexOf(this._layerToEdit.features,vectorfeature)!=-1 && vectorfeature.isEditionFeature){
		 			var indexpoint:int=-1;
		 		if(this._featurePreviouslydrawn!=null){	
		 						indexpoint=(this._featurePreviouslydrawn as PointFeature).getSegmentsIntersection((this._featurePreviouslydrawn as PointFeature).editionFeatureParentGeometry);
		 						(this._featurePreviouslydrawn as PointFeature).editionFeatureParentGeometry.removeComponent(this._featurePreviouslydrawn.geometry);
		 				}
		 			
		 			var lonlat:LonLat=this.map.getLonLatFromLayerPx(new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY));			
		 			var newVertice:Point=new Point(lonlat.lon,lonlat.lat);
					
					if(indexpoint==-1)indexpoint=IspointUndertheMouse(vectorfeature);
					if(indexpoint!=-1){
						(vectorfeature.editionFeatureParentGeometry as Collection).replaceComponent(indexpoint,newVertice);
					}
					else{
						 	indexpoint=this._pointUnderTheMouse.getSegmentsIntersection(vectorfeature.editionFeatureParentGeometry as Collection);
							(vectorfeature.editionFeatureParentGeometry as Collection).addComponent(newVertice,indexpoint);	
						}	
					
					//we get the temporary edition parent which is parent of the edition feature
					var editionfeatureparent:VectorFeature=vectorfeature.editionFeatureParent;
					this._featureclickHandler.removeControledFeatures(editionfeatureparent.editionFeaturesArray);
					editionfeatureparent.RefreshEditionVertices();
					this._featureclickHandler.addControledFeatures(editionfeatureparent.editionFeaturesArray);
					this._layerToEdit.removeFeature(this._pointUnderTheMouse);
					this._pointUnderTheMouse=null;
					this._layerToEdit.addFeatures(editionfeatureparent.editionFeaturesArray);
					
					this._layerToEdit.redraw();		
					this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);	
					this.map.buttonMode=false;
		 		}
		 }
		 /**
		 * To know if a dragged point is a under the mouse or is a vertice
		 * if it's a point returns its index else returns -1
		 * */
		 protected function IspointUndertheMouse(vectorfeature:PointFeature):Number{
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
		 
		 /**
		 * delete a verice
		 * */
		 public function deleteVertice(evt:FeatureEvent):void{
		 		//disable double click on point under the mouse
		 		var vectorfeature:PointFeature=evt.feature as PointFeature;
		 		if(!(vectorfeature==this._pointUnderTheMouse)){
		 		var index:int=0;
		 		var componentLength:Number=(vectorfeature.editionFeatureParentGeometry as Collection).componentsLength;
		 		var editionfeaturegeom:Point=null;
		 		for(index=0;index<componentLength;index++){		
						 editionfeaturegeom=(vectorfeature.editionFeatureParentGeometry as Collection).componentByIndex(index) as Point;
						if((vectorfeature.geometry as Point).x==editionfeaturegeom.x && (vectorfeature.geometry as Point).y==editionfeaturegeom.y) break;
					}
				(vectorfeature.editionFeatureParentGeometry as Collection).removeComponent(editionfeaturegeom);
				//we get the temporary edition parent which is parent of the edition feature
				var editionfeatureparent:VectorFeature=vectorfeature.editionFeatureParent;
				this._featureclickHandler.removeControledFeatures(editionfeatureparent.editionFeaturesArray);
				editionfeatureparent.RefreshEditionVertices();
				this._featureclickHandler.addControledFeatures(editionfeatureparent.editionFeaturesArray);
				this._layerToEdit.removeFeature(this._pointUnderTheMouse);
				this._pointUnderTheMouse=null;
				this._layerToEdit.addFeatures(editionfeatureparent.editionFeaturesArray);
				this._layerToEdit.redraw();
				this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);	
				this.map.buttonMode=false;
		 		}
		 		if(vectorfeature!=null) vectorfeature.stopDrag();
		 		this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);	
				this.map.buttonMode=false;
		 }
		 
		 /**
		 * The way to follow when there is a click
		 * when the event is not a drag and is not a double click
		 * */
		 protected function VerticeClickManagement(event:FeatureEvent):void{
		 
		 	var vectorfeature:VectorFeature=event.feature as VectorFeature;
		 	vectorfeature.stopDrag();
		 	if(this._pointUnderTheMouse==vectorfeature){
		 		this._layerToEdit.removeFeature(this._pointUnderTheMouse);
				this._featureclickHandler.removeControledFeature(this._pointUnderTheMouse);
		 	}
		 	var editionfeatureparent:VectorFeature=vectorfeature.editionFeatureParent;
		 	this._featureclickHandler.removeControledFeatures(editionfeatureparent.editionFeaturesArray);
			editionfeatureparent.RefreshEditionVertices();
			this._featureclickHandler.addControledFeatures(editionfeatureparent.editionFeaturesArray);
			this._layerToEdit.addFeatures(editionfeatureparent.editionFeaturesArray);
			this._layerToEdit.redraw();
			this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);		
			this.map.buttonMode=false;	 		
		 }
		 
		 /**
		 * To record Modification
		 * */	 
		 public function RecordModification():void{
		 	
		 	var realFeatureArray:Array=new Array(); 
		 	var editionfeatureArray:Array=new Array();
		 	var feature:VectorFeature=null;
		 	
		 	for each(feature in this._layerToEdit.features){
		 		if(feature.isEditable) realFeatureArray.push(feature);
		 		else editionfeatureArray.push(feature);
		 	}
		 	
		 	for each(feature in realFeatureArray){
		 		if(feature.editionFeaturesArray.length!=0)
		 		{
		 			feature.geometry=(feature.editionFeaturesArray[0] as VectorFeature).geometry;
		 			feature.visible=true;
		 		}
		 	}
		 	this.layerToEdit.removeFeatures(editionfeatureArray);
		 	EditionModeStop();
		 	EditionModeStart();	 	
		 	this.layerToEdit.redraw();	 	
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