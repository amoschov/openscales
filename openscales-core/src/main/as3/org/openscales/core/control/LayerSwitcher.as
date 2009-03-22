package org.openscales.core.control
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openscales.core.Control;
	import org.openscales.core.Layer;
	import org.openscales.core.Map;
	import org.openscales.core.event.OpenScalesEvent;
	
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

		public function LayerSwitcher(options:Object = null):void {
			super(options);
			
			this._minimizeButton = new Button("minimize", new _layerSwitcherMinimizeImg(), this.position.add(-18,0));
			this._maximizeButton = new Button("maximize", new _layerSwitcherMaximizeImg(), this.position.add(-18,0));
			
			this._minimizeButton.addEventListener(MouseEvent.CLICK, minMaxButtonClick); 
			this._maximizeButton.addEventListener(MouseEvent.CLICK, minMaxButtonClick);
			 
		}
		
		override public function destroy():void {
			OpenScalesEvent.stopObservingElement("click", this);

	        OpenScalesEvent.stopObservingElement("click", this._minimizeButton);
	        OpenScalesEvent.stopObservingElement("click", this._maximizeButton);
	        	        
	        this.map.events.unregister("addlayer", this, this.draw);
	        this.map.events.unregister("changelayer", this, this.draw);
	        this.map.events.unregister("removelayer", this, this.draw);
	        this.map.events.unregister("changebaselayer", this, this.draw);
	        
	        super.destroy();
		}
		
		override public function setMap(map:Map):void {
			super.setMap(map);

	        this.map.events.register("addlayer", this, this.draw);
	        this.map.events.register("changelayer", this, this.draw);
	        this.map.events.register("removelayer", this, this.draw);
	        this.map.events.register("changebaselayer", this, this.draw);
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
						var layerTextField:TextField = new TextField();
						layerTextField.text=layer.name;
						layerTextField.setTextFormat(contentFormat);
						layerTextField.x = this.position.x - 170;
						layerTextField.y = y;
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
					var layer:Layer = this.map.layers[i] as Layer;
					if(layer.isBaseLayer==false) {
						y+=this._textOffset;
						var layerTextField:TextField = new TextField();
						layerTextField.text=layer.name;
						layerTextField.setTextFormat(contentFormat);
						layerTextField.x = this.position.x - 170;
						layerTextField.y = y;
						this.addChild(layerTextField);
					}
				}
			
				this.addChild(_minimizeButton);
			}
		}
		
		private function minMaxButtonClick(event:MouseEvent):void {
			this._minimized = !this._minimized;
			this.draw();
		}
		
		
	}
}