package org.openscales.core.handler.feature.draw
{
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.PointFeature;
	
	
	/**
	 * This  is the interface for all modification handler
	 * 
	 * */
	public interface IEditFeature
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
		 function dragVerticeStart(vectorfeature:PointFeature):void;
		 /**
		 * This function is launched when you stop  dragging a vertice(Virtual or not)
		 * 
		 * */
		 function dragVerticeStop(vectorfeature:PointFeature):void;
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
		  /**
		 * This function is used for refreshing all edited features
		 * after event like Mapevent.zoomend or moveend
		 * */
		 function refreshEditedfeatures(event:MapEvent=null):void;
		 /**
		 * This function is abble to find a virtual vertice parent
		 * @param virtualVertice the virtual vertice 
		 * @param arrayTosearch The array where to find the parent 
		 * */
		 function findVirtualVerticeParent(virtualVertice:PointFeature,arrayTosearch:Array=null):Feature;
	}
}