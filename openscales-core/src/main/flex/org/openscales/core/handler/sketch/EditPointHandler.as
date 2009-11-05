package org.openscales.core.handler.sketch
{
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Point;
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
		public function EditPointHandler(map:Map = null, active:Boolean = false,layerToEdit:VectorLayer=null,featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null)
		{
			super(map,active,layerToEdit,featureClickHandler,drawContainer);			
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
		
		override public function dragVerticeStop(event:FeatureEvent):VectorFeature{
			event.feature.stopDrag();
			//update geometry
			var px:Pixel=new Pixel(this._layerToEdit.mouseX,this._layerToEdit.mouseY);
			var lonlat:LonLat=this.map.getLonLatFromLayerPx(px);
			this._layerToEdit.removeFeature(event.feature);
			//if(this._featureClickHandler!=null)this._featureClickHandler.removeControledFeature(event.feature as VectorFeature);
		//	 bug this is why we have created a new point
			//(event.feature as PointFeature).geometry= new Point(lonlat.lon,lonlat.lat);
			//this._layerToEdit.redraw();
			var newPointFeature:PointFeature=new PointFeature(new Point(lonlat.lon,lonlat.lat));
			newPointFeature.style=(event.feature as VectorFeature).style;
			this._layerToEdit.addFeature(newPointFeature);
			if(this._featureClickHandler!=null)this._featureClickHandler.addControledFeature(newPointFeature);
			this._layerToEdit.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DRAG_STOP,event.feature));
			return newPointFeature;
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