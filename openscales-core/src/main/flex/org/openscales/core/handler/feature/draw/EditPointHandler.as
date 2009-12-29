package org.openscales.core.handler.feature.draw
{
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.feature.FeatureClickHandler;
	import org.openscales.core.layer.FeatureLayer;

	/**
	 * This Handler is used for point edition 
	 * its extends CollectionHandler
	 * */
	public class EditPointHandler extends AbstractEditHandler
	{
		/**
		 * EditPointHandler
		 * This handler is used for edition on point such operation as dragging or deleting
		 * @param map:Map object
		 * @param active:Boolean for handler activation
		 * @param layerToEdit:FeatureLayer 
		 * @param featureClickHandler:FeatureClickHandler handler only use it when you want to use this handler alone
		 * */
		public function EditPointHandler(map:Map = null, active:Boolean = false,layerToEdit:FeatureLayer=null,featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null,isUsedAlone:Boolean=true)
		{
			super(map,active,layerToEdit,featureClickHandler,drawContainer,isUsedAlone);			
			this.featureClickHandler=featureClickHandler;
			
		}	
		 /**
		 * @inheritDoc 
		 * */
		override public function featureDoubleClick(event:FeatureEvent):void{
			
			this._layerToEdit.removeFeature(event.feature);
			this._layerToEdit.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DELETING,event.feature));
		}
		 /**
		 * @inheritDoc 
		 * */
		override public function dragVerticeStart(vectorfeature:PointFeature):void{
			vectorfeature.startDrag();
			this._layerToEdit.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DRAG_START,vectorfeature));
		}
		 /**
		 * @inheritDoc 
		 * */
		override public function dragVerticeStop(vectorfeature:PointFeature):void{
			vectorfeature.stopDrag();
			//update geometry
			//We create a new point because of a bug on OpenScales
			var px:Pixel=new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY);
			var lonlat:LonLat=this.map.getLonLatFromLayerPx(px);
			var newGeom:Point=new Point(lonlat.lon,lonlat.lat);
			vectorfeature.geometry=newGeom;
			vectorfeature.x=0;
			vectorfeature.y=0;
			this._layerToEdit.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DRAG_STOP,vectorfeature));
			this._layerToEdit.redraw();
		}
	    /**
		 * @inheritDoc 
		 * */
		 override public function editionModeStart():Boolean{
		 if(this._layerToEdit !=null)
			{
				//We create an editable clone for all existant vector feature
				for each(var vectorFeature:Feature in this._layerToEdit.features){	
					if(vectorFeature.isEditable && vectorFeature is PointFeature){				
				{
					this._featureClickHandler.addControledFeature(vectorFeature);
					this._featureClickHandler.active=true;
					}	
					}
				}
				this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_START,this._layerToEdit));				
			}
		 	return true;
		 }
		  /**
		 * @inheritDoc 
		 * */
		override public function refreshEditedfeatures(event:MapEvent=null):void{
		 	if(_layerToEdit!=null && !_isUsedAlone){
		 		for each(var feature:Feature in this._layerToEdit.features){	
						if(feature is PointFeature && feature.isEditable){
							this._featureClickHandler.addControledFeature(feature);
						}
				}
		 	}
		 	
		 } 
	}
}