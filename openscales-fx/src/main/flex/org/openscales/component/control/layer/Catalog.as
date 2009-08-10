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
		private var checkBox;
		
		public function Catalog()
		{
			super();
		}
		
		public function set map(value:Map):void {
				this._map = value;		
				this._map.addEventListener(LayerEvent.LAYER_ADDED,changeStateLayer);
				this._map.addEventListener(LayerEvent.LAYER_REMOVED,changeStateLayer);	
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			checkBox = new CheckBox();
			checkBox.setStyle( "verticalAlign", "middle" );
			checkBox.addEventListener( MouseEvent.CLICK, addLayerInMap );
			addChild(checkBox);		
	    }
	    
	    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	   {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
	        if(super.data)
	        {
			    if (super.icon != null)
			    {
				    if(data is Layer)
				    {
				    	super.label.text = (data as Layer).name;
				    	checkBox.name = (data as Layer).name;
				    	 for (var i:int=0;i<this._map.layers.length;i++)
				     	{
				     		if(this._map.layers[i].name == (data as Layer).name)
				     		{
				     			checkBox.selected = true;
				     		}
				     	}
				     	checkBox.x = super.icon.x;
				    	checkBox.y = 9;
				    	super.icon.x = checkBox.x + checkBox.width + 17;
				    }
				    else
				    {
				    	checkBox.enabled = false;
				    	checkBox.visible = false;
				    }	    
				    super.label.x = super.icon.x + super.icon.width + 3;
				}
				else
			    {
				    checkBox.x = super.label.x;
				    checkBox.y = 50;
				    super.label.x = checkBox.x + checkBox.width + 17;
				}
			}
	    }
          
          /**
          * Change the state of the layer
          * 
          * @param event a Layer event
          */
          public function changeStateLayer(event:LayerEvent):void {
			  	 if(checkBox != null)
			  	 {
			  	 	if(event.type == LayerEvent.LAYER_REMOVED)
			  	 	{
			  	 		checkBox.selected = false;	
			  	 	}
			  	 	if(event.type == LayerEvent.LAYER_ADDED)
			  	 	{
			  	 		checkBox.selected = true;	
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