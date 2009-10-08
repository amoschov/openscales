package org.openscales.fx.configuration
{
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
                              Trace.info("map.parent is null so does not add the control");
                          }
                        }
                  }                      
            }
		
		protected function parseFxControl(xmlNode:XML):Control {
		 	var control:Control = null;
		 					 					
	 		if(xmlNode.name() == "PanComponent"){
	 			var panZoom:Pan = new Pan();
	 			 control = panZoom; 
	 		}
	 			 		
			//FIX ME : the arrow is not update when you zoom IN (or OUT) with mouse wheel
	 		else if(xmlNode.name() == "ZoomComponent"){
	 			var zoom:Zoom = new Zoom();
	 			control = zoom;
	 		}
	 		
	 		else if(xmlNode.name() == "ZoomBox"){
	 			var zoomBox:ZoomBox = new ZoomBox();
	 			control = zoomBox; 
	 		}
	 		
			//FIX ME : because asynchrone, we need to wait the creation complete on FXMap before setting the map		 					
	 		else if(xmlNode.name() == "OverViewComponent"){
	 			var overView:OverviewMap = new OverviewMap();
	 			control = overView; 
	 		}  
	 		
			//FIX ME : because asynchrone, we need to wait the creation complete of the others flex component before setting the map		 					
	 		else if(xmlNode.name() == "LayerSwitcherComponent"){
	 			var layerSwitcher:LayerSwitcher = new LayerSwitcher();
	 			control = layerSwitcher;
				
	 		}  
		return control;
	 }
		
	}
}