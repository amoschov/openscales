package org.openscales.core.handler.feature
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.feature.FeatureClickHandler;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.handler.feature.EditCollectionHandler;
	
	/**
	 * This Handler is used for Path edition 
	 * its extends CollectionHandler
	 * */
	public class EditPathHandler extends EditCollectionHandler
	{
		public function EditPathHandler(map:Map = null, active:Boolean = false,layerToEdit:FeatureLayer=null,featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null,isUsedAlone:Boolean=true)
		{
			super(map,active,layerToEdit,featureClickHandler,drawContainer,isUsedAlone);			
		}
		
		/**
		 * This function is used for paths edition mode starting
		 * 
		 * */
		override public function editionModeStart():Boolean{
		 	for each(var vectorFeature:Feature in this._layerToEdit.features){	
					if(vectorFeature.isEditable && vectorFeature.geometry is LineString){			
						//Clone or not
						displayVisibleVirtualVertice(vectorFeature);
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
		  override public function dragVerticeStart(vectorfeature:PointFeature):void{
		 	if(vectorfeature.editionFeatureParent is LineStringFeature || vectorfeature.editionFeatureParent is MultiLineStringFeature){
		 		super.dragVerticeStart(vectorfeature);
		 	}
		 	
		 }
		 /**
		 * @inheritDoc 
		 * */
		 override  public function dragVerticeStop(vectorfeature:PointFeature):void{
		 	if(vectorfeature.editionFeatureParent is LineStringFeature || vectorfeature.editionFeatureParent is MultiLineStringFeature){
		 		return super.dragVerticeStop(vectorfeature);
		 	}
		 }
		 
		 
		 /**
		 * @inheritDoc 
		 * */
		 override protected function drawTemporaryFeature(event:MouseEvent):void{
		 	var pointUnderTheMouse:Boolean=false;
		 	var parentgeom:Collection=null;
		 	var vectorfeatureparent:Feature=null;
		 	//the feature currently dragged is a real vertice
		 	if(this._featureCurrentlyDrag!=null)parentgeom=(this._featureCurrentlyDrag as PointFeature).editionFeatureParentGeometry;
		 	//the feature currently dragged is a point under the mouse 	
		 	else{
		 		 parentgeom=EditCollectionHandler._pointUnderTheMouse.editionFeatureParentGeometry;
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
		 		_drawContainer.graphics.lineTo(map.mouseX-7, map.mouseY-7);
		 		_drawContainer.graphics.endFill();
		 	}
		 	else if (point2!=null && point1!=null){
		 		point2Px=this.map.getMapPxFromLonLat(new LonLat(point2.x,point2.y));
		 		_drawContainer.graphics.clear();
		 		_drawContainer.graphics.lineStyle(1, 0xFF00BB);	 
		 		_drawContainer.graphics.moveTo(point1Px.x,point1Px.y);
		 		_drawContainer.graphics.lineTo(map.mouseX-7, map.mouseY-7);
		 		_drawContainer.graphics.moveTo(point2Px.x,point2Px.y);
		 		_drawContainer.graphics.lineTo(map.mouseX-7, map.mouseY-7);
		 		_drawContainer.graphics.endFill();
		 	}	
		 }
		 else{
		 	_drawContainer.graphics.clear();
		 }
	}
	}
}