package org.openscales.proj.geometry {
	
	import flash.geom.Point;
	
	import org.opengis.geometry.IDirectPosition;
	import org.opengis.referencing.crs.ICoordinateReferenceSystem;
	
	public class DirectPosition2D extends Point implements IDirectPosition {
				
		/**
		 * The coordinate reference system for this position
		 */
		private var _crs:ICoordinateReferenceSystem;
		
		public function DirectPosition2D(x:Number=0, y:Number=0, crs:ICoordinateReferenceSystem=null) {
			this.x = x;
			this.y = y;
			this._crs = crs;
		}
		
		public function get coordinate():Array
		{
			return [x,y]; 
		}
		
		public function get dimension():Number
		{
			return 2;
		}
		
		public function getOrdinate(dimension:Number):Number
		{
			switch (dimension) {
				case 0: return x;
				case 1: return y;
			}
			return 0; 
		}
		
		public function setOrdinate(dimension:Number, value:Number):void
		{
			switch (dimension) {
				case 0: x=value;
				case 1: y=value;
			}
			throw new Error("DirectPosition2D - setOrdinate: invalid dimension");
		}
		
		public function get coordinateReferenceSystem():ICoordinateReferenceSystem {
			return this._crs;
		}	
		
	}
}
