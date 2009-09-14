package org.openscales.core.control
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.Map;
	import org.openscales.proj4as.ProjProjection;

	/**
	 * Control displaying the coordinates (Lon, Lat) of the current mouse position.
	 */
	public class MousePosition extends Control
	{

		private var _label:TextField = null;

		private var _prefix:String = "";

		private var _separator:String = ", ";

		private var _suffix:String = "";

		private var _numdigits:Number = 5;

		private var _granularity:int = 10;

		private var _lastXy:Pixel = null;

		private var _displayProjection:ProjProjection = null;

		public function MousePosition(position:Pixel = null) {
			super(position);

			this.label = new TextField();
			this.label.width = 150;
			var labelFormat:TextFormat = new TextFormat();
			labelFormat.size = 11;
			labelFormat.color = 0x0F0F0F;
			labelFormat.font = "Verdana";
			this.label.setTextFormat(labelFormat);
		}

		override public function draw():void {
			super.draw();
			this.addChild(label);
			this.redraw();

		}

		/**
		 * Display the coordinate where is the mouse
		 *
		 * @param evt
		 */
		public function redraw(evt:MouseEvent = null):void {
			var lonLat:LonLat;

			if (evt != null) {
				if (this.lastXy == null ||
					Math.abs(map.mouseX - this.lastXy.x) > this.granularity ||
					Math.abs(map.mouseY - this.lastXy.y) > this.granularity)
				{
					this.lastXy = new Pixel(map.mouseX, map.mouseY);
					return;
				}
				this.lastXy = new Pixel(map.mouseX, map.mouseY);
				lonLat = this.map.getLonLatFromMapPx(this.lastXy);
			}

			if (lonLat == null) {
				lonLat = new LonLat(0, 0);
			}

			if (this._displayProjection) {
				lonLat.transform(this.map.projection, this._displayProjection);
			}    

			var digits:int = int(this.numdigits);
			this.label.text =
				this.prefix +
				lonLat.lon.toFixed(digits) +
				this.separator + 
				lonLat.lat.toFixed(digits) +
				this.suffix;

		}

		override public function set map(map:Map):void {
			super.map = map;
			
			if (! this.x) {
				this.x = 10;
			}
			if (! this.y) {
				this.y = this.map.size.h - 20;
			}

			this.map.addEventListener(MouseEvent.MOUSE_MOVE,this.redraw);
			this.map.addEventListener(MapEvent.DRAG_START, this.deactivateDisplay);
			this.map.addEventListener(MapEvent.MOVE_END, this.activateDisplay);
		}

		override public function resize(event:MapEvent):void {
			this.x = 10;
			this.y = this.map.size.h - 20;
			super.resize(event);
		}
		
		private function deactivateDisplay(evt:MapEvent):void{
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE,this.redraw);
		}
		
		private function activateDisplay(evt:MapEvent):void{
			this.map.addEventListener(MouseEvent.MOUSE_MOVE,this.redraw);
		}

		/**
		 * Getters & setters
		 */
		public function get prefix():String
		{
			return _prefix;
		}
		public function set prefix(value:String):void
		{
			_prefix = value;
		}

		public function get separator():String
		{
			return _separator;
		}
		public function set separator(value:String):void
		{
			_separator = value;
		}

		public function get suffix():String
		{
			return _suffix;
		}
		public function set suffix(value:String):void
		{
			_suffix = value;
		}

		public function get numdigits():Number
		{
			return _numdigits;
		}
		public function set numdigits(value:Number):void
		{
			_numdigits = value;
		}

		public function get granularity():int
		{
			return _granularity;
		}
		public function set granularity(value:int):void
		{
			_granularity = value;
		}

		public function get lastXy():Pixel
		{
			return _lastXy;
		}
		public function set lastXy(value:Pixel):void
		{
			_lastXy = value;
		}

		public function get displayProjection():ProjProjection
		{
			return _displayProjection;
		}
		public function set displayProjection(value:ProjProjection):void
		{
			_displayProjection = value;
		}

		public function get label():TextField
		{
			return this._label;
		}
		public function set label(value:TextField):void
		{
			this._label = value;
		}
	}
}

