package org.openscales.core.feature
{
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

		
		public function Style()
		{
			//Default values
			_fillColor = 0x00ff00;
		    _fillOpacity = 0.4;
		    _strokeColor = 0x00ff00;
		    _strokeOpacity = 1;
		    _strokeWidth = 4;
		    _strokeLinecap = "round";
		    _pointRadius = 6;
		    _hoverFillColor = 0xffffff;
			_hoverFillOpacity = 0.2;
			_hoverStrokeColor = 0xff0000;
			_hoverStrokeOpacity = 1;
			_hoverStrokeWidth = 0.2;
			_hoverPointRadius = 1;
			
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

	}
}