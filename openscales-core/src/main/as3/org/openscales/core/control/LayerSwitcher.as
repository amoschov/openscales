package org.openscales.core.control
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openscales.core.Map;
	import org.openscales.core.control.ui.CheckBox;
	import org.openscales.core.control.ui.RadioButton;
	import org.openscales.core.control.ui.SliderHorizontal;
	import org.openscales.core.control.ui.SliderVertical;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.layer.Layer;
	
	public class LayerSwitcher extends Control
	{
		
		private var _activeColor:uint = 0x00008B;
		private var _textColor:uint = 0xFFFFFF;
		private var _textOffset:int=35;
		
		private var _minimized:Boolean = true;
	    	    
	    private var _minimizeButton:Button = null;
	    
	    private var _maximizeButton:Button = null;
	    
	    private var _oldMouseX:int = 0;
	    
	    private var _slideHorizontalTemp:SliderHorizontal = null;
	    
	    private var _slideVerticalTemp:SliderVertical = null;
	    
	    private var _percentageTextFieldTemp:TextField = null;
	    	    
	    [Embed(source="/org/openscales/core/img/layer-switcher-maximize.png")]
        private var _layerSwitcherMaximizeImg:Class;
        
       	[Embed(source="/org/openscales/core/img/layer-switcher-minimize.png")]
        private var _layerSwitcherMinimizeImg:Class;
        
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
						var radioButton:RadioButton;
						if(i == 0)
						{
							y+=this._textOffset-15;
							radioButton = new RadioButton(this.position.add(-185,y+2),layer.name,true);							
						}
						else
						{
							y+=this._textOffset;
							radioButton = new RadioButton(this.position.add(-185,y+2),layer.name,false);
						}
						radioButton.width = 13;
						radioButton.height = 13;
						radioButton.addEventListener(MouseEvent.CLICK,RadioButtonClick);
						var slideHorizontalButtonBL:SliderHorizontal = new SliderHorizontal("slide horizontal"+i,this.position.add(-130,y+19),layer.name);
						var slideVerticalButtonBL:SliderVertical = new SliderVertical("slide vertical"+i,this.position.add(-55,y+21),layer.name);
						slideVerticalButtonBL.width = 5;
						slideVerticalButtonBL.addEventListener(MouseEvent.MOUSE_DOWN,SlideMouseClick);
						var layerTextField:TextField = new TextField();
						layerTextField.text=layer.name;
						layerTextField.setTextFormat(contentFormat);
						layerTextField.x = this.position.x - 170;
						layerTextField.y = y;
						layerTextField.height = 20;
						layerTextField.width = 120;
						var percentageTextFieldBL:TextField = new TextField();
						percentageTextFieldBL.name = "percentage"+i;
						percentageTextFieldBL.text="100%";
						percentageTextFieldBL.setTextFormat(contentFormat);
						percentageTextFieldBL.x = this.position.x - 45;
						percentageTextFieldBL.y = y+18;
						percentageTextFieldBL.height = 20;
						percentageTextFieldBL.width = 50;
						this.addChild(slideHorizontalButtonBL);
						this.addChild(slideVerticalButtonBL);
						this.addChild(radioButton);
						this.addChild(layerTextField);
						this.addChild(percentageTextFieldBL);
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
						if(i == 1)
						{
							y+=this._textOffset-15;
						}
						else
						{
							y+=this._textOffset;
						}
						layerTextField = new TextField();
						layerTextField.text=layer.name;
						layerTextField.setTextFormat(contentFormat);
						layerTextField.x = this.position.x - 170;
						layerTextField.y = y;
						layerTextField.height = 20;
						layerTextField.width = 120;
						var slideHorizontalButtonO:SliderHorizontal = new SliderHorizontal("slide horizontal"+i,this.position.add(-130,y+23),layer.name);
						var slideVerticalButtonO:SliderVertical = new SliderVertical("slide vertical"+i,this.position.add(-55,y+26),layer.name);
						slideVerticalButtonO.width = 5;
						slideVerticalButtonO.addEventListener(MouseEvent.MOUSE_DOWN,SlideMouseClick);
						var check:CheckBox = new CheckBox(this.position.add(-185,y+2),layer.name);
						check.width=12;
						check.height=12;
						check.addEventListener(MouseEvent.CLICK,CheckButtonClick);	
						var percentageTextField:TextField = new TextField();
						percentageTextField.name = "percentage"+i;
						percentageTextField.text="100%";
						percentageTextField.setTextFormat(contentFormat);
						percentageTextField.x = this.position.x - 45;
						percentageTextField.y = y+22;
						percentageTextField.height = 20;
						percentageTextField.width = 50;
						this.addChild(slideHorizontalButtonO);	
						this.addChild(slideVerticalButtonO);	
						this.addChild(check);
						this.addChild(layerTextField);
						this.addChild(percentageTextField);
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
		
		private function SlideMouseClick(event:MouseEvent):void
		{		
			var childIndex:String = (event.target as Button).name;
			childIndex = childIndex.substring(14,15);
		
			_slideVerticalTemp = (event.target as SliderVertical);
			_slideHorizontalTemp = (this.getChildByName("slide horizontal"+childIndex)) as SliderHorizontal;
						
			_slideHorizontalTemp.addEventListener(MouseEvent.MOUSE_MOVE,SlideMouseMove);
			this.map.addEventListener(MouseEvent.MOUSE_UP,SlideMouseUp);
			
			// Stop propagation in order to avoid map move
			event.stopPropagation();
				
		}
		
		private function SlideMouseMove(event:MouseEvent):void
		{			
			var k:int = _slideHorizontalTemp.x+1;
			var l:int = k+(_slideHorizontalTemp.width)-1;
			_slideVerticalTemp.x = mouseX;
			var resultAlpha:Number = (mouseX/(l-k)) - (k/(l-k))
			var resultPercentage:int = resultAlpha*100;
			var layer2:Layer = this.map.getLayerByName(_slideVerticalTemp.layerName);
			layer2.alpha = resultAlpha;
			
			var childIndex:String = _slideVerticalTemp.name;
			childIndex = childIndex.substring(14,15);
			_percentageTextFieldTemp = this.getChildByName("percentage"+childIndex) as TextField;
			_percentageTextFieldTemp.textColor = 0xffffff;
			_percentageTextFieldTemp.text = resultPercentage.toString()+"%";
			
			
			// Stop propagation in order to avoid map move
			event.stopPropagation();
		
				
		}
		private function SlideMouseUp(event:MouseEvent):void
		{
			_slideHorizontalTemp.removeEventListener(MouseEvent.MOUSE_MOVE,SlideMouseMove);
			this.map.removeEventListener(MouseEvent.MOUSE_UP,SlideMouseUp);
		}
	
	}
}