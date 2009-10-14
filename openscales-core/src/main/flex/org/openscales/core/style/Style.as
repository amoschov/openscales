package org.openscales.core.style
{
	
	import org.openscales.core.style.symbolizer.Fill;
	import org.openscales.core.style.symbolizer.LineSymbolizer;
	import org.openscales.core.style.symbolizer.Mark;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.core.style.symbolizer.Stroke;
	
	/**
	 * Style describe graphical attributes used to render vectors.
	 */
	public class Style
	{
		
		private var _name:String = "Default";
		
		/**
		 * The list of rules of the style
		 */
		private var _rules:Array = [];

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

		public static function getDefaultPointStyle():Style{
			
			var fill:Fill = new Fill(0xF2620F,0.7);
			var stroke:Stroke = new Stroke(0xA6430A,1);
			
			var mark:Mark = new Mark(Mark.WKN_SQUARE,fill,stroke);
			
			var symbolizer:PointSymbolizer = new PointSymbolizer();
			symbolizer.graphic = mark;
			
			var rule:Rule = new Rule();
			rule.symbolizers.push(symbolizer);
			
			var style:Style = new Style();
			style.rules.push(rule);
			return style;
		}
		
		public static function getDrawLineStyle():Style{
			
			var stroke:Stroke = new Stroke(0x60D980,1);
			var symbolizer:LineSymbolizer = new LineSymbolizer(stroke);
			
			var rule:Rule = new Rule();
			rule.symbolizers.push(symbolizer);
			
			var style:Style = new Style();
			style.name = "Draw linear style";
			style.rules.push(rule);
			
			return style;
		}
		
		public static function getDefaultLineStyle():Style{
			
			var rule:Rule = new Rule();
			rule.symbolizers.push(new LineSymbolizer(new Stroke(0x184054,3)));
			rule.symbolizers.push(new LineSymbolizer(new Stroke(0x40A6D9,1)));
			
			var style:Style = new Style();
			style.name = "Linear style";
			style.rules.push(rule);
			return style;
		}
		
		public static function getDrawSurfaceStyle():Style{
			
			var fill:Fill = new Fill(0xE4EDF2,0.4);
			var stroke:Stroke = new Stroke(0xE7FF33,3);
			
			var rule:Rule = new Rule();
			rule.symbolizers.push(new PolygonSymbolizer(fill,stroke));
			
			var style:Style = new Style();
			style.name = "Draw surface style";
			style.rules.push(rule);
			
			return style;
		}
		
		public static function getDefaultSurfaceStyle():Style{
			
			var fill1:Fill = new Fill();
			fill1.color = 0x99D0F2;
			fill1.opacity = 0.4;
			
			var stroke1:Stroke = new Stroke();
			stroke1.width = 1;
			stroke1.color = 0x96A621;
			
			var stroke2:Stroke = new Stroke();
			stroke2.width = 4;
			stroke2.color = 0xffffff;
			
			var ps1:PolygonSymbolizer = new PolygonSymbolizer(fill1,stroke2);
			var ps2:PolygonSymbolizer = new PolygonSymbolizer(null,stroke1);
			
			var rule:Rule = new Rule();
			rule.symbolizers.push(ps1);
			rule.symbolizers.push(ps2);
			
			var style:Style = new Style();
			style.rules.push(rule);
			style.name = "Surface Style";
			
			return style;
		}
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
		/**
		 * A name for the style
		 */
		public function get name():String{
			
			return this._name;
		}
		
		public function set name(value:String):void{
			
			this._name = value;
		}
		
		/**
		 * The list of the rules defining the style
		 */ 
		public function get rules():Array{
			
			return this._rules;
		}
		
		public function set rules(value:Array):void{
			
			this._rules = value;
		}
		
		/*
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
		}*/

	}
}

