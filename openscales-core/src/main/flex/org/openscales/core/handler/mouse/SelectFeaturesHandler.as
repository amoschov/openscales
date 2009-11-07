package org.openscales.core.handler.mouse
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	
	/**
	 * Select Features by clicking, by drawing a select box or by drawing a
	 * freehand selection area.
	 * If the CTRL key is pressed, the previous selection is not cleared and the
	 * new selection is added.
	 * A click on a selected feature unselect it.
	 */
	public class SelectFeaturesHandler extends ClickHandler
	{
		/**
		 * Array of the layers to treat during a selection.
		 * If void (default), all the layers are managed.
		 */
		private var _layers:Array = new Array();
		
		/**
		 * Sprite used to display the selection box.
		 */
        private var drawContainer:Sprite = new Sprite();
		
		/**
		 * Style of the selection box: border thin (default=1)
		 */        
		private var _selectionBoxBorderThin:Number = 2;
		
		/**
		 * Style of the selection box: border color (default=0xFFCC00)
		 */        
		private var _selectionBoxBorderColor:uint = 0xFFCC00;
		
		/**
		 * Style of the selection box: fill color (default=0xCC0000)
		 */        
		private var _selectionBoxFillColor:uint = 0xCC0000;
		
		/**
		 * Style of the selection box: opacity (default=0.5)
		 */        
		private var _selectionBoxFillOpacity:Number = 0.33;

		/**
		 * Constructor
		 */
		public function SelectFeaturesHandler(map:Map=null, active:Boolean=false) {
			super(map, active);
			if (this.map) {
				this.map.addChild(drawContainer);
			}
			this.click = this.selectByClick;
			this.drag = this.drawSelectionBox;
			this.drop = this.selectByBox;
		}
		
		/**
		 * Layers array getter and setter
		 */
		public function get layers():Array {
			return this._layers;
		}
		public function set layers(value:Array):void {
			if (value != null) {
				this._layers = value;
			} else {
				Trace.error("SelectFeaturesHandler - invalid layers");
			}
		}
		
		/**
		 * Selection box border thin getter and setter
		 */
		public function get selectionBoxBorderThin():Number {
			return this._selectionBoxBorderThin;
		}
		public function set selectionBoxBorderThin(value:Number):void {
			this._selectionBoxBorderThin = value;
		}
		
		/**
		 * Selection box border color getter and setter
		 */
		public function get selectionBoxBorderColor():uint {
			return this._selectionBoxBorderColor;
		}
		public function set selectionBoxBorderColor(value:uint):void {
			this._selectionBoxBorderColor = value;
		}
		
		/**
		 * Selection box fill color getter and setter
		 */
		public function get selectionBoxFillColor():uint {
			return this._selectionBoxFillColor;
		}
		public function set selectionBoxFillColor(value:uint):void {
			this._selectionBoxFillColor = value;
		}
		
		/**
		 * Selection box fill opacity thin getter and setter
		 */
		public function get selectionBoxFillOpacity():Number {
			return this._selectionBoxFillOpacity;
		}
		public function set selectionBoxFillOpacity(value:Number):void {
			this._selectionBoxFillOpacity = value;
		}
		
		/**
		 * 
		 */
		override public function set map(value:Map):void {
			if (this.map) {
				this.map.removeChild(drawContainer);
			}
			super.map = value;
			if (this.map) {
				this.map.addChild(drawContainer);
			}
		}
		
		/**
		 * Add the listeners to the associated map
		 */
		override protected function registerListeners():void {
			// Listeners of the super class
			super.registerListeners();
			// Listeners of the associated map
			if (this.map) {
				// TODO
			}
		}
		
		/**
		 * Remove the listeners to the associated map
		 */
		override protected function unregisterListeners():void {
			// Listeners of the associated map
			if (this.map) {
				// TODO
			}
			// Listeners of the super class
			super.unregisterListeners();
		}
		
		/**
		 * Select all the features pointed by the mouse.
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the MouseEvent
		 */
		private function selectByClick(evt:MouseEvent):void {
			;
		}
		
		/**
		 * Select all the features pointed by the mouse.
		 * If the array of layers is defined, only the features of these layers
		 * are treated.
		 * @param evt the MouseEvent
		 */
		private function selectByBox(evt:MouseEvent):void {
			// Create a rectangle from the drawing of the select box
			var dx:Number = Math.abs(this._startPixel.x-evt.currentTarget.mouseX);
			var dy:Number = Math.abs(this._startPixel.y-evt.currentTarget.mouseY);
			var rect:Rectangle = new Rectangle(Math.min(this._startPixel.x,evt.currentTarget.mouseX), Math.min(this._startPixel.y,evt.currentTarget.mouseY), dx, dy);
			// Transform the rectangle in a boundary on the map
			//var bounds:Bounds = ;
			// Clean the selection box
			drawContainer.graphics.clear();
		}
		
		/**
		 * Select all the features pointed by the mouse
		 * @param evt the MouseEvent
		 */
		private function drawSelectionBox(evt:MouseEvent):void {
			// Compute the distance to the _startPixel
			var dx:Number = Math.abs(this._startPixel.x-evt.currentTarget.mouseX);
			var dy:Number = Math.abs(this._startPixel.y-evt.currentTarget.mouseY);
			// Display the selection box
			drawContainer.graphics.clear();
			drawContainer.graphics.lineStyle(this.selectionBoxBorderThin, this.selectionBoxBorderColor);
			drawContainer.graphics.beginFill(this.selectionBoxFillColor, this.selectionBoxFillOpacity);
			drawContainer.graphics.drawRect(Math.min(this._startPixel.x,evt.currentTarget.mouseX), Math.min(this._startPixel.y,evt.currentTarget.mouseY), dx, dy);
			drawContainer.graphics.endFill();
		}
		
	}
}