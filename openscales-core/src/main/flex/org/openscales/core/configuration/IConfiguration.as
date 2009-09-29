package org.openscales.core.configuration
{
	import org.openscales.core.Map;
	
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
		 */	
		function get custom():XMLList;
		
		/**
		 * @return The child items of <Handlers> </Handlers> elements 
		 */
		function get handlers():XMLList;
		
		/**
		 * @return The child items of <Controls> </Controls> elements 
		 */
		 function get controls():XMLList;
		
	}
}