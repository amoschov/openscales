package org.openscales.core.configuration
{
	import org.openscales.core.Map;
	import org.openscales.core.layer.Layer;
	
	public interface IConfiguration
	{
		
		/**
		 * 
		 * @param config The XML config file
		 * @param map The map to configure, will be updated in configureMap regarding to the config file.
		 */		
		function configureMap(map:Map):void;
		
		/**
		 * Set and store the configuration file that will be used further
		 */
		function set config(value:XML):void;
		
		/**
		 * Get the config file as a raw XML instance 
		 */
		function get config():XML;
		
		/**
		 * Return layers configured between the <layers> </layers> elements
		 */
		function get layersFromMap():Array;

		/**
		 * Return layers configured between the <Catalog> </Catalog> elements (recursively parsed in all categories)
		 */	
		function get layersFromCatalog():Array;
		
		/**
		 * @return The child items of <Catalog> </Catalog> elements 
		 */	
		function get catalog():XMLList;
		
		/**
		 * @return The child items of <Custom> </Custom> elements
		 * It's an XML and not a XMLList because in case we have several customs, we can't access specificly to a custom.
		 */	
		function get custom():XML;
		
		/**
		 * @return The child items of <Handlers> </Handlers> elements 
		 */
		function get handlers():XMLList;
		
		/**
		 * @return The child items of <Controls> </Controls> elements 
		 */
		 function get controls():XMLList;
		 /**
		 * @return The child items of <Securities> </Securities> elements 
		 */
		 function get securities():XMLList;
		 
		 /**
		 * parse layers
		 */
		 function parseLayer(xmlNode:XML):Layer;
		
	}
}