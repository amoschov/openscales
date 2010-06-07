package org.openscales.core.control
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.basetypes.Pixel;
	import org.openscales.basetypes.Size;
	import org.openscales.core.control.ui.Button;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.MapEvent;

	/**
	 * As the PanZoom control, it allows to pan and zoom in/out the map.
	 * It adds a vertical slider for zooming functionality
	 */
	public class PanZoomBar extends PanZoom
	{

		private var _zoomStopWidth:Number = 18;

		private var _zoomStopHeight:Number = 11;

		private var _slider:DisplayObject = null;

		private var _zoomBar:DisplayObject = null;

		private var _startTop:Number = NaN;

		private var _mouseDragStart:Pixel = null;

		private var _zoomStart:Pixel = null;

		public function PanZoomBar(position:Pixel = null) {
			super(position);
		}

		override public function destroy():void {
			this.removeChild(this.slider);
			this.slider = null;

			this.removeChild(this.zoomBar);
			this.zoomBar = null;

			this.map.removeEventListener(MapEvent.ZOOM_END,this.moveZoomBar);
			this.map.removeEventListener(LayerEvent.BASE_LAYER_CHANGED,this.redraw);

			super.destroy();
		}


		/**
		 * Get the existing map
		 *
		 * @param value
		 */
		override public function set map(map:Map):void {
			super.map = map;
			this.map.addEventListener(LayerEvent.BASE_LAYER_CHANGED,this.redraw);
		}

		/**
		 * Refresh
		 *
		 * @param obt
		 */
		public function redraw(obt:Object = null):void {
			if (this != null) {
				var i:int = this.numChildren;
				for(i;i>0;--i) {
					removeChildAt(0);
				}
			}
			this.draw();
		}

		/**
		 * Draw buttons for zoom and pan of the map
		 */
		override public function draw():void {

			this.buttons = new Vector.<Button>();
			var px:Pixel = this.position;
			var sz:Size = new Size(18,18);

			var centered:Pixel = new Pixel(this.x+sz.w/2, this.y);

			this._addButton("panup", new northMiniImg(), centered, sz, "Pan Up");
			px.y = centered.y+sz.h;
			this._addButton("panleft", new westMiniImg(), px, sz, "Pan Left");
			this._addButton("panright", new eastMiniImg(), px.add(sz.w, 0), sz, "Pan Right");
			this._addButton("pandown", new southMiniImg(), centered.add(0, sz.h*2), sz, "Pan Down");
			this._addButton("zoomin", new zoomPlusMiniImg(), centered.add(0, sz.h*3+5), sz, "Zoom In");
			centered = this._addZoomBar(centered.add(0, sz.h*4 + 5));
			this._addButton("zoomout", new zoomMinusMiniImg(), centered, sz, "Zoom Out");

		}

		/**
		 * Add zoom bar (slider)
		 *
		 * @param centered
		 *
		 * @return Pixel
		 */
		public function _addZoomBar(centered:Pixel):Pixel {

			var zoomsToEnd:int = this.map.baseLayer.numZoomLevels - 1 - this.map.zoom;
			var sz:Size = new Size(20,9);
			this.slider =new Button("slider",new sliderImg(),new Pixel(centered.x - 1,centered.y + zoomsToEnd * this.zoomStopHeight),sz);
			
			
			slider.addEventListener(MouseEvent.MOUSE_DOWN, this.zoomBarDown);

			slider.addEventListener(MouseEvent.MOUSE_UP, this.zoomBarUp);
		

			
			this.zoomBar=new Button("zooomBar",new zoombarImg(),centered,sz);
			
			zoomBar.width = this.zoomStopWidth;
			zoomBar.height = this.zoomStopHeight * this.map.baseLayer.numZoomLevels;

			zoomBar.addEventListener(MouseEvent.MOUSE_DOWN, this.zoomBarClick);
			zoomBar.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClick);
			zoomBar.addEventListener(MouseEvent.CLICK, this.doubleClick);

			this.addChild(this.zoomBar);

			this.startTop = int(this.zoomBar.y);
			this.addChild(slider);

			this.map.addEventListener(MapEvent.ZOOM_END,this.moveZoomBar);

			centered = centered.add(0, 
				this.zoomStopHeight * this.map.baseLayer.numZoomLevels);
			return centered; 
		}

		//Slide Event

		public function passEventToSlider(evt:MouseEvent):void {
			//this.sliderEvents.handleBrowserEvent(evt);
		}

		public function zoomBarClick(evt:MouseEvent):void {
			var y:Number = evt.stageY;
			var top:Number = Util.pagePosition(evt.currentTarget)[1];
			var levels:Number = Math.floor((y - top)/this.zoomStopHeight);
			this.map.zoom = (this.map.baseLayer.numZoomLevels -1) -  levels;
			evt.stopPropagation();
		}

		public function zoomBarDown(evt:MouseEvent):void {
			this.mouseDragStart = new Pixel(map.mouseX, map.mouseY);
			this.zoomStart = new Pixel(evt.stageX, evt.stageY);
			this.useHandCursor = true;
			slider.addEventListener(MouseEvent.MOUSE_MOVE, this.zoomBarDrag);
			evt.stopPropagation();
		}

		public function zoomBarDrag(evt:MouseEvent):void {
			if (this.mouseDragStart != null) {
				var deltaY:Number = this.mouseDragStart.y - map.mouseY;
				var offsets:Array = Util.pagePosition(this.zoomBar);
				if ((map.mouseY - offsets[1]) > 0 && 
					(map.mouseY - offsets[1]) < int(this.zoomBar.height) - 2) {
					var newTop:Number = int(this.slider.y) - deltaY;
					this.slider.y = int(this.slider.y) - deltaY;
				}
				this.mouseDragStart = new Pixel(map.mouseX, map.mouseY);
				evt.stopPropagation();
			}
		}

		public function zoomBarUp(evt:MouseEvent):void {
			if (this.zoomStart) {
				this.useHandCursor = false;
				
				var deltaY:Number = this.zoomStart.y - evt.stageY;
				this.map.zoom = this.map.zoom + Math.round(deltaY/this.zoomStopHeight);
				this.moveZoomBar();
				this.mouseDragStart = null;
				slider.removeEventListener(MouseEvent.MOUSE_MOVE,this.zoomBarDrag);
				
				evt.stopPropagation();
			}
		}

		public function moveZoomBar(evt:Event = null):void {
			var newTop:Number = 
				((this.map.baseLayer.numZoomLevels-1) - this.map.zoom) * 
				this.zoomStopHeight + this.startTop + 1;
			this.slider.y = newTop;
		}

		//Getters and setters

		public function get zoomStopWidth():Number {
			return this._zoomStopWidth;   
		}

		public function set zoomStopWidth(value:Number):void {
			this._zoomStopWidth = value;   
		}

		public function get zoomStopHeight():Number {
			return this._zoomStopHeight;   
		}

		public function set zoomStopHeight(value:Number):void {
			this._zoomStopHeight = value;   
		}

		public function get slider():DisplayObject {
			return this._slider;   
		}

		public function set slider(value:DisplayObject):void {
			this._slider = value;   
		}

		public function get zoomBar():DisplayObject {
			return this._zoomBar;   
		}

		public function set zoomBar(value:DisplayObject):void {
			this._zoomBar = value;   
		}

		public function get startTop():Number {
			return this._startTop;   
		}

		public function set startTop(value:Number):void {
			this._startTop = value;   
		}

		public function get mouseDragStart():Pixel {
			return this._mouseDragStart;   
		}

		public function set mouseDragStart(value:Pixel):void {
			this._mouseDragStart = value;   
		}

		public function get zoomStart():Pixel {
			return this._zoomStart;   
		}

		public function set zoomStart(value:Pixel):void {
			this._zoomStart = value;   
		}
	}
}

