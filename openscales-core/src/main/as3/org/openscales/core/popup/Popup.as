package org.openscales.core.popup
{
	import com.gskinner.motion.GTweeny;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;

	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.ui.Button;
	import org.openscales.core.feature.Feature;

	/**
	 * Class to create a Popup.
	 * Extends Sprite.
	 */
	public class Popup extends Sprite
	{

		public static var WIDTH:Number = 300;
		public static var HEIGHT:Number = 300;
		public static var BACKGROUND:uint = 0xFFFFFF;
		public static var BORDER:Number = 2;

		private var _lonlat:LonLat = null;
		private var _size:Size = null;
		private var _background:uint;
		private var _border:Number;
		private var _map:Map = null;
		private var _textfield:TextField = null;
		private var _feature:Feature = null;
		private var _htmlText:String = null;
		private var _closeBox:Boolean;

		[Embed(source="/org/openscales/core/img/close.gif")]
		private var _closeImg:Class;

		public function Popup(lonlat:LonLat, background:uint = 0, border:Number = NaN, size:Size = null, htmlText:String = "", closeBox:Boolean = true) {

			this.lonlat = lonlat;
			this.htmlText = htmlText;
			this.closeBox = closeBox;

			this.textfield = new TextField();
			this.textfield.multiline = true;
			this.textfield.htmlText = htmlText;
			this.addChild(textfield);

			if (background > 0){
				this._background = background;
			}
			else{
				this.background = Popup.BACKGROUND;
			}

			if (!isNaN(border)){
				this._border = border;
			}
			else{
				this.border = Popup.BORDER;
			}

			if (size != null){
				this._size = size;
			}
			else{
				this.size = new Size(Popup.WIDTH,Popup.HEIGHT);
			}
		}

		public function closePopup(evt:MouseEvent):void {
			var target:Sprite = (evt.target as Sprite);
			target.removeEventListener(evt.type, closePopup);
			destroy();
			evt.stopPropagation();
		}

		public function destroy():void {
			graphics.clear();
			while (this.numChildren>0) {
				this.removeChildAt(0);
			}
			this.textfield = null;
			if (this.feature != null) {
				this.feature.destroyPopup();
				this.feature = null;
			}
			if (this.map != null) {
				this.map.removePopup(this);
				this.map = null;
			}
		}

		public function draw(px:Pixel = null):void {
			if (px == null) {
				if ((this.lonlat != null) && (this.map != null)) {
					px = this.map.getLayerPxFromLonLat(this.lonlat);
				}
			}

			this.position = px;

			this.graphics.clear();
			this.graphics.beginFill(this.background);
			this.graphics.drawRect(0,0,this.size.w, this.size.h);
			this.width = this.size.w;
			this.height = this.size.h;
			this.textfield.x = 5;
			this.textfield.y = 5;
			this.textfield.width = this.size.w-10;
			this.textfield.height = this.size.h-10;
			this.graphics.endFill();
			this.graphics.lineStyle(this.border, 0x000000);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, this.size.h);
			this.graphics.lineTo(this.size.w, this.size.h);
			this.graphics.lineTo(this.size.w, 0);
			this.graphics.lineTo(0, 0);

			if (this.closeBox == true) {

				var img:Bitmap = new this._closeImg();

				var closeImg:Button = new Button("close", img, new Pixel(this.size.w- 17 - (this.border/2), (this.border/2)));

				this.addChild(closeImg);

				closeImg.addEventListener(MouseEvent.CLICK, closePopup);
			}
			this.alpha = 0;
			var tween:GTweeny = new GTweeny(this, 0.5, {alpha:1});
		}

		//Getters and Setters
		public function set position(px:Pixel):void {
			if (px != null) {
				this.x = px.x;
				this.y = px.y;
			}
		}

		public function get position():Pixel {
			return new Pixel(this.x, this.y);
		}

		public function get size():Size {
			return this._size;

		}
		public function set size(size:Size):void {
			if (size != null) {
				this._size = size;
				this.width = this.size.w;
				this.height = this.size.h;
			}
		}

		public function get background():uint {
			return this._background;

		}
		public function set background(value:uint):void {
			this._background = value;
		}

		public function get border():Number {
			return this._border;

		}
		public function set border(value:Number):void {
			this._border = value;
		}

		public function get textfield():TextField {
			return this._textfield;

		}
		public function set textfield(value:TextField):void {
			this._textfield = value;
		}

		public function get map():Map {
			return this._map;

		}
		public function set map(value:Map):void {
			this._map = value;
		}

		public function get lonlat():LonLat {
			return this._lonlat;
		}
		public function set lonlat(value:LonLat):void {
			this._lonlat = value;
		}

		public function get feature():Feature {
			return this._feature;
		}
		public function set feature(value:Feature):void {
			this._feature = value;
		}

		public function get htmlText():String{
			return this._htmlText;
		}
		public function set htmlText(value:String):void {
			this._htmlText = value;
			if (this._textfield != null) {
				this._textfield.htmlText = value;
			}
		}

		public function get closeBox():Boolean{
			return this._closeBox;
		}
		public function set closeBox(value:Boolean):void{
			this._closeBox = value;
		}
	}
}


