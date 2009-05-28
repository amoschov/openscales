package org.openscales.core.control
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.ui.Button;
	
	public class PanZoom extends Control
	{
		
		public static var X:int = 4;
		public static var Y:int = 4;
		private var _slideFactor:int = 50;
		private var _buttons:Array = null;
		
		[Embed(source="/org/openscales/core/img/north-mini.png")]
        protected var northMiniImg:Class;
        
		[Embed(source="/org/openscales/core/img/west-mini.png")]
        protected var westMiniImg:Class;
        
        [Embed(source="/org/openscales/core/img/east-mini.png")]
        protected var eastMiniImg:Class;
        
        [Embed(source="/org/openscales/core/img/south-mini.png")]
        protected var southMiniImg:Class;
        
        [Embed(source="/org/openscales/core/img/zoom-plus-mini.png")]
        protected var zoomPlusMiniImg:Class;
        
        [Embed(source="/org/openscales/core/img/zoom-minus-mini.png")]
        protected var zoomMinusMiniImg:Class;
        
        [Embed(source="/org/openscales/core/img/zoom-world-mini.png")]
        protected var zoomWorldMiniImg:Class;
		
		[Embed(source="/org/openscales/core/img/slider.png")]
        protected var sliderImg:Class;
        
        [Embed(source="/org/openscales/core/img/zoombar.png")]
        protected var zoombarImg:Class;
		
		public function PanZoom(options:Object = null):void {
		    
		    super(options);
		}
		
		override public function destroy():void {
			super.destroy();
	        while(this.buttons.length) {
	            var btn:Button = this.buttons.shift();
	            btn.removeEventListener(MouseEvent.CLICK, this.click);
	            btn.removeEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClick);
	        }
	        this.buttons = null;
	        this.position = null;
		}
		
		
		override public function draw():void {
	        super.draw();
	        
	        var px:Pixel = this.position;
	
	        // place the controls
	        this.buttons = new Array();
	
	        var sz:Size = new Size(18,18);

	        var centered:Pixel = new Pixel(this.x+sz.w/2, this.y);
	
	        this._addButton("panup", new northMiniImg(), centered, sz);
	        px.y = centered.y+sz.h;
	        this._addButton("panleft", new westMiniImg(), px, sz);
	        this._addButton("panright", new eastMiniImg(), px.add(sz.w, 0), sz);
	        this._addButton("pandown", new southMiniImg(), centered.add(0, sz.h*2), sz);
	        this._addButton("zoomin", new zoomPlusMiniImg(), centered.add(0, sz.h*3+5), sz);
	        this._addButton("zoomworld", new zoomWorldMiniImg(), centered.add(0, sz.h*4+5), sz);
	        this._addButton("zoomout", new zoomMinusMiniImg(), centered.add(0, sz.h*5+5), sz);
	        
		}
		
		/**
		 * Add button
		 * 
		 * @param name
		 * @param image
		 * @param xy
		 * @param sz
		 * @param alt
		 */
		public function _addButton(name:String, image:Bitmap, xy:Pixel, sz:Size, alt:String = null):void {
	        
	        var btn:Button = new Button(name, image, xy, sz);
	        
	        this.addChild(btn);
	
	        btn.addEventListener(MouseEvent.CLICK, this.click);
        	btn.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClick);
        	
	        this.buttons.push(btn);
		}
		
		//Events
		
		public function doubleClick(evt:Event):Boolean {
			evt.stopPropagation();
        	return false;
		}
		
		public function click(evt:Event):void {
			if (!(evt.type == MouseEvent.CLICK)) return;
		
			var btn:Button = evt.currentTarget as Button;
	
	        switch (btn.name) {
	            case "panup": 
	                this.map.pan(0, -100, Map.tween);
	                break;
	            case "pandown": 
	                this.map.pan(0, 100, Map.tween);
	                break;
	            case "panleft": 
	                this.map.pan(-100, 0, Map.tween);
	                break;
	            case "panright": 
	                this.map.pan(100, 0, Map.tween);
	                break;
	            case "zoomin": 
	                this.map.zoom++; 
	                break;
	            case "zoomout": 
	                this.map.zoom--; 
	                break;
	            case "zoomworld": 
	                this.map.zoomToMaxExtent(); 
	                break;
	        }
		}
		
		//Getters and setters.
		
		public function get slideFactor():int {
			return this._slideFactor;   
		}
		
		public function set slideFactor(value:int):void {
			this._slideFactor = value;   
		}
		
		public function get buttons():Array {
			return this._buttons;   
		}
		
		public function set buttons(value:Array):void {
			this._buttons = value;   
		}
		
	}
}