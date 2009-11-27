package org.openscales.core.style.marker
{
	import flash.display.DisplayObject;
	
	/**
	 * DisplayObjectMarker defines the representation of a punctual feature 
	 * as an instance of a given that extends DisplayObject
	 */
	public class DisplayObjectMarker extends Marker
	{
		private var _c:Class;
				
		public function DisplayObjectMarker(c:Class,size:Number = 6, opacity:Number = 1, rotation:Number = 0){
		
			super(size,opacity,rotation);
		
			this._c = c;
		}
		
		override protected function generateGraphic():DisplayObject{
			
			return (new _c() as DisplayObject);
		}

	}
}