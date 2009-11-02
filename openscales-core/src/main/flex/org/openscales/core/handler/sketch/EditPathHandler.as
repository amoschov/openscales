package org.openscales.core.handler.sketch
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.mouse.FeatureClickHandler;
	import org.openscales.core.layer.VectorLayer;
	
	public class EditPathHandler extends EditCollectionHandler
	{
		public function EditPathHandler(map:Map = null, active:Boolean = false,layerToEdit:VectorLayer=null,featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null)
		{
			super(map,active,layerToEdit,featureClickHandler,drawContainer);			
		}
		/**
		 *Edition mode start 
		 **/
		 override public function editionModeStart():Boolean{
		 	for each(var vectorFeature:VectorFeature in this._layerToEdit.features){	
					if(/*vectorFeature.isEditable && */vectorFeature.geometry is LineString){
						
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
		  override public function dragVerticeStart(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
		 	if(vectorfeature.editionFeatureParent is LineStringFeature){
		 		super.dragVerticeStart(event);
		 	}
		 	
		 }
		 override  public function dragVerticeStop(event:FeatureEvent):VectorFeature{
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
		 	if(vectorfeature.editionFeatureParent is LineStringFeature){
		 		return super.dragVerticeStop(event);
		 	}
		 	return null;
		 }
		 
		 
		 /**
		 * drawing of the temporary line during drag
		 * 
		 * */
		 override protected function drawTemporaryFeature(event:MouseEvent):void{
		 	var pointUnderTheMouse:Boolean=false;
		 	var parentgeom:Collection=null;
		 	if(this._featureCurrentlyDrag!=null) parentgeom=(this._featureCurrentlyDrag as PointFeature).editionFeatureParentGeometry;
		 	else{
		 		 parentgeom=EditCollectionHandler._pointUnderTheMouse.editionFeatureParentGeometry;
		 		pointUnderTheMouse=true;
		 	}
		 	var point1:Point=null;
		 	var point2:Point=null;
			var point1Px:Pixel=null;
			var point2Px:Pixel=null;
			
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
		 	point1Px=this.map.getLayerPxFromLonLat(new LonLat(point1.x,point1.y));
		 	
		 	//We draw the temporaries lines
		 	if(point2==null){
		 		_drawContainer.graphics.clear();
		 		_drawContainer.graphics.lineStyle(1, 0x00ff00);	 		
		 		_drawContainer.graphics.moveTo(point1Px.x,point1Px.y);
		 		_drawContainer.graphics.lineTo(map.mouseX-7, map.mouseY-7);
		 		_drawContainer.graphics.endFill();
		 	}
		 	else{
		 		point2Px=this.map.getLayerPxFromLonLat(new LonLat(point2.x,point2.y));
		 		_drawContainer.graphics.clear();
		 		_drawContainer.graphics.lineStyle(1, 0x00ff00);	 
		 		_drawContainer.graphics.moveTo(point1Px.x,point1Px.y);
		 		_drawContainer.graphics.lineTo(map.mouseX-7, map.mouseY-7);
		 		_drawContainer.graphics.moveTo(point2Px.x,point2Px.y);
		 		_drawContainer.graphics.lineTo(map.mouseX-7, map.mouseY-7);
		 		_drawContainer.graphics.endFill();
		 	}	
		 }
	}
}