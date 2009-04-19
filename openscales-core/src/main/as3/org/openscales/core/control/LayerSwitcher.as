package org.openscales.core.control
{
	import com.gskinner.motion.GTweeny;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openscales.core.Map;
	import org.openscales.core.control.ui.Arrow;
	import org.openscales.core.control.ui.Button;
	import org.openscales.core.control.ui.CheckBox;
	import org.openscales.core.control.ui.RadioButton;
	import org.openscales.core.control.ui.SliderHorizontal;
	import org.openscales.core.control.ui.SliderVertical;
	import org.openscales.core.events.LayerEvent;
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
	    
	    private var _layerSwitcherState:String;
	    	    
	    [Embed(source="/org/openscales/core/img/layer-switcher-maximize.png")]
        private var _layerSwitcherMaximizeImg:Class;
        
       	[Embed(source="/org/openscales/core/img/layer-switcher-minimize.png")]
        private var _layerSwitcherMinimizeImg:Class;
        
		public function LayerSwitcher(options:Object = null):void {
			super(options);
			
			this._minimizeButton = new Button("minimize", new _layerSwitcherMinimizeImg(), this.position.add(-18,0));
			this._maximizeButton = new Button("maximize", new _layerSwitcherMaximizeImg(), this.position.add(-18,0));
		}
		
		override public function destroy():void {
		
			this._minimizeButton.removeEventListener(MouseEvent.CLICK, minMaxButtonClick);
			this._maximizeButton.removeEventListener(MouseEvent.CLICK, minMaxButtonClick);
	        this.map.removeEventListener(LayerEvent.LAYER_ADDED, this.layerUpdated);
	        this.map.removeEventListener(LayerEvent.LAYER_CHANGED, this.layerUpdated);
	        this.map.removeEventListener(LayerEvent.LAYER_REMOVED, this.layerUpdated);
	        this.map.removeEventListener(LayerEvent.BASE_LAYER_CHANGED, this.layerUpdated);
	        
	        super.destroy();
		}
		
		override public function resize(event:MapEvent):void {
			this.x = this.map.size.w/2;
			this.y = 0;
			
			super.resize(event);
		}
		
		override public function set map(map:Map):void {
			super.map = map;
			
			this.x = this.map.size.w/2;
			this.y = 0;
			
			this._minimizeButton.addEventListener(MouseEvent.CLICK, minMaxButtonClick); 
			this._maximizeButton.addEventListener(MouseEvent.CLICK, minMaxButtonClick);
			 

	        this.map.addEventListener(LayerEvent.LAYER_ADDED, this.layerUpdated);
	        this.map.addEventListener(LayerEvent.LAYER_CHANGED, this.layerUpdated);
	        this.map.addEventListener(LayerEvent.LAYER_REMOVED, this.layerUpdated);
	        this.map.addEventListener(LayerEvent.BASE_LAYER_CHANGED, this.layerUpdated);
		}
		
		override public function draw():void {
			super.draw();
			
			this._minimizeButton.x = this.position.add(-18,0).x;
			this._minimizeButton.y = this.position.add(-18,0).y;
			
			this._maximizeButton.x = this.position.add(-18,0).x;
			this._maximizeButton.y = this.position.add(-18,0).y;
			
			if(_minimized) {
				this.addChild(_maximizeButton);
				this.alpha = 0.7
				this._layerSwitcherState = "Close";
						
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
				
				var k:int;
				var l:int;
				var resultPercentage:int;
				var positionX:Number
				
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
						radioButton.status = layer.visible;					

						radioButton.width = 13;
						radioButton.height = 13;
						radioButton.addEventListener(MouseEvent.CLICK,RadioButtonClick);
						
						var percentageTextFieldBL:TextField = new TextField();
						percentageTextFieldBL.name = "percentage"+i;
						percentageTextFieldBL.setTextFormat(contentFormat);
						percentageTextFieldBL.x = this.position.x - 45;
						percentageTextFieldBL.y = y+18;
						percentageTextFieldBL.height = 20;
						percentageTextFieldBL.width = 50;
						
						var slideHorizontalButtonBL:SliderHorizontal = new SliderHorizontal("slide horizontal"+i,this.position.add(-130,y+23),layer.name);
						var slideVerticalButtonBL:SliderVertical = new SliderVertical("slide vertical"+i,this.position.add(-55,y+26),layer.name);
						
						if(layer.alpha == 1)
						{
							percentageTextFieldBL.text="100%";
						}
						else
						{
							k = slideHorizontalButtonBL.x+1;
							l = k+(slideHorizontalButtonBL.width)-1;					
							positionX = ((l-k)*(layer.alpha)) + k;
							resultPercentage = (layer.alpha)*100;

							slideVerticalButtonBL.x = positionX;
							percentageTextFieldBL.text=resultPercentage.toString()+"%";
						}
						slideVerticalButtonBL.width = 5;
						percentageTextFieldBL.textColor = 0xffffff;
						slideVerticalButtonBL.addEventListener(MouseEvent.MOUSE_DOWN,SlideMouseClick);
						slideHorizontalButtonBL.addEventListener(MouseEvent.CLICK,SlideHorizontalClick);
						
						var layerTextField:TextField = new TextField();
						layerTextField.text=layer.name;
						layerTextField.setTextFormat(contentFormat);
						layerTextField.x = this.position.x - 170;
						layerTextField.y = y;
						layerTextField.height = 20;
						layerTextField.width = 120;
						
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
				overlayTextField.width = 80;
				overlayTextField.height = 50;
				this.addChild(overlayTextField);
				
				// Display overlays				
				var layerArray:Array = this.map.layers;
				
				 for(i=0;i<layerArray.length;i++) {
					layer = layerArray[i] as Layer;
					if(layer.isBaseLayer==false) {
						if(i == 1)
						{
							y+=this._textOffset-15;
						}
						else
						{
							y+=this._textOffset+5;
						}
						layerTextField = new TextField();
						layerTextField.text=layer.name;
						layerTextField.setTextFormat(contentFormat);
						layerTextField.x = this.position.x - 170;
						layerTextField.y = y;
						layerTextField.height = 20;
						layerTextField.width = 120;
						
						var percentageTextField:TextField = new TextField();
						percentageTextField.name = "percentage"+i;
						percentageTextField.setTextFormat(contentFormat);
						percentageTextField.x = this.position.x - 45;
						percentageTextField.y = y+22;
						percentageTextField.height = 20;
						percentageTextField.width = 50;
						
						var slideHorizontalButtonO:SliderHorizontal = new SliderHorizontal("slide horizontal"+i,this.position.add(-130,y+23),layer.name);
						var slideVerticalButtonO:SliderVertical = new SliderVertical("slide vertical"+i,this.position.add(-55,y+26),layer.name);
						
						if(layer.alpha == 1)
						{
							percentageTextField.text="100%";							
						}
						else
						{
							k = slideHorizontalButtonO.x+1;
							l = k+(slideHorizontalButtonO.width)-1;					
							positionX = ((l-k)*(layer.alpha)) + k;
							resultPercentage = (layer.alpha)*100;

							slideVerticalButtonO.x = positionX;
							percentageTextField.text=resultPercentage.toString()+"%";
						}
						slideVerticalButtonO.width = 5;
						percentageTextField.textColor = 0xffffff;
						slideVerticalButtonO.addEventListener(MouseEvent.MOUSE_DOWN,SlideMouseClick);
						slideHorizontalButtonO.addEventListener(MouseEvent.CLICK,SlideHorizontalClick);
						
						var check:CheckBox = new CheckBox(this.position.add(-185,y+2),layer.name);
						if(layer.visible == false)
						{							
							check.status = false;					
						}
						check.width=12;
						check.height=12;
						check.addEventListener(MouseEvent.CLICK,CheckButtonClick);	
						
						var arrowUpO:Arrow = new Arrow(this.position.add(-175,y+23),layer.name,"UP")
						var arrowDownO:Arrow = new Arrow(this.position.add(-174,y+31),layer.name,"DOWN")
						arrowUpO.height=7;
						arrowDownO.height=7;
						arrowUpO.addEventListener(MouseEvent.CLICK,ArrowClick);
						arrowDownO.addEventListener(MouseEvent.CLICK,ArrowClick);
						
						
						this.addChild(slideHorizontalButtonO);	
						this.addChild(slideVerticalButtonO);	
						this.addChild(check);
						this.addChild(layerTextField);
						this.addChild(percentageTextField);
						this.addChild(arrowUpO);
						this.addChild(arrowDownO);
						
					}
				} 
				if(this._layerSwitcherState == "Close")
				{
					this.alpha = 0;
					var tween:GTweeny = new GTweeny(this,0.5,{alpha:0.7});
					this._layerSwitcherState = "Open";
				}
				
				this.addEventListener(MouseEvent.MOUSE_DOWN,layerswitcherStopPropagation);
				this.addChild(_minimizeButton);
			}
			
		}
		
		private function layerUpdated(event:LayerEvent):void {
			this.draw();
		}
		
		private function minMaxButtonClick(event:MouseEvent):void 
		{
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
			if((event.target as RadioButton).status == false)
			{
				// Hide current baselayer
				this.map.baseLayer.visible = false;
				
				// Reset other radio buttons
				for(i=0; i < this.numChildren; i++) {
					var child:DisplayObject = this.getChildAt(i);
					if (child is RadioButton)
						(child as RadioButton).status = false; 
				}
				
				this.map.baseLayer = layer2;
				layer2.visible = true;
				(event.target as RadioButton).status = true;
				
			}
		}
		
		private function SlideHorizontalClick(event:MouseEvent):void
		{					
			var childIndex:String = (event.target as Button).name;
			childIndex = childIndex.substring(16,17);
			
			 _slideHorizontalTemp = (event.target as SliderHorizontal);
			_slideVerticalTemp = (this.getChildByName("slide vertical"+childIndex)) as SliderVertical;
			
			var k:int = _slideHorizontalTemp.x+1;
			var l:int = k+(_slideHorizontalTemp.width)-1;
			_slideVerticalTemp.x = mouseX;
			var resultAlpha:Number = (mouseX/(l-k)) - (k/(l-k))
			var resultPercentage:int = resultAlpha*100;
			var layer2:Layer = this.map.getLayerByName(_slideVerticalTemp.layerName);
			layer2.alpha = resultAlpha;
			
			_percentageTextFieldTemp = this.getChildByName("percentage"+childIndex) as TextField;
			_percentageTextFieldTemp.textColor = 0xffffff;
			_percentageTextFieldTemp.text = resultPercentage.toString()+"%";
			
			// Stop propagation in order to avoid map move
			event.stopPropagation();
				
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
		
		private function ArrowClick(event:MouseEvent):void
		{
			var layer:Layer = this.map.getLayerByName((event.target as Arrow).layerName);
			var numLayers:int = this.map.layers.length;
			
			if((event.target as Arrow).state == "UP")
			{
				if((layer.zindex-1)>=1)
				{
					layer.zindex = layer.zindex-1;
					this.draw();
				}	
			}
			else
			{
				if((layer.zindex+1)<=numLayers-1)
				{
					layer.zindex = layer.zindex+1;
					this.draw();
				}	
			}
		}
		
		private function layerswitcherStopPropagation(event:MouseEvent):void
		{
			event.stopPropagation();
		}
	
	}
}