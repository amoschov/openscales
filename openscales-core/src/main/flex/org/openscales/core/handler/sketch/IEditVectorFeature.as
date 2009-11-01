package org.openscales.core.handler.sketch
{
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.VectorFeature;
	
	public interface IEditVectorFeature
	{
		
		
		 function editionModeStart():Boolean;
		 function editionModeStop():Boolean;
		 function dragVerticeStart(event:FeatureEvent):void;
		 function dragVerticeStop(event:FeatureEvent):void;
		 function featureClick(event:FeatureEvent):void;
		 function featureDoubleClick(event:FeatureEvent):void;
	}
}