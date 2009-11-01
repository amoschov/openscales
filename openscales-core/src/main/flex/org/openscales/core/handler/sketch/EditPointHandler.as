package org.openscales.core.handler.sketch
{
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.handler.mouse.FeatureClickHandler;
	import org.openscales.core.layer.VectorLayer;
	
	public class EditPointHandler extends AbstractEditHandler
	{
		/**
		 * EditPointHandler
		 * This handler is used for edition on point such operation as dragging or deleting
		 * @param map:Map object
		 * @param active:Boolean for handler activation
		 * @param layerToEdit:VectorLayer 
		 * @param featureClickHandler:FeatureClickHandler handler only use it when you want to use this handler alone
		 * */
		public function EditPointHandler(map:Map = null, active:Boolean = false,layerToEdit:VectorLayer=null,featureClickHandler:FeatureClickHandler=null)
		{
			super(map,active,layerToEdit,featureClickHandler);			
			this.featureClickHandler=featureClickHandler;
			
		}	
		
		override public function featureDoubleClick(event:FeatureEvent):void{
			
			this._layerToEdit.removeFeature(event.feature);
			this._layerToEdit.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DELETING,event.feature));
		}
		
		override public function dragVerticeStart(event:FeatureEvent):void{
			event.feature.startDrag();
			this._layerToEdit.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DRAG_START,event.feature));
		}
		
		override public function dragVerticeStop(event:FeatureEvent):void{
			event.feature.stopDrag();
			//update geometry
			var px:Pixel=new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY);
			var lonlat:LonLat=this.map.getLonLatFromLayerPx(px);
			(event.feature as PointFeature).point.x=lonlat.lon;
			(event.feature as PointFeature).point.y=lonlat.lat;
			this._layerToEdit.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DRAG_STOP,event.feature));
		}
		
		 override public function editionModeStart():Boolean{
		 if(this._layerToEdit !=null)
			{
				//We create an editable clone for all existant vector feature
				for each(var vectorFeature:VectorFeature in this._layerToEdit.features){	
					if(/*vectorFeature.isEditable && */vectorFeature is PointFeature){				
				if(this._featureClickHandler!=null){
					this._featureClickHandler.addControledFeature(vectorFeature);
					this._featureClickHandler.active=true;
					}	
					}
				}
				if(this._featureClickHandler!=null)this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_START,this._layerToEdit));				
			}
		 	return true;
		 }
	}
}