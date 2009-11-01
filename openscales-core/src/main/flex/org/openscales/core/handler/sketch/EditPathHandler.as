package org.openscales.core.handler.sketch
{
	import org.openscales.core.Map;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.handler.mouse.FeatureClickHandler;
	import org.openscales.core.layer.VectorLayer;
	
	public class EditPathHandler extends EditCollectionHandler
	{
		public function EditPathHandler(map:Map = null, active:Boolean = false,layerToEdit:VectorLayer=null,featureClickHandler:FeatureClickHandler=null)
		{
			super(map,active,layerToEdit,featureClickHandler);			
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
		override protected function drawTemporaryFeature():void{
		 	
		 }
	}
}