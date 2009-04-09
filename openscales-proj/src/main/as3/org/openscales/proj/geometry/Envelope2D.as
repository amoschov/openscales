package org.openscales.proj.geometry {
	
	import flash.geom.Rectangle;
	
	import org.opengis.geometry.IDirectPosition;
	import org.opengis.geometry.IEnvelope;
	import org.opengis.referencing.crs.ICoordinateReferenceSystem;
	
	public class Envelope2D extends Rectangle implements IEnvelope {
		
		/** The coordinate reference system for this envelope; */
		private var _crs:ICoordinateReferenceSystem;
		
		public function Envelope2D(minDP:DirectPosition2D, maxDP:DirectPosition2D) {
			super(	Math.min(minDP.x, maxDP.x),
					Math.min(minDP.y, maxDP.y),
					Math.abs(maxDP.x - minDP.x),
					Math.abs(maxDP.y - minDP.y));

			 this._crs = minDP.coordinateReferenceSystem;
			 if (minDP.coordinateReferenceSystem != maxDP.coordinateReferenceSystem) {
			 	throw new Error("Envelope2D constructor error : different CRS for the two positions.");;
			 }
		}

		public function getLowerCorner():IDirectPosition {
			return new DirectPosition2D(this.bottomRight.x, this.bottomRight.y, this._crs);
		}
		
		public function getUpperCorner():IDirectPosition {
			return new DirectPosition2D(this.topLeft.x, this.topLeft.y, this._crs);
		}

		public function getCenter():IDirectPosition {
			return new DirectPosition2D(getMedian(0), getMedian(1), this._crs);
		}
		
		public function get dimension():Number {
			return 2;
		}
		
		public function getMinimum(dimension:int):Number {
			switch (dimension) {
				case 0: return this.left;
				case 1: return this.bottom;
			}
			return 0;
		}
		
		public function getMaximum(dimension:int):Number {
			switch (dimension) {
				case 0: return this.right;
				case 1: return this.top;
			}
			return 0;
		}
		
		public function getMedian(dimension:int):Number {
			switch (dimension) {
				case 0: return this.left + (width / 2);
				case 1: return this.bottom + (height / 2);
			}
			return 0;
		}
		
		public function getSpan(dimension:int):Number {
			switch (dimension) {
				case 0: return this.width;
				case 1: return this.height;
			}
			return 0;
		}
		
	}
}