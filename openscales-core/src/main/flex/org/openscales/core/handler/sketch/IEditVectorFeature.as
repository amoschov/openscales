package org.openscales.core.handler.sketch
{
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.VectorFeature;
	
	
	/**
	 * This  is the interface for all modification handler
	 * 
	 * */
	public interface IEditVectorFeature
	{
		
		/**
		 * Start the edition Mode
		 * */
		 function editionModeStart():Boolean;
		 
		  /**
		 * Stop the edition Mode
		 * */
		 function editionModeStop():Boolean;
		  /**
		 * This function is launched when you are dragging a vertice(Virtual or not)
		 * 
		 * */	
		 function dragVerticeStart(event:FeatureEvent):void;
		 /**
		 * This function is launched when you stop  dragging a vertice(Virtual or not)
		 * 
		 * */
		 function dragVerticeStop(event:FeatureEvent):VectorFeature;
		 /**
		 * This function is launched when you click  on a vertice(Virtual or not)
		 * for the moment nothing is done
		 * */
		 function featureClick(event:FeatureEvent):void;
		  /**
		 * This function is launched when you double click  on a vertice(Virtual or not)
		 * For the moment the vertice is deleted
		 * */
		 function featureDoubleClick(event:FeatureEvent):void;
	}
}