package org.openscales.core.control
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.ui.Button;

	/**
	 * Control showing some arrows to be able to pan the map and zoom in/out.
	 */
	public class PanZoom extends Control
	{

		public static var X:int = 4;
		public static var Y:int = 4;
		private var _slideFactor:int = 50;
		private var _buttons:Vector.<Button> = null;
		private var _tween:Boolean;

		[Embed(source="/assets/images/north-mini.png")]
		protected var northMiniImg:Class;

		[Embed(source="/assets/images/west-mini.png")]
		protected var westMiniImg:Class;

		[Embed(source="/assets/images/east-mini.png")]
		protected var eastMiniImg:Class;

		[Embed(source="/assets/images/south-mini.png")]
		protected var southMiniImg:Class;

		[Embed(source="/assets/images/zoom-plus-mini.png")]
		protected var zoomPlusMiniImg:Class;

		[Embed(source="/assets/images/zoom-minus-mini.png")]
		protected var zoomMinusMiniImg:Class;

		[Embed(source="/assets/images/zoom-world-mini.png")]
		protected var zoomWorldMiniImg:Class;

		[Embed(source="/assets/images/slider.png")]
		protected var sliderImg:Class;

		[Embed(source="/assets/images/zoombar.png")]
		protected var zoombarImg:Class;

		public function PanZoom(position:Pixel = null, tween:Boolean = true) {
			this._tween = tween;
			super(position);
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
			this.buttons = new Vector.<Button>();

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
					this.map.pan(0, -100, this._tween);
					break;
				case "pandown": 
					this.map.pan(0, 100, this._tween);
					break;
				case "panleft": 
					this.map.pan(-100, 0, this._tween);
					break;
				case "panright": 
					this.map.pan(100, 0, this._tween);
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

		public function get buttons():Vector.<Button> {
			return this._buttons;   
		}

		public function set buttons(value:Vector.<Button>):void {
			this._buttons = value;   
		}

	}
}

