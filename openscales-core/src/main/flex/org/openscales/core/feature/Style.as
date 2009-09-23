package org.openscales.core.feature
{
	/**
	 * Style describe graphical attributes used to render vectors.
	 */
	public class Style
	{

		private var _fillColor:uint;
		private var _fillOpacity:Number;
		private var _strokeColor:uint;
		private var _strokeOpacity:Number;
		private var _strokeWidth:Number;
		private var _strokeLinecap:String;
		private var _pointRadius:Number;
		private var _hoverFillColor:uint;
		private var _hoverFillOpacity:Number;
		private var _hoverStrokeColor:uint;
		private var _hoverStrokeOpacity:Number;
		private var _hoverStrokeWidth:Number;
		private var _hoverPointRadius:Number;

		private var _isFilled:Boolean;
		private var _isStroked:Boolean;

		/**
		 * <p>Class constructor.</p>
		 *
		 * <p>It defines default values for the attributes.</p>
		 */
		public function Style()
		{
			//Default values
			_fillColor = 0x00ff00;
			_fillOpacity = 0.4;
			_strokeColor = 0x00ff00;
			_strokeOpacity = 1;
			_strokeWidth = 2;
			_strokeLinecap = "round";
			_pointRadius = 6;
			_hoverFillColor = 0xffffff;
			_hoverFillOpacity = 0.2;
			_hoverStrokeColor = 0xff0000;
			_hoverStrokeOpacity = 1;
			_hoverStrokeWidth = 0.2;
			_hoverPointRadius = 1;
			_isFilled = true;
			_isStroked = true;

		}

		public function clone():Style{
			var clonedStyle:Style = new Style();
			clonedStyle._fillColor = this._fillColor;
			clonedStyle._fillOpacity = this._fillOpacity;
			clonedStyle._strokeColor = this._strokeColor;
			clonedStyle._strokeOpacity = this._strokeOpacity;
			clonedStyle._strokeWidth = this._strokeWidth;
			clonedStyle._strokeLinecap = this._strokeLinecap;
			clonedStyle._pointRadius = this._pointRadius;
			clonedStyle._hoverFillColor = this._hoverFillColor;
			clonedStyle._hoverFillOpacity = this._hoverFillOpacity;
			clonedStyle._hoverStrokeColor = this._hoverStrokeColor;
			clonedStyle._hoverStrokeOpacity = this._hoverStrokeOpacity;
			clonedStyle._hoverStrokeWidth = this._hoverStrokeWidth;
			clonedStyle._hoverPointRadius = this._hoverPointRadius;
			clonedStyle._isFilled = this._isFilled;
			clonedStyle._isStroked = this._isStroked;
			return clonedStyle;
		}
		
		/* Getters & setters */

		public function get fillColor():uint {
			return _fillColor;
		}

		public function set fillColor(fillColor:uint):void {
			_fillColor = fillColor;
		}

		public function get fillOpacity():Number {
			return _fillOpacity;
		}

		public function set fillOpacity(fillOpacity:Number):void {
			_fillOpacity = fillOpacity;
		}

		public function get strokeColor():uint {
			return _strokeColor;
		}

		public function set strokeColor(strokeColor:uint):void {
			_strokeColor = strokeColor;
		}

		public function get strokeOpacity():Number {
			return _strokeOpacity;
		}

		public function set strokeOpacity(strokeOpacity:Number):void {
			_strokeOpacity = strokeOpacity;
		}

		public function get strokeWidth():Number {
			return _strokeWidth;
		}

		public function set strokeWidth(strokeWidth:Number):void {
			_strokeWidth = strokeWidth;
		}

		public function get strokeLinecap():String {
			return _strokeLinecap;
		}

		public function set strokeLinecap(strokeLinecap:String):void {
			_strokeLinecap = strokeLinecap;
		}

		public function get pointRadius():Number {
			return _pointRadius;
		}

		public function set pointRadius(pointRadius:Number):void {
			_pointRadius = pointRadius;
		}

		public function get isFilled():Boolean {
			return _isFilled;
		}

		public function set isFilled(value:Boolean):void {
			_isFilled = value;
		}

		public function get isStroked():Boolean {
			return _isStroked;
		}

		public function set isStroked(value:Boolean):void {
			_isStroked = value;
		}

	}
}

