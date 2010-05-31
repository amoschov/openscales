package org.openscales.core.basetypes
{
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.LinearRing;
	import org.openscales.geometry.Point;
	import org.openscales.geometry.Polygon;
	import org.openscales.proj4as.Proj4as;
	import org.openscales.proj4as.ProjPoint;
	import org.openscales.proj4as.ProjProjection;

	/**
	 * Instances of this class represent bounding boxes.
	 * Data stored as left, bottom, right, top floats.
	 * All values are initialized to 0, however, you should make sure you set them
	 * before using the bounds for anything.
	 */
	public class Bounds
	{
		private var _left:Number = 0.0;
		private var _bottom:Number = 0.0;
		private var _right:Number = 0.0;
		private var _top:Number = 0.0;

		/**
		 * Class constructor
		 *
		 * @param left Left bound of Bounds instance
		 * @param bottom Bottom bound of Bounds instance
		 * @param right Right bound of Bounds instance
		 * @param top Top bound of Bounds instance
		 */
		public function Bounds(left:Number = NaN, bottom:Number = NaN, right:Number = NaN, top:Number = NaN)
		{
			if (!isNaN(left)) {
				this.left = left;
			}
			if (!isNaN(bottom)) {
				this.bottom = bottom;
			}
			if (!isNaN(right)) {
				this.right = right;
			}
			if (!isNaN(top)) {
				this.top = top;
			}
		}

		public function clone():Bounds {
			return new Bounds(this.left, this.bottom, this.right, this.top);
		}

		/**
		 * Determines if the bounds passed as param is equal to current instance
		 *
		 * @param bounds Bounds to check equality
		 * @return It is equal or not
		 */
		public function equals(bounds:Bounds):Boolean {
			var equals:Boolean = false;
			if (bounds != null) {
				equals = this.left == bounds.left &&
					this.right == bounds.right &&
					this.top == bounds.top &&
					this.bottom == bounds.bottom;
			}
			return equals;
		}

		public function toString():String {
			return "left-bottom=(" + this.left + "," + this.bottom + ")"
				+ " right-top=(" + this.right + "," + this.top + ")";
		}

		/**
		 * Return a bbox string separating the bounds, with the decimal number passed as param, by commas.
		 *
		 * @param decimal Bounds number of decimals.
		 * @return The bounds separated by commas.
		 */  
		public function boundsToString(decimal:Number = -1):String {
			if (decimal == -1) {
				decimal = 9;
			}
			var mult:Number = Math.pow(10, decimal);
			var bbox:String = Math.round(this.left * mult) / mult + "," +
				Math.round(this.bottom * mult) / mult + "," +
				Math.round(this.right * mult) / mult + "," +
				Math.round(this.top * mult) / mult;
			return bbox;
		}

		// Getters & setters for _left, _bottom, _right and _top

		public function get left():Number {
			return _left;
		}
		public function set left(value:Number):void {
			_left = value;
		}

		public function get bottom():Number {
			return _bottom;
		}
		public function set bottom(value:Number):void {
			_bottom = value;
		}

		public function get right():Number {
			return _right;
		}
		public function set right(value:Number):void {
			_right = value;
		}

		public function get top():Number {
			return _top;
		}
		public function set top(value:Number):void {
			_top = value;
		}

		// Getters for width, height and size

		public function get width():Number {
			return Math.abs(this.right - this.left);
		}

		public function get height():Number {
			return Math.abs(this.top - this.bottom);
		}

		public function get size():Size {
			return new Size(this.width, this.height);
		}

		/*public function get center():Abstract2D {
			return new Abstract2D((this.left + this.right) / 2, (this.bottom + this.top) / 2);
		}*/

		public function get centerPixel():Pixel {
			return new Pixel((this.left + this.right) / 2, (this.bottom + this.top) / 2);
		}

		public function get centerLonLat():LonLat {
			return new LonLat((this.left + this.right) / 2, (this.bottom + this.top) / 2);
		}

		public function add(x:Number, y:Number):Bounds {
			return new Bounds(this.left + x, this.bottom + y, this.right + x, this.top + y);
		}

		/**
		 * Extends the current instance of Bounds from a LonLat.
		 *
		 * @param lonlat The LonLat which will extend the bounds.
		 */
		public function extendFromLonLat(lonlat:LonLat):void {
			this.extendFromBounds(new Bounds(lonlat.lon, lonlat.lat, lonlat.lon, lonlat.lat));
		}

		/**
		 * Extends the current instance of Bounds from bounds.
		 *
		 * @param bounds The bounds which will extend the current bounds.
		 */
		public function extendFromBounds(bounds:Bounds):void {
			this.left = (bounds.left < this.left) ? bounds.left : this.left;
			this.bottom = (bounds.bottom < this.bottom) ? bounds.bottom : this.bottom;
			this.right = (bounds.right > this.right) ? bounds.right : this.right;
			this.top = (bounds.top > this.top) ? bounds.top : this.top;
		}

		/**
		 * Returns if the current bounds contains the LonLat passed as param
		 *
		 * @param ll The Lonlat to check
		 * @param inclusive It will include the border's bounds ?
		 * @return Lonlat is contained or not by the bounds
		 */
		public function containsLonLat(ll:LonLat, inclusive:Boolean = true):Boolean {
			return this.contains(ll.lon, ll.lat, inclusive);
		}

		/**
		 * Returns if the current bounds contains the Pixel passed as param
		 *
		 * @param px The Pixel to check
		 * @param inclusive It will include the border's bounds ?
		 *
		 * @return Lonlat is contained or not by the bounds
		 */
		public function containsPixel(px:Pixel, inclusive:Boolean = true):Boolean {
			return this.contains(px.x, px.y, inclusive);
		}

		/**
		 * Returns if the current bounds contains the coordinates passed ad param
		 * 
		 * @param x the x coordinate
		 * @param y the y coordinate
		 * @param inclusive It will include the border's bounds ?
		 * 
		 * @return true if coordinates are in the bounds, else false
		 */
		public function contains(x:Number, y:Number, inclusive:Boolean = true):Boolean {
			var contains:Boolean = false;
			if (inclusive) {
				contains = ((x >= this.left) && (x <= this.right) &&
					(y >= this.bottom) && (y <= this.top));
			} else {
				contains = ((x > this.left) && (x < this.right) &&
					(y > this.bottom) && (y < this.top));
			}
			return contains;
		}

		/**
		 * Determines if the bounds passed in param intersects the current bounds.
		 *
		 * @param bounds The bounds to test intersection.
		 * @param inclusive It will include the border's bounds ?
		 *
		 * @return If the bounds intersects current bounds or not.
		 */
		public function intersectsBounds(bounds:Bounds, inclusive:Boolean = true):Boolean {
			var inBottom:Boolean = (bounds.bottom == this.bottom && bounds.top == this.top) ?
				true : (((bounds.bottom > this.bottom) && (bounds.bottom < this.top)) ||
				((this.bottom > bounds.bottom) && (this.bottom < bounds.top)));
			var inTop:Boolean = (bounds.bottom == this.bottom && bounds.top == this.top) ?
				true : (((bounds.top > this.bottom) && (bounds.top < this.top)) ||
				((this.top > bounds.bottom) && (this.top < bounds.top)));
			var inRight:Boolean = (bounds.right == this.right && bounds.left == this.left) ?
				true : (((bounds.right > this.left) && (bounds.right < this.right)) ||
				((this.right > bounds.left) && (this.right < bounds.right)));
			var inLeft:Boolean = (bounds.right == this.right && bounds.left == this.left) ?
				true : (((bounds.left > this.left) && (bounds.left < this.right)) ||
				((this.left > bounds.left) && (this.left < bounds.right)));

			return (this.containsBounds(bounds, true, inclusive) ||
				bounds.containsBounds(this, true, inclusive) ||
				((inTop || inBottom ) && (inLeft || inRight )));
		}

		/**
		 * Returns if the current bounds contains the bounds passed as param
		 *
		 * @param bounds The bounds to check
		 * @param partial Partial containing shoulds return true ?
		 * @param inclusive It will include the border's bounds ?
		 *
		 * @return Bounds are contained or not by the bounds
		 */
		public function containsBounds(bounds:Bounds, partial:Boolean = false, inclusive:Boolean = true):Boolean {
			var inLeft:Boolean;
			var inTop:Boolean;
			var inRight:Boolean;
			var inBottom:Boolean;

			if (inclusive) {
				inLeft = (bounds.left >= this.left) && (bounds.left <= this.right);
				inTop = (bounds.top >= this.bottom) && (bounds.top <= this.top);
				inRight= (bounds.right >= this.left) && (bounds.right <= this.right);
				inBottom = (bounds.bottom >= this.bottom) && (bounds.bottom <= this.top);
			} else {
				inLeft = (bounds.left > this.left) && (bounds.left < this.right);
				inTop = (bounds.top > this.bottom) && (bounds.top < this.top);
				inRight= (bounds.right > this.left) && (bounds.right < this.right);
				inBottom = (bounds.bottom > this.bottom) && (bounds.bottom < this.top);
			}

			return (partial) ? (inTop || inBottom ) && (inLeft || inRight )
				: (inTop && inLeft && inBottom && inRight);
		}

		/**
		 * Determines in which quadrant is placed the lonlat in relation to the current bounds.
		 *
		 * @param lonlat The lonlat we want to know the quadrant
		 *
		 * @return A string describing the quadrant (e.g. "bl" for Bottom-Left, "tr" for Top-Right etc.)
		 */
		public function determineQuadrant(lonlat:LonLat):String {
			var quadrant:String = "";
			var center:LonLat = this.centerLonLat;

			/* quadrant += (lonlat.lat < center.lat) ? "b" : "t";
			 quadrant += (lonlat.lon < center.lon) ? "l" : "r"; */

			if (lonlat.lat < center.lat){
				quadrant += "b";
			}
			else{
				quadrant += "t";
			}

			if(lonlat.lon < center.lon){
				quadrant += "l";
			}
			else{
				quadrant += "r";
			}

			return quadrant;
		}

		/**
		 * Returns a bounds instance from a string following this format: "left,bottom,right,top".
		 *
		 * @param str The string from which we want create a bounds instance.
		 *
		 * @return An instance of bounds.
		 */
		public static function getBoundsFromString(str:String):Bounds {
			var bounds:Array = str.split(",");
			return Bounds.getBoundsFromArray(bounds);
		}

		/**
		 * Returns a bounds instance from an array following this format: [left,bottom,right,top].
		 *
		 * @param bbox The array from which we want create a bounds instance.
		 *
		 * @return An instance of bounds.
		 */
		public static function getBoundsFromArray(bbox:Array):Bounds {
			return new Bounds(Number(bbox[0]), Number(bbox[1]), Number(bbox[2]), Number(bbox[3]));
		}

		/**
		 * Returns a bounds instance from a size instance.
		 *
		 * @param size The size instance from which we want create a bounds instance.
		 *
		 * @return An instance of bounds.
		 */
		public static function getBoundsFromSize(size:Size):Bounds {
			return new Bounds(0, size.h, size.w, 0);
		}

		/**
		 * Returns the opposite quadrant compared to the quadrant where is placed
		 * the lonlat in relation to the current bounds.
		 *
		 * @param quadrant The quadrant to opposite
		 *
		 * @return A string describing the opposite quadrant
		 */
		public static function oppositeQuadrant(quadrant:String):String {
			var opp:String = "";

			opp += (quadrant.charAt(0) == 't') ? 'b' : 't';
			opp += (quadrant.charAt(1) == 'l') ? 'r' : 'l';

			return opp;
		}

		/**
		 * Returns a bounds string from an url containing the bbox param
		 *
		 * @param url The url from which we want extract the bounds.
		 * @return A string describing the bounds contained by the url.
		 */
		public static function getBBOXStringFromUrl(url:String):String {
			var startpos:int = url.indexOf("BBOX=") + 5;
			if (startpos < 5) {
				startpos = url.indexOf("bbox=") + 5;
			}
			var endpos:int = url.indexOf("%26", startpos);
			if (endpos < 0) {
				endpos = url.length;
			}
			var tempBbox:String = url.substring(startpos, endpos);
			var tempBboxArr:Array = tempBbox.split("%2C");
			return tempBboxArr[0] + "," + tempBboxArr[1] + " " + tempBboxArr[2] + "," + tempBboxArr[3];
		}

		/**
		 * Returns a bounds string from an instance of bounds
		 *
		 * @param bounds The bounds from which we want a string
		 * @return A string describing the bounds.
		 */
		public static function getBBOXStringFromBounds(bounds:Bounds):String {
			return bounds.left + "," + bounds.bottom + " " + bounds.right + "," + bounds.top;
		}
		
		/**
		 * Method to convert the bounds from a projection system to an other.
		 *
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		public function transform(source:ProjProjection, dest:ProjProjection):void {
			var pLB:ProjPoint = new ProjPoint(this._left, this._bottom);
			var pRT:ProjPoint = new ProjPoint(this._right, this._top);
			Proj4as.transform(source, dest, pLB);
			Proj4as.transform(source, dest, pRT);
			this._left = pLB.x; this._bottom = pLB.y;
			this._right = pRT.x; this._top = pRT.y;
		}

		/**
     	 * Create a new polygon geometry based on this bounds.
     	 *
     	 * @return A new polygon with the coordinates of this bounds.
     	 */
    	 public function toGeometry():Polygon {
        	 return new Polygon(new <Geometry>[
            	 new LinearRing(new <Number>[
                	 this.left, this.bottom,
                	 this.right, this.bottom,
                	 this.right, this.top,
                	 this.left, this.top])
         	]);
    	 }
	}
}

