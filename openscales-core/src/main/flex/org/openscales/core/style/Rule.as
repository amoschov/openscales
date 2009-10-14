package org.openscales.core.style
{
	import flash.display.DisplayObject;
	
	public class Rule
	{
		private var _name:String = "";
		
		private var _title:String = "";
		
		private var _abstract:String = "";
		
		private var _legendGraphic:DisplayObject = null;
		
		private var _minScaleDenominator:Number = NaN;
		
		private var _maxScaleDenominator:Number = NaN;
		
		private var _filter:Object = null;
		
		private var _symbolizers:Array = [];
		
		public function Rule()
		{
		}
		
		/**
		 * Name of the Rule
		 */
		public function get name():String{
			
			return this._name;
		}
		
		public function set name(value:String):void{
			
			this._name = value;
		}
		
		/**
		 * Human readable short description (a few words and less than one line preferably)
		 */
		public function get title():String{
			
			return this._title;
		}
		
		public function set title(value:String):void{
			
			this._title = value;
		}
		
		/**
		 * Human readable description that may be several paragraph long 
		 */
		public function get abstract():String{
			
			return this._abstract;
		}
		
		public function set abstract(value:String):void{
			
			this._abstract = value;
		}
		
		/**
		 * DisplayObject reprenting a legend for the rule
		 */
		public function get legendGraphic():DisplayObject{
			
			return this._legendGraphic;
		}
		
		public function set legendGraphic(value:DisplayObject):void{
			
			this._legendGraphic = value;
		}
		
		/**
		 * The minimum scale at which the rule is active
		 */
		public function get minScaleDenominator():Number{
			
			return this._minScaleDenominator;
		}
		
		public function set minScaleDenominator(value:Number):void{
			
			this._minScaleDenominator = value;
		}
		
		/**
		 * The maximum scale at which the rule is active
		 */
		public function get maxScaleDenominator():Number{
			
			return this._maxScaleDenominator;
		}
		
		public function set maxScaleDenominator(value:Number):void{
			
			this._maxScaleDenominator = value;
		}
		
		/**
		 * A filter used to determine if the rule is active for given feature
		 */
		public function get filter():Object{
			
			return this._filter;
		}
		
		public function set filter(value:Object):void{
			
			this._filter = value;
		}

		/**
		 * The list of symbolizers defining the ruless
		 */
		public function get symbolizers():Array{
			
			return this._symbolizers;
		}
		
		public function set symbolizers(value:Array):void{
			
			this._symbolizers = value;
		}
	}
}