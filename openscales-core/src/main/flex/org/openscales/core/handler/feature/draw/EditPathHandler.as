package org.openscales.core.handler.feature.draw
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.feature.FeatureClickHandler;
	import org.openscales.core.layer.FeatureLayer;
	
	/**
	 * This Handler is used for Path edition 
	 * its extends CollectionHandler
	 * */
	public class EditPathHandler extends AbstractEditCollectionHandler
	{
		public function EditPathHandler(map:Map = null, active:Boolean = false,layerToEdit:FeatureLayer=null,featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null,isUsedAlone:Boolean=true)
		{
			super(map,active,layerToEdit,featureClickHandler,drawContainer,isUsedAlone);			
		}

		 /**
		 * @inheritDoc 
		 * */
		  override public function dragVerticeStart(vectorfeature:PointFeature):void{
		  	//The feature edited  is the parent of the virtual vertice
		  	var featureEdited:Feature=findVirtualVerticeParent(vectorfeature as PointFeature);
		 	if(featureEdited!=null && (featureEdited is LineStringFeature || featureEdited is MultiLineStringFeature)){
		 		super.dragVerticeStart(vectorfeature);
		 	}
		 	
		 }
		 /**
		 * @inheritDoc 
		 * */
		 override  public function dragVerticeStop(vectorfeature:PointFeature):void{
		 	//The feature edited  is the parent of the virtual vertice
		  	var featureEdited:Feature=findVirtualVerticeParent(vectorfeature as PointFeature);
		 	if(featureEdited!=null && (featureEdited is LineStringFeature || featureEdited is MultiLineStringFeature)){
		 		return super.dragVerticeStop(vectorfeature);
		 	}
		 }
		 /**
		 * @inheritDoc 
		 * */
		override public function refreshEditedfeatures(event:MapEvent=null):void{

		 	if(_layerToEdit!=null && !_isUsedAlone){
		 		for each(var feature:Feature in this._layerToEdit.features){	
					if(feature.isEditable && (feature.geometry is LineString || feature.geometry is MultiLineString)){			
						//We display on the layer concerned by the operation the virtual vertices used for edition
						//if the virtual vertices have to be displayed we displayed them
						if(displayedVirtualVertices)displayVisibleVirtualVertice(feature);
					}
					//Virtual vertices treatment
					else if(feature is Point /*&&  Util.indexOf(this._editionFeatureArray,feature)!=-1 */)
					{
						for(var i:int=0;i<this._editionFeatureArray.length;i++){
							if(this._editionFeatureArray[i][0]==feature){
								//We remove the edition feature to create another 						
								//TODO Damien nda only delete the feature concerned by the operation
								layerToEdit.removeFeature(feature);
								this._featureClickHandler.removeControledFeature(feature);
								Util.removeItem(this._editionFeatureArray,this._editionFeatureArray[i]);
								feature.destroy();
								feature=null;
							}
						}
					} 
				}
		 	}
		 	super.refreshEditedfeatures();
		 }
		 
		 /**
		 * @inheritDoc 
		 * */
		 override protected function drawTemporaryFeature(event:MouseEvent):void{
		 	var pointUnderTheMouse:Boolean=false;
		 	var parentgeom:Collection=null;
		 	var parentFeature:Feature;
		 	//the feature currently dragged is a real vertice
		 	if(this._featureCurrentlyDrag!=null){
		 		parentFeature=findVirtualVerticeParent(this._featureCurrentlyDrag as PointFeature)
		 		parentgeom=editionFeatureParentGeometry(this._featureCurrentlyDrag as PointFeature,parentFeature.geometry as Collection);
		 	}
		 	//the feature currently dragged is a point under the mouse 	
		 	else{
		 		// parentgeom=AbstractEditCollectionHandler._pointUnderTheMouse.editionFeatureParentGeometry;
		 		parentFeature=findVirtualVerticeParent(AbstractEditCollectionHandler._pointUnderTheMouse)
		 		parentgeom=editionFeatureParentGeometry(AbstractEditCollectionHandler._pointUnderTheMouse,parentFeature.geometry as Collection);
		 		pointUnderTheMouse=true;
		 	}
		 	
		 	//The  Mouse button is down
		 	if(event.buttonDown){
		 	var point1:Point=null;
		 	var point2:Point=null;
			var point1Px:Pixel=null;
			var point2Px:Pixel=null;
			//We take 2 points in the collection depends on the index of the feature currently dragged
		 	if(indexOfFeatureCurrentlyDrag==0){
		 		if(pointUnderTheMouse){
		 			point1=parentgeom.componentByIndex(0) as Point;
		 			point2=parentgeom.componentByIndex(1) as Point;
		 		}
		 		else point1=parentgeom.componentByIndex(1) as Point;
		 	}

		 	else if(indexOfFeatureCurrentlyDrag==parentgeom.componentsLength-1){
		 		if(pointUnderTheMouse){
		 			point1=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag-1) as Point;
		 			point2=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag) as Point;
		 		}
		 		else point1=parentgeom.componentByIndex(parentgeom.componentsLength-2) as Point;	 	
		 	}	 	
		 	else{
		 		if(pointUnderTheMouse){
		 			point1=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag-1) as Point;
		 			point2=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag) as Point;
		 		}
		 		else{ point1=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag+1) as Point;
		 		 point2=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag-1) as Point;
		 		}
		 	}
		 	if(point1!=null)point1Px=this.map.getMapPxFromLonLat(new LonLat(point1.x,point1.y));
		 	
		 	//We draw the temporaries lines
		 	if(point2==null && point1!=null){
		 		_drawContainer.graphics.clear();
		 		_drawContainer.graphics.lineStyle(1, 0xFF00BB);	 		
		 		_drawContainer.graphics.moveTo(point1Px.x,point1Px.y);
		 		_drawContainer.graphics.lineTo(map.mouseX, map.mouseY);
		 		_drawContainer.graphics.endFill();
		 	}
		 	else if (point2!=null && point1!=null){
		 		point2Px=this.map.getMapPxFromLonLat(new LonLat(point2.x,point2.y));
		 		_drawContainer.graphics.clear();
		 		_drawContainer.graphics.lineStyle(1, 0xFF00BB);	 
		 		_drawContainer.graphics.moveTo(point1Px.x,point1Px.y);
		 		_drawContainer.graphics.lineTo(map.mouseX, map.mouseY);
		 		_drawContainer.graphics.moveTo(point2Px.x,point2Px.y);
		 		_drawContainer.graphics.lineTo(map.mouseX, map.mouseY);
		 		_drawContainer.graphics.endFill();
		 	}	
		 }
		 else{
		 	_drawContainer.graphics.clear();
		 }
	}
	}
}