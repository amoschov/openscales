package org.openscales.core.configuration
{
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.control.Control;
	import org.openscales.core.control.LayerSwitcher;
	import org.openscales.core.control.MousePosition;
	import org.openscales.core.control.PanZoom;
	import org.openscales.core.control.ScaleLine;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.mouse.BorderPanHandler;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.handler.mouse.DragFeature;
	import org.openscales.core.handler.mouse.DragHandler;
	import org.openscales.core.handler.mouse.SelectFeature;
	import org.openscales.core.handler.mouse.WheelHandler;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.ogc.WFS;
	import org.openscales.core.layer.ogc.WMS;
	import org.openscales.core.layer.ogc.WMSC;
	import org.openscales.core.layer.osm.Mapnik;
	import org.openscales.core.layer.params.ogc.WFSParams;
	import org.openscales.core.layer.params.ogc.WMSParams;

	/**
	 * Sample XML OpenScales configuration format.
	 * Have a look to openscales-core/src/test/resources/configuration/sampleMapConfOk.xml for a sample valid XML file
	 * 
	 * TODO : create an XML schema
	 * 
	 */
	public class Configuration implements IConfiguration
	{
		protected var _config:XML;
		
		public function Configuration(config:XML = null)
		{
			this.config = config;
		}
		
		public function configureMap(map:Map):void {
			// Parse the XML (children of Layers, Handlers, Controls ...)	
			map.name = config.@name;
			map.proxy = config.@proxy;
			
			if(config.@width != ""){map.width = Number(config.@width);}
			if(config.@height != ""){map.height = Number(config.@height);}
			map.x = Number(config.@x);
			map.y = Number(config.@y);
			
			map.minResolution = config.@minResolution;
			map.maxResolution = config.@maxResolution;
			map.maxExtent = Bounds.getBoundsFromString(config.@maxExtent);
			
			//add layers
			map.addLayers(layersFromMap);
		 	
		 	//add controls
		 	 for each (var control:XML in controls){
		 		map.addControl(parseControl(control));
		 	} 
		 	//add handlers
		 	for each (var handler:XML in handlers){
		 		map.addHandler(parseHandler(handler));
		 	}
			map.zoom = config.@zoom;
			map.center = new LonLat(config.@lon, config.@lat);	
		}
				
		public function set config(value:XML):void {
			this._config = value;
		}
		
		public function get config():XML {
			return this._config;
		}
		
		public function get layersFromMap():Array {
			//we search direclty all nodes contained in <Layers> </Layers>
			var layersNodes:XMLList = config.Layers.*;
			
			//the tab which contains layers to add
			var layers:Array = new Array ();
			
			if (layersNodes.length == 0) {
				trace("There's no layer on the map");return [];
			} 
			// Manage the different catalog in the file
			for each(var node:XML in layersNodes){
				var layer:Layer = this.parseLayer(node);
				//Add the layer if it's correct
				if(layer){layers.push(layer);}
			}							
			return layers;
		}
		
		public function get layersFromCatalog():Array {			
			if (this.catalog.length == 0) {
				trace("There's no layer on the catalog");return [];
			}
			
			var layersNodes:XMLList = config.Catalog..Category.*;
			var layers:Array = [];			 

			for each(var layerXml:XML in layersNodes)
			{
				if(layerXml.name() != "Category"){
					var layer:Layer = this.parseLayer(layerXml);
					if (layer) {
						layers.push(layer);
					}
				}
			}
			return layers;
		}
		
		public function get catalog():XMLList {
			var catalogNode:XMLList = config.*::Catalog.*;
			return catalogNode;
		}
		
		public function get custom():XMLList {
			var customNode:XMLList = config.*::Custom.*;
			return customNode;
		}
		
		public function get handlers():XMLList {
			var handlersNode:XMLList = config.Handlers.*;
			return handlersNode;
		}
		
		public function get controls():XMLList {
			var controlsNode:XMLList = config.*::Controls.*;
			return controlsNode;
		}
		
		public function parseLayer(xmlNode:XML):Layer {
			// The layer which will return
			var layer:Layer=null;
			
			//Loading params
			var isBaseLayer:Boolean;
			var visible:Boolean;		
			// parse params in boolean
			if(xmlNode.@isBaseLayer == "true"){isBaseLayer=true;}
			else{isBaseLayer=false;}
			if(xmlNode.@visible == "false"){visible=false;}
			else{visible = true;}
			
			var name:String=xmlNode.@name;
			
			var proxy:String=xmlNode.@proxy;
			
			var projection:String=xmlNode.@projection;
			
			var minResolution:Number= Number(xmlNode.@minResolution);
			
			var maxResolution:Number= Number(xmlNode.@maxResolution);
			
			// Case where the layer is WMS or WMSC
			if(xmlNode.name()== "WMSC" || xmlNode.name()== "WMS"){
				var type:String = xmlNode.name();
				
				//Params for layer			
				var urlWMS:String=xmlNode.@url;
				var paramsWms:WMSParams;
				
				//Params for WMSparams
				var lay:String=xmlNode.@layers; 
				var format:String=xmlNode.@format; 
				
				var transparent:Boolean;
				if(xmlNode.@transparent == "true"){transparent=true;}
				else{transparent = false;}
				
				var tiled:Boolean;
				if(xmlNode.@tiled == "true" || xmlNode.@tiled == ""){tiled=true;}
				else{tiled = false;}
				
				var styles:String=xmlNode.@styles; 
				var bgcolor:String=xmlNode.@bgcolor;
				
				paramsWms = new WMSParams(lay,format,transparent,tiled,styles,bgcolor);
				switch(type){
					case "WMSC":{
						Trace.info("Find WMSC Layer : " + xmlNode.name());						
						// We create the WMSC Layer with all params
						var wmscLayer:WMSC = new WMSC(name,urlWMS,paramsWms,isBaseLayer,visible,projection,proxy);
						wmscLayer.maxExtent = Bounds.getBoundsFromString(xmlNode.@maxExtent);
						wmscLayer.minResolution = minResolution;
						wmscLayer.maxResolution = maxResolution;
						layer=wmscLayer;
						break;
					}
						
					case "WMS":{
						Trace.info("Find WMS Layer : " + xmlNode.name());
						// We create the WMS Layer with all params
						var wmslayer:WMS = new WMS(name,urlWMS,paramsWms,isBaseLayer,visible,projection,proxy);
						wmslayer.maxExtent = Bounds.getBoundsFromString(xmlNode.@maxExtent);
						wmslayer.minResolution = minResolution; 
						wmslayer.maxResolution = maxResolution; 
						layer=wmslayer;
						break;
					}						
				}			
			}
			// Case when the layer is WFS	
			else if(xmlNode.name()== "WFS"){
				
				//params for layer
				var urlWfs:String=xmlNode.@url;
				var paramsWfs:WFSParams;
				
				//params for WFSParams
				var use110Capabilities:Boolean;
				if(xmlNode.@use110Capabilities == "true"){use110Capabilities=true;}
				else{use110Capabilities = false;}
				
				var useCapabilities:Boolean=xmlNode.@useCapabilities;
				if(xmlNode.@useCapabilities == "true"){useCapabilities=true;}
				else{useCapabilities = false;}
			
				var capabilities:HashMap;
				
				paramsWfs = new WFSParams(xmlNode.@typename);
				paramsWfs.srs = xmlNode.@projection;
				paramsWfs.version = xmlNode.@version;
				
				Trace.info("Find WFS Layer : " + xmlNode.name());
				
				// We create the WFS Layer with all params
				var wfsLayer:WFS = new WFS(name,urlWfs,paramsWfs,isBaseLayer, visible,projection,proxy,useCapabilities,capabilities);
				wfsLayer.minZoomLevel = Number(xmlNode.@minZoomLevel);
				wfsLayer.maxZoomLevel = Number(xmlNode.@maxZoomLevel);
				wfsLayer.use110Capabilities = use110Capabilities;
				wfsLayer.minResolution = minResolution;	
				wfsLayer.maxResolution = maxResolution;	
				layer=wfsLayer;
			}
			// Case when the layer is Mapnik
			else if(xmlNode.name()=="Mapnik"){
				Trace.info("Find Mapnik Layer : " + xmlNode.name());
				// We create the Mapnik Layer with all params
				var mapnik:Mapnik=new Mapnik("Mapnik", isBaseLayer); // a base layer
				mapnik.minResolution = xmlNode.@minResolution;
				mapnik.maxResolution = xmlNode.@maxResolution;
				mapnik.numZoomLevels = Number(xmlNode.@numZoomLevels);
				mapnik.maxExtent = Bounds.getBoundsFromString(xmlNode.@maxExtent);
				layer=mapnik;
			}
			// Case when the layer is unknown
			else{
				Trace.error("Layer unknown or not managed");
			}
			
			//Init layer parameters
			layer.alpha = Number(xmlNode.@opacity);
			return layer;
		}
		
		protected function parseHandler(xmlNode:XML):Handler {
			var handler:Handler;
			if(xmlNode.name() == "DragHandler"){handler = new DragHandler();}
			else if (xmlNode.name() == "WheelHandler"){handler = new WheelHandler();}
			else if (xmlNode.name() == "ClickHandler"){handler = new ClickHandler();}
			else if (xmlNode.name() == "BorderPanHandler"){handler = new BorderPanHandler();}
			else if (xmlNode.name() == "DragFeature"){handler = new DragFeature();}
			else if (xmlNode.name() == "SelectFeature"){handler = new SelectFeature();}
			else Trace.error("Handler unknown !");
			return handler;
		}
		
		protected function parseControl(xmlNode:XML):Control {
			var control:Control;
			if(xmlNode.name() == "LayerSwitcherComponent"){
				var layerSwitcher:LayerSwitcher = new LayerSwitcher();
				layerSwitcher.name = xmlNode.@id;
				layerSwitcher.x = xmlNode.@x;
				layerSwitcher.y = xmlNode.@y;
				control = layerSwitcher;
			}
			else if(xmlNode.name() == "PanComponent"){
				var pan:PanZoom = new PanZoom();
				pan.name = xmlNode.@id;
				pan.x = xmlNode.@x;
				pan.y = xmlNode.@y;
				control = pan;
			} 
			// need a class in openScales-FX
			/* else if(xmlNode.name() == "ZoomComponent"){
				var zoomComponent:Zoom = new Zoom();
				zoomComponent.name = xmlNode.@id;
				zoomComponent.x = xmlNode.@x;
				zoomComponent.y = xmlNode.@y;
				control = zoomComponent;
			} */
			// need a class in openScales-FX
			/* else if(xmlNode.name() == "ZoomBoxComponent"){
				var zoomBox:ZoomBox = new ZoomBox();
				zoomBox.name = xmlNode.@id;
				zoomBox.x = xmlNode.@x;
				zoomBox.y = xmlNode.@y;
				control = zoomBox;
			}	 */	
			else if(xmlNode.name() == "ScaleLine"){
				var scaleLine:ScaleLine = new ScaleLine();
				scaleLine.name = xmlNode.@id;
				scaleLine.x = xmlNode.@x;
				scaleLine.y = xmlNode.@y;
				control = scaleLine;
			}
			// need a class in openScales-FX	
			else if(xmlNode.name() == "MousePosition"){
				var mousePosition:MousePosition = new MousePosition();
				mousePosition.name = xmlNode.@id;
				mousePosition.x = xmlNode.@x;
				mousePosition.y = xmlNode.@y;
				mousePosition.displayProjection = xmlNode.@displayProjection;
				control = mousePosition;
			}
			return control;		
		}					
	}
}