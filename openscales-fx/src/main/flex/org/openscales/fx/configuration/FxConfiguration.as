package org.openscales.fx.configuration
{
	import mx.containers.Canvas;
	import mx.containers.Panel;
	
	import org.openscales.component.control.Control;
	import org.openscales.component.control.OverviewMap;
	import org.openscales.component.control.Pan;
	import org.openscales.component.control.Zoom;
	import org.openscales.component.control.ZoomBox;
	import org.openscales.component.control.layer.LayerSwitcher;
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.configuration.Configuration;

	public class FxConfiguration extends Configuration
	{
		
		public function FxConfiguration(config:XML=null)
		{
			super(config);
		}
		
		override public function configureMap(map:Map):void {
                  super.configureMap(map);
                  this.middleFxConfigureMap(map);
                  
        }
            
          public function middleFxConfigureMap(map:Map):void {
           
                  //add controls
                  for each (var xmlControl:XML in controls){
                        var control:Control = parseFxControl(xmlControl);
                        if(control != null){
                          control.map = map;
                          if(map.parent != null) {
                              map.parent.addChild(control);
                          } else {
                              Trace.log("map.parent is null so does not add the control");
                          } 
                        }
                  }                      
            }
		
		protected function parseFxControl(xmlNode:XML):Control {
		 	var control:Control = null;
		 					 					
	 		if(xmlNode.name() == "PanComponent"){
	 			var panZoom:Pan = new Pan();
	 			if(String(xmlNode.@id) != ""){
	 				panZoom.id = String(xmlNode.@id);
	 			}	 			
	 			if(String(xmlNode.@x) != ""){
	 				panZoom.x = Number(xmlNode.@x);
	 			}
	 			if(String(xmlNode.@y) != ""){
	 				panZoom.y = Number(xmlNode.@y);
	 			}
	 			if(String(xmlNode.@width) != ""){
	 				panZoom.width = Number(xmlNode.@width);
	 			}
	 			if(String(xmlNode.@height) != ""){
	 				panZoom.height = Number(xmlNode.@height);
	 			}
	 			control = panZoom;  
	 		}
	 			 		
	 		else if(xmlNode.name() == "ZoomComponent"){
	 			var zoom:Zoom = new Zoom();
	 			if(String(xmlNode.@id) != ""){
	 				zoom.id = String(xmlNode.@id);
	 			}
	 			if(String(xmlNode.@x) != ""){
	 				zoom.x = Number(xmlNode.@x);
	 			}
	 			if(String(xmlNode.@y) != ""){
	 				zoom.y = Number(xmlNode.@y);
	 			}
	 			if(String(xmlNode.@width) != ""){
	 				zoom.width = Number(xmlNode.@width);
	 			}
	 			if(String(xmlNode.@height) != ""){
	 				zoom.height = Number(xmlNode.@height);
	 			}
	 			control = zoom;
	 		}
	 		
	 		else if(xmlNode.name() == "ZoomBox"){
	 			var zoomBox:ZoomBox = new ZoomBox();
	 			if(String(xmlNode.@id) != ""){
	 				zoomBox.id = String(xmlNode.@id);
	 			}
	 			if(String(xmlNode.@x) != ""){
	 				zoomBox.x = Number(xmlNode.@x);
	 			}
	 			if(String(xmlNode.@y) != ""){
	 				zoomBox.y = Number(xmlNode.@y);
	 			}
	 			if(String(xmlNode.@width) != ""){
	 				zoomBox.width = Number(xmlNode.@width);
	 			}
	 			if(String(xmlNode.@height) != ""){
	 				zoomBox.height = Number(xmlNode.@height);
	 			}
	 			control = zoomBox; 
	 		}
	 		
			//FIX ME : because asynchrone, we need to wait the creation complete on FXMap before setting the map		 					
	 		else if(xmlNode.name() == "OverViewComponent"){
	 			var overView:OverviewMap = new OverviewMap();
	 			if(String(xmlNode.@id) != ""){
	 				overView.id = String(xmlNode.@id);
	 			}
	 			if(String(xmlNode.@x) != ""){
	 				overView.x = Number(xmlNode.@x);
	 			}
	 			if(String(xmlNode.@y) != ""){
	 				overView.y = Number(xmlNode.@y);
	 			}
	 			if(String(xmlNode.@width) != ""){
	 				overView.width = Number(xmlNode.@width);
	 			}
	 			if(String(xmlNode.@height) != ""){
	 				overView.height = Number(xmlNode.@height);
	 			}
	 			control = overView; 
	 		}  
	 		
			//FIX ME : because asynchrone, we need to wait the creation complete of the others flex component before setting the map		 					
	 		else if(xmlNode.name() == "LayerSwitcherComponent"){
	 			var layerSwitcher:LayerSwitcher = new LayerSwitcher();
	 			if(String(xmlNode.@id) != ""){
	 				layerSwitcher.id = String(xmlNode.@id);
	 			}
	 			if(String(xmlNode.@x) != ""){
	 				layerSwitcher.x = Number(xmlNode.@x);
	 			}
	 			if(String(xmlNode.@y) != ""){
	 				layerSwitcher.y = Number(xmlNode.@y);
	 			}
	 			if(String(xmlNode.@width) != ""){
	 				layerSwitcher.width = Number(xmlNode.@width);
	 			}
	 			if(String(xmlNode.@height) != ""){
	 				layerSwitcher.height = Number(xmlNode.@height);
	 			}
	 			control = layerSwitcher;
				
	 		}  
		return control;
	 }
		
	}
}