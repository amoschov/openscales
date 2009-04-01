package org.openscales.core.control
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openscales.core.Map;
	import org.openscales.core.control.ui.CheckBox;
	import org.openscales.core.control.ui.RadioButton;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.layer.Layer;
	
	public class LayerSwitcher extends Control
	{
		
		private var _activeColor:uint = 0x00008B;
		private var _textColor:uint = 0xFFFFFF;
		private var _textOffset:int=20;
		
		private var _minimized:Boolean = true;
	    	    
	    private var _minimizeButton:Button = null;
	    
	    private var _maximizeButton:Button = null;
	    	    
	    [Embed(source="/org/openscales/core/img/layer-switcher-maximize.png")]
        private var _layerSwitcherMaximizeImg:Class;
        
       	[Embed(source="/org/openscales/core/img/layer-switcher-minimize.png")]
        private var _layerSwitcherMinimizeImg:Class;
        
        [Embed(source="/org/openscales/core/img/uncheck.png")]
        private var _layerSwitcherUncheckImg:Class;
        
        [Embed(source="/org/openscales/core/img/check.png")]
        private var _layerSwitchercheckImg:Class;
        
        [Embed(source="/org/openscales/core/img/radiobutton-noselected.png")]
        private var _layerSwitcherRadioButtonNoSelectedImg:Class;
        
        [Embed(source="/org/openscales/core/img/radiobutton-selected.png")]
        private var LayerSwitcherRadioButtonSelectedImg:Class;


		public function LayerSwitcher(options:Object = null):void {
			super(options);
			
			this._minimizeButton = new Button("minimize", new _layerSwitcherMinimizeImg(), this.position.add(-18,0));
			this._maximizeButton = new Button("maximize", new _layerSwitcherMaximizeImg(), this.position.add(-18,0));
			
			this._minimizeButton.addEventListener(MouseEvent.CLICK, minMaxButtonClick); 
			this._maximizeButton.addEventListener(MouseEvent.CLICK, minMaxButtonClick);
			 
		}
		
		override public function destroy():void {
		
			this._minimizeButton.removeEventListener(MouseEvent.CLICK, minMaxButtonClick);
			this._maximizeButton.removeEventListener(MouseEvent.CLICK, minMaxButtonClick);
	        this.map.removeEventListener(MapEvent.LAYER_ADDED, this.layerUpdated);
	        this.map.removeEventListener(MapEvent.LAYER_CHANGED, this.layerUpdated);
	        this.map.removeEventListener(MapEvent.LAYER_REMOVED, this.layerUpdated);
	        this.map.removeEventListener(MapEvent.BASE_LAYER_CHANGED, this.layerUpdated);
	        
	        
	        super.destroy();
		}
		
		override public function setMap(map:Map):void {
			super.setMap(map);

	        this.map.addEventListener(MapEvent.LAYER_ADDED, this.layerUpdated);
	        this.map.addEventListener(MapEvent.LAYER_CHANGED, this.layerUpdated);
	        this.map.addEventListener(MapEvent.LAYER_REMOVED, this.layerUpdated);
	        this.map.addEventListener(MapEvent.BASE_LAYER_CHANGED, this.layerUpdated);
		}
		
		override public function draw():void {
			super.draw();
			
			if(_minimized) {
				this.addChild(_maximizeButton);
			} else {
				this.graphics.beginFill(this._activeColor);
				this.graphics.drawRoundRectComplex(this.position.x-200,this.position.y,200,300, 20, 0, 20, 0);
				this.graphics.endFill();
				this.alpha = 0.7;
				
				var titleFormat:TextFormat = new TextFormat();
				titleFormat.bold = true;
				titleFormat.size = 11;
				titleFormat.color = this._textColor;
				titleFormat.font = "Verdana";
				
				var contentFormat:TextFormat = new TextFormat();
				contentFormat.size = 11;
				contentFormat.color = this._textColor;
				contentFormat.font = "Verdana";
				
				var y:int = this.position.y + 20;
				
				var baselayerTextField:TextField = new TextField();
				baselayerTextField.text="Base Layer";
				baselayerTextField.setTextFormat(titleFormat);
				baselayerTextField.x = this.position.x - 180;
				baselayerTextField.y = y;
				this.addChild(baselayerTextField);
				
				// Display baselayers
				for(var i:int=0;i<this.map.layers.length;i++) {
					var layer:Layer = this.map.layers[i] as Layer;
					if(layer.isBaseLayer==true) {
						y+=this._textOffset;
						var radioButton:RadioButton;
						if(i == 0)
						{
							radioButton = new RadioButton(this.position.add(-185,y+2),layer.name,true);							
						}
						else
						{
							radioButton = new RadioButton(this.position.add(-185,y+2),layer.name,false);
						}
						radioButton.width = 13;
						radioButton.height = 13;
						radioButton.addEventListener(MouseEvent.CLICK,RadioButtonClick);
						var layerTextField:TextField = new TextField();
						layerTextField.text=layer.name;
						layerTextField.setTextFormat(contentFormat);
						layerTextField.x = this.position.x - 170;
						layerTextField.y = y;
						this.addChild(radioButton);
						this.addChild(layerTextField);
					}
				}
				
				y+=this._textOffset;
				var overlayTextField:TextField = new TextField();
				overlayTextField.text="Overlays";
				overlayTextField.setTextFormat(titleFormat);
				overlayTextField.x = this.position.x - 180;
				overlayTextField.y = y;
				this.addChild(overlayTextField);
				
				// Display overlays
				for(i=0;i<this.map.layers.length;i++) {
					layer = this.map.layers[i] as Layer;
					if(layer.isBaseLayer==false) {
						y+=this._textOffset;
						layerTextField = new TextField();
						layerTextField.text=layer.name;
						layerTextField.setTextFormat(contentFormat);
						layerTextField.x = this.position.x - 170;
						layerTextField.y = y;
						var check:CheckBox = new CheckBox(this.position.add(-185,y+2),layer.name);
						
						check.width=12;
						check.height=12;
						check.addEventListener(MouseEvent.CLICK,CheckButtonClick);			
						this.addChild(check);
						this.addChild(layerTextField);
					}
				}
			
				this.addChild(_minimizeButton);
			}
		}
		
		private function layerUpdated(event:Event):void {
			this.draw();
		}
		
		private function minMaxButtonClick(event:MouseEvent):void {
			this._minimized = !this._minimized;
			this.draw();
		}
		
		private function CheckButtonClick(event:MouseEvent):void
		{
			var i:int = 0;
			var layer2:Layer = this.map.getLayerByName((event.target as CheckBox).layerName);
			if((event.target as CheckBox).status == true)
			{
				(event.target as CheckBox).status = false;
				layer2.visible = false;
			}
			else
			{
				(event.target as CheckBox).status = true;
				layer2.visible = true;
			}
		}
		
		private function RadioButtonClick(event:MouseEvent):void
		{
			var i:int = 0;
			var layer2:Layer = this.map.getLayerByName((event.target as RadioButton).layerName);
			if((event.target as RadioButton).status == true)
			{
				(event.target as RadioButton).status = false;
				layer2.visible = false;
			}
			else
			{
				(event.target as RadioButton).status = true;
				layer2.visible = true;
			}
		}

		
		
	}
}