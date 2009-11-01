package org.openscales.core.handler.sketch
{
	import org.openscales.core.Map;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.handler.mouse.FeatureClickHandler;
	import org.openscales.core.layer.VectorLayer;
	
	public class EditPathHandler extends EditCollectionHandler
	{
		public function EditPathHandler(map:Map = null, active:Boolean = false,layerToEdit:VectorLayer=null,featureClickHandler:FeatureClickHandler=null)
		{
			super(map,active,layerToEdit,featureClickHandler);			
			this.featureClickHandler=featureClickHandler;
		}
	}
}