package org.openscales.fx.configuration
{
	import org.openscales.component.control.Control;
	import org.openscales.component.control.OverviewMap;
	import org.openscales.component.control.Pan;
	import org.openscales.component.control.Zoom;
	import org.openscales.component.control.ZoomBox;
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
			
			//add controls
		 	for each (var xmlControl:XML in controls){
		 		var control:Control = parseFxControl(xmlControl);
		 		control.map = map;
		 		if(map.parent != null) {
		 			map.parent.addChild(control);
		 		} else {
		 			Trace.info("map.parent is null so does not add the control");
		 		}
		 	}
		}
		
		protected function parseFxControl(xmlNode:XML):Control {
		 	var control:Control = null;
		 					 					
	 		//Works well
	 		if(xmlNode.name() == "PanComponent"){
	 			var panZoom:Pan = new Pan();
	 			 control = panZoom; 
	 		}
	 			 		
			//FIX ME : because asynchrone, we need to wait the creation complete of the others flex component before setting the map
	 		else if(xmlNode.name() == "ZoomComponent"){
	 			var zoom:Zoom = new Zoom();
	 			control = zoom;
	 		}
	 		
	 		//Works well
	 		else if(xmlNode.name() == "ZoomBox"){
	 			var zoomBox:ZoomBox = new ZoomBox();
	 			control = zoomBox; 
	 		}
	 		
			//FIX ME : because asynchrone, we need to wait the creation complete on FXMap before setting the map		 					
	 		else if(xmlNode.name() == "OverViewComponent"){
	 			var overView:OverviewMap = new OverviewMap();
	 			control = overView; 
	 		} 
	 		
	 		// Not implement yet
	 		/* else if(xmlNode.name() == "HandComponent"){
	 			var hanComponent:hanComponent = new hanComponent();
	 			map.addControl(hanComponent);
	 		} */
	 		
			// FIX ME : The zoom is not correctly set, and center doesn't work
	 		 /* else if(xmlNode.name() == "StartPositionComponent"){
	 			var startPosition:FirstZoomPosition = new FirstZoomPosition();
	 			startPosition.map = map;
	 			mapContainer.addChild(startPosition);
	 		}  */
	 		
	 		// Not implement yet
	 		/* else if(xmlNode.name() == "InformationsComponent"){
	 			var InformationsComponent:InformationsComponent = new InformationsComponent();
	 			map.addControl(InformationsComponent);
	 		} */
	 		
	 		// Not implement yet
	 		/* else if(xmlNode.name() == "SelectDeselectComponent"){
	 			var SelectDeselectComponent:SelectDeselectComponent = new SelectDeselectComponent();
	 			map.addControl(SelectDeselectComponent);
	 		} */
	 		
			// FIX ME : need to create a flex component for the scaline. When it's done, uncomment the 2 lines and remove map.addControl(...);		 					
	 		/* else if(xmlNode.name() == "ScaleLine"){
	 			var scaleLine:ScaleLine = new ScaleLine();
	 			map.addControl(scaleLine);
	 			/* scaleLine.map = map;
	 			mapContainer.addChild(scaleLine);
	 		}  */
	 		
	 		//Not implement yet
	 		/* else if(xmlNode.name() == "MousePositionComponent"){
	 			var MousePositionComponent:MousePositionComponent = new MousePositionComponent();
	 			map.addControl(MousePositionComponent);
	 		} */
	 		
			//FIX ME : because asynchrone, we need to wait the creation complete of the others flex component before setting the map		 					
	 		/* else if(xmlNode.name() == "LayerSwitcher"){
	 			var layerSwitcher:LayerSwitcher = new LayerSwitcher();
	 			layerSwitcher.map = map;
	 			mapContainer.addChild(layerSwitcher);
				
	 		}  */
	 		
	 		// Dynamic control
	 		
	 		//Not implement yet
	 		/* else if(xmlNode.name() == "FinishCancel"){
	 			var finishCancel:FinishCancel = new FinishCancel();
	 			finishCancel.map = map;
	 			mapContainer.addChild(finishCancel);
	 		}*/
	 		
	 		//Not implement yet
	 		/* else if(xmlNode.name() == "EditErase"){
	 			var editErase:EditErase = new EditErase();
	 			editErase.map = map;
	 			mapContainer.addChild(editErase);
	 		} */
	 		
	 		//Not implement yet
	 		/* else if(xmlNode.name() == "Liaison"){
	 			var liaison:Liaison = new Liaison();
	 			liaison.map = map;
	 			mapContainer.addChild(liaison);
	 		} */
		return control;
	 }
		
	}
}