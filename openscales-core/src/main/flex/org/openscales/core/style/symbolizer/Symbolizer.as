package org.openscales.core.style.symbolizer
{
	public class Symbolizer
	{
		private var _geometry:String;
		
		public function Symbolizer()
		{
		}
		
		/**
		 * The name of the geometry attribute of the rule that will be rendered using the symbolizer
		 */
		public function get geometry():String{
			
			return this._geometry;
		}
		
		public function set geometry(value:String):void{
			
			this._geometry = value;
		}

	}
}