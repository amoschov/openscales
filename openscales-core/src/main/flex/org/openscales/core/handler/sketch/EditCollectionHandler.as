package org.openscales.core.handler.sketch
{
	import org.openscales.core.Map;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.handler.mouse.FeatureClickHandler;
	import org.openscales.core.layer.VectorLayer;

	public class EditCollectionHandler extends AbstractEditHandler
	{
		public function EditCollectionHandler(map:Map=null, active:Boolean=false, layerToEdit:VectorLayer=null, featureClickHandler:FeatureClickHandler=null)
		{
			super(map, active, layerToEdit, featureClickHandler);
		}
		override public function editionModeStart():Boolean{
		 	for each(var vectorFeature:VectorFeature in this._layerToEdit.features){	
					if(/*vectorFeature.isEditable && */vectorFeature.geometry is Collection){
						
						//Clone or not
						if(this._featureClickHandler!=null)	this._featureClickHandler.addControledFeature(vectorFeature);
						vectorFeature.createEditionVertices();
						this._layerToEdit.addFeatures(vectorFeature.editionFeaturesArray);
					}
				}
					if(this._featureClickHandler!=null)this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_START,this._layerToEdit));				
		 	return true;
		 }
		 override public function editionModeStop():Boolean{
		 	return true;
		 }
		 override public function dragVerticeStart(event:FeatureEvent):void{
		
		 }
		override  public function dragVerticeStop(event:FeatureEvent):void{
		 	
		 }
		 override public function featureClick(event:FeatureEvent):void{
		 	
		 }
		 override public function featureDoubleClick(event:FeatureEvent):void{
		 
		 }
	}
}