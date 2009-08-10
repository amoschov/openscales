package org.openscales.component.control.layer
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.controls.CheckBox;
	import mx.controls.Tree;
	import mx.controls.treeClasses.TreeItemRenderer;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.layer.Layer;

	public class Catalog extends TreeItemRenderer
	{
		
		private var _map:Map;
		private var checkBox:CheckBox = new CheckBox();
		
		public function Catalog()
		{
			super();
		}
		
		public function set map(value:Map):void {
				this._map = value;
		}
		
		override public function set data(value:Object):void 
		{
       		super.data = value;
       		
       		this._map.addEventListener(LayerEvent.LAYER_ADDED,changeStateLayer);
			this._map.addEventListener(LayerEvent.LAYER_REMOVED,changeStateLayer);
             
     		 if(this.data is Layer)
     		{                 
				var layer:Layer = data as Layer;

		       	
		     	checkBox.id = layer.name;
		     	checkBox.name = layer.name;
		    	 checkBox.x = 10; 
		     	checkBox.y = 9; 
		     	checkBox.label = layer.name;
		     	checkBox.addEventListener(MouseEvent.CLICK,addLayerInMap);
		     	//Check if the layer is in the map
		     	for (var i:int=0;i<this._map.layers.length;i++)
		     	{
		     		if(this._map.layers[i].name == checkBox.name)
		     		{
		     			checkBox.selected = true;
		     		}
		     	}
		     	this.addChild(checkBox);
          	}    
            
          }
          
          /**
          * Change the state of the layer
          * 
          * @param event a Layer event
          */
          public function changeStateLayer(event:LayerEvent):void {
			  	 var check:CheckBox = this.getChildByName(event.layer.name) as CheckBox;
			  	 if(check != null)
			  	 {
			  	 	if(event.type == LayerEvent.LAYER_REMOVED)
			  	 	{
			  	 		check.selected = false;	
			  	 	}
			  	 	if(event.type == LayerEvent.LAYER_ADDED)
			  	 	{
			  	 		check.selected = true;	
			  	 	}
			  	 }
			  }
			  
			/**
          * Add or remove a layer existing or not in the layer switcher
          * in function of the state of the checbox
          * 
          * @param event a Layer event
          */  
		public function addLayerInMap(event:MouseEvent):void 
		{
			  var check:CheckBox = event.target as CheckBox;
			 if(check != null)
			 {
			 	if(check.selected == true)
			 	{
			 		this._map.addLayer(data as Layer);
			 	}
			 	else
			 	{
			 		this._map.removeLayer(this._map.getLayerByName((this.data as Layer).name));
			 	}
			 } 	  		
		}	
		
	}
}