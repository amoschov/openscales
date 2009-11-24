package org.openscales.core.handler.sketch
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.MultiPolygonFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.handler.mouse.FeatureClickHandler;
	import org.openscales.core.layer.FeatureLayer;
	/**
	 * This Handler is used for polygon edition 
	 * its extends CollectionHandler
	 * */
	public class EditPolygonHandler extends EditCollectionHandler
	{
		public function EditPolygonHandler(map:Map = null, active:Boolean = false,layerToEdit:FeatureLayer=null,featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null,isUsedAlone:Boolean=true)
		{
			super(map,active,layerToEdit,featureClickHandler,drawContainer,isUsedAlone);			
		}
		/**
		 * This function is used for Polygons edition mode starting
		 * 
		 * */
		override public function editionModeStart():Boolean{
		 	for each(var vectorFeature:VectorFeature in this._layerToEdit.features){	
					if(vectorFeature.isEditable && vectorFeature.geometry is Polygon){			
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
		 	if(vectorfeature.editionFeatureParent is PolygonFeature || vectorfeature.editionFeatureParent is MultiPolygonFeature){
		 		super.dragVerticeStart(vectorfeature);
		 	}
		 	
		 }
		 /**
		 * @inheritDoc 
		 * */
		 override  public function dragVerticeStop(vectorfeature:PointFeature):void{
		 	if(vectorfeature.editionFeatureParent is PolygonFeature || vectorfeature.editionFeatureParent is MultiPolygonFeature){
		 		return super.dragVerticeStop(vectorfeature);
		 	}
		 }
		/**
		 * @inheritDoc 
		 * */
		override protected function drawTemporaryFeature(event:MouseEvent):void{
		 	var pointUnderTheMouse:Boolean=false;
		 	var parentgeom:Collection=null;
		 	
		 	
		 	//We tests if it's the point under the mouse or not
		 	if(this._featureCurrentlyDrag!=null) parentgeom=(this._featureCurrentlyDrag as PointFeature).editionFeatureParentGeometry;
		 	else{
		 		parentgeom=EditCollectionHandler._pointUnderTheMouse.editionFeatureParentGeometry;
		 		pointUnderTheMouse=true;
		 	}
		 	//The mouse's button  is always down 
		 	if(event.buttonDown){
		 	var point1:Point=null;
		 	var point2:Point=null;
			var point1Px:Pixel=null;
			var point2Px:Pixel=null;
			//First vertice position 0
			if(indexOfFeatureCurrentlyDrag==0){
				if(pointUnderTheMouse){
		 			point1=parentgeom.componentByIndex(0) as Point;
		 			point2=parentgeom.componentByIndex(1) as Point;
		 		}
		 		else{
				point1=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag+1) as Point;
		 		point2=parentgeom.componentByIndex(parentgeom.componentsLength-1) as Point;
		 		}
			}
			//Last vertice treatment
			else if(indexOfFeatureCurrentlyDrag==parentgeom.componentsLength-1){
				if(pointUnderTheMouse){
		 			point1=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag-1) as Point;
		 			point2=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag) as Point;
		 		}
		 		else{
		 			point1=parentgeom.componentByIndex(0) as Point;
		 			point2=parentgeom.componentByIndex(parentgeom.componentsLength-2) as Point;
		 		}
			}
			//Last vertice +1  treatment only  for point under the mouse
			else if(indexOfFeatureCurrentlyDrag==parentgeom.componentsLength){
				if(pointUnderTheMouse){
		 			point1=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag-1) as Point;
		 			point2=parentgeom.componentByIndex(0) as Point;
		 		}
			}
			//others treatments
			else{
				if(pointUnderTheMouse){
		 			point1=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag-1) as Point;
		 			point2=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag) as Point;
		 		}
		 		else{
				point1=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag+1) as Point;
		 		point2=parentgeom.componentByIndex(indexOfFeatureCurrentlyDrag-1) as Point;
		 		}
			}
			//We draw the temporaries lines of the polygon
			if(point1!=null && point2!=null){
				point1Px=this.map.getMapPxFromLonLat(new LonLat(point1.x,point1.y));
				point2Px=this.map.getMapPxFromLonLat(new LonLat(point2.x,point2.y));
				
		 		_drawContainer.graphics.clear();
		 		_drawContainer.graphics.lineStyle(1, 0xFF00BB);	 
		 		_drawContainer.graphics.moveTo(point1Px.x,point1Px.y);
		 		_drawContainer.graphics.lineTo(map.mouseX-4, map.mouseY-4);
		 		_drawContainer.graphics.moveTo(point2Px.x,point2Px.y);
		 		_drawContainer.graphics.lineTo(map.mouseX-4, map.mouseY-4);
		 		_drawContainer.graphics.endFill();
				 }
		 	}
		 	else{
		 		_drawContainer.graphics.clear();
		 	}
		 }
	}
}